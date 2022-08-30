package cmd

import (
	"errors"
	"fmt"
	"os"
	"path"
	"strconv"
	"strings"
)

type Gadget struct {
	name            string
	json            string
	parametersCount int
}

const gadgetsFilename = "pylons.gadgets"

const (
	errDuplicateName = "duplicate gadget name: %s"
	errReservedName  = "can't register a gadget of reserved name %s"
	errNoHeader      = "pylons.gadgets file does not start with a valid gadget header: \n%s"
	errBadHeader     = "not a valid gadget header: \n%s"
)

var builtinGadgets = []Gadget{
	{
		"price",
		`"coinInputs": [
			{
				"coins" : [
					{
					"denom": "%0",
					"amount": "%1"
					}
				]
			}
		]`,
		2,
	},
	{
		"no_input",
		`"coinInputs": [],
		"itemInputs": []`,
		0,
	},
	{
		"no_coin_input",
		`"coinInputs": []`,
		0,
	},
	{
		"no_item_input",
		`"itemInputs": []`,
		0,
	},
	{
		"id_name",
		`"id": "%0",
		"name": "%1"`,
		2,
	},
	{
		"no_coin_output",
		`"coinOutputs": []`,
		0,
	},
	{
		"no_item_output",
		`"itemOutputs": []`,
		0,
	},
	{
		"no_item_modify_output",
		`"itemModifyOutputs": []`,
		0,
	},
	{
		"no_coin_or_item_output",
		`"coinOutputs": [],
		"itemOutputs": []`,
		0,
	},
	{
		"no_coin_or_item_modify_output",
		`"coinOutputs": [],
		"itemModifyOutputs": []`,
		0,
	},
	{
		"no_item_or_item_modify_output",
		`"itemOutputs": [],
		"itemModifyOutputs": []`,
		0,
	},
	{
		"solo_output",
		`"outputs": [
			{
				"entryIds": [
					"%0"
				],
				"weight": 1
			}
		]`,
		1,
	},
	{
		"no_output",
		`"entries": {},
		"outputs": [],`,
		0,
	},
}

var reservedNames = []string{"include"}

var gadgetCache map[string]*[]Gadget = map[string]*[]Gadget{}

// one iteration
func loadGadgetsForPath(p string, gadgets *[]Gadget) (string, string, *[]Gadget, error) {
	fpath := path.Join(p, gadgetsFilename)
	_, err := os.Stat(fpath)
	if err != nil {
		if errors.Is(err, os.ErrNotExist) {
			return "", "", gadgets, nil // swallow this, it's expected
		}
		panic(err)
	} else {
		bytes, err := os.ReadFile(fpath)
		if err != nil {
			panic(err)
		}
		var parse []Gadget
		// use the cache to avoid needlessly re-parsing gadgets we've already parsed once
		if val, ok := gadgetCache[p]; ok {
			parse = *val
		} else {
			parse, err = parseGadgets(fpath, string(bytes))
			if err != nil {
				return "", "", nil, err
			}
			gadgetCache[p] = &parse
		}
		*gadgets = append(parse, *gadgets...)
	}
	dir, file := path.Split(p)
	return dir, file, gadgets, nil
}

func parseGadget(header, json string, gadgets *[]Gadget) (*Gadget, error) {
	splut := strings.Split(strings.TrimPrefix(header, "#"), " ")
	if len(splut) != 2 {
		panic(fmt.Errorf(errBadHeader, header))
	}
	gadgetName := splut[0]

	// we will never have enough reserved names to warrant a real search algorithm here
	for _, s := range reservedNames {
		if s == gadgetName {
			panic(fmt.Errorf(errReservedName, gadgetName))
		}
	}
	gadget := GetGadget(gadgetName, gadgets)

	if gadget != nil {
		panic(fmt.Errorf(errDuplicateName, gadgetName))
	}

	gadgetArgs, err := strconv.Atoi(splut[1])
	if err != nil {
		return nil, err
	}
	// validating gadget json would be nice but actually entails a pretty serious amount of work! (#918)
	return &Gadget{name: gadgetName, json: json, parametersCount: gadgetArgs}, nil
}

func parseGadgets(path string, s string) ([]Gadget, error) {
	gadgets := []Gadget{}
	const winNewline = "\r\n"
	const normalNewline = "\n"
	nl := normalNewline
	if strings.Contains(s, winNewline) {
		nl = winNewline
	}
	splut := strings.Split(s, nl)
	if splut[0][0] != '#' {
		panic(fmt.Errorf(errNoHeader, path))
	}
	gadgetHeader := ""
	gadgetJSON := ""
	for i, s := range splut {
		if len(s) == 0 {
			continue // skip empty lines
		}
		str := strings.TrimSpace(s)
		if str[0] == '#' {
			// this line is a header, so parse out the gadget we've built. unless this is the first gadget.
			if i != 0 {
				gadget, err := parseGadget(gadgetHeader, gadgetJSON, &gadgets)
				if err != nil {
					return nil, err
				}
				gadgets = append(gadgets, *gadget)
			}
			gadgetHeader = str
			gadgetJSON = ""
		} else {
			gadgetJSON += str
		}
	}
	// last gadget will never be parsed by the loop
	gadget, err := parseGadget(gadgetHeader, gadgetJSON, &gadgets)
	if err != nil {
		return nil, err
	}
	gadgets = append(gadgets, *gadget)
	return gadgets, nil
}

func ExpandGadget(gadget *Gadget, params []string) string {
	str := gadget.json
	for i := 0; i < gadget.parametersCount; i++ {
		str = strings.ReplaceAll(str, "%"+strconv.Itoa(i), strings.TrimSpace(params[i]))
	}
	return str
}

func GetGadget(name string, gadgets *[]Gadget) *Gadget {
	// we should actually build a map of gadgets
	for _, v := range *gadgets {
		if v.name == name {
			return &v
		}
	}
	return nil
}

func LoadGadgetsForPath(p string) (*[]Gadget, error) {
	gadgets := &builtinGadgets
	searchDir := p
	var err error
	// this logic breaks if we're just starting from the working directory, but nothing it's doing needs to happen in that case anyway
	if len(p) != 0 {
		info, err := os.Stat(p)
		if err != nil {
			panic(err)
		}

		if !info.IsDir() {
			searchDir, _ = path.Split(p)
		}
	}
	var dir string
	// we will continue searching thru the tree until we return
	for {
		dir, _, gadgets, err = loadGadgetsForPath(searchDir, gadgets)
		if err != nil || dir == searchDir {
			return gadgets, err
		}
		if dir != "" {
			searchDir = dir
		} else {
			return gadgets, nil
		}
	}
}
