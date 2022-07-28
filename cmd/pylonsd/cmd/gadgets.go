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

const err_duplicateName = "Duplicate gadget name: %s"
const err_reservedName = "Can't register a gadget of reserved name %s"
const err_noHeader = "pylons.gadgets file does not start with a valid gadget header"
const err_badHeader = "Not a valid gadget header: \n%s"

var builtinGadgets []Gadget = []Gadget{
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
		"name": "%1",`,
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
		],`,
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

// one iteration
func loadGadgetsForPath(p string, gadgets *[]Gadget) (string, string, *[]Gadget, error) {
	fpath := path.Join(p, gadgetsFilename)
	_, err := os.Stat(fpath)
	if err != nil {
		if errors.Is(err, os.ErrNotExist) {
			return "", "", nil, nil // swallow this, it's expected
		} else {
			panic(err)
		}
	} else {
		bytes, err := os.ReadFile(fpath)
		if err != nil {
			panic(err)
		}
		parse, err := parseGadgets(string(bytes))
		if err != nil {
			return "", "", nil, err
		}
		g := append(parse, *gadgets...)
		gadgets = &g
	}
	dir, file := path.Split(p)
	return dir, file, gadgets, nil
}

func parseGadget(header string, json string, gadgets *[]Gadget) (*Gadget, error) {
	splut := strings.Split(strings.TrimPrefix(header, "#"), " ")
	if len(splut) != 2 {
		panic(fmt.Errorf(err_badHeader, header))
	}
	gadgetName := splut[0]

	// we will never have enough reserved names to warrant a real search algorithm here
	for _, s := range reservedNames {
		if s == gadgetName {
			panic(fmt.Errorf(err_reservedName, gadgetName))
		}
	}

	gadget := GetGadget(gadgetName, gadgets)

	if gadget != nil {
		panic(fmt.Errorf(err_duplicateName, gadgetName))
	}

	gadgetArgs, err := strconv.Atoi(splut[1])
	if err != nil {
		return nil, err
	}
	// todo: we should actually validate the json!
	return &Gadget{name: gadgetName, json: json, parametersCount: gadgetArgs}, nil
}

func parseGadgets(s string) ([]Gadget, error) {
	gadgets := []Gadget{}
	const winNewline = "\r\n"
	const normalNewline = "\n"
	var nl = normalNewline
	if strings.Contains(s, winNewline) {
		nl = winNewline
	}
	splut := strings.Split(s, nl)
	if splut[0][0] != '#' {
		panic(errors.New(err_noHeader)) // todo: this should specify which file, but that can wait
	}
	gadgetHeader := ""
	gadgetJson := ""
	for i, s := range splut {
		str := strings.TrimSpace(s)
		if str[0] == '#' {
			// this line is a header, so parse out the gadget we've built. unless this is the first gadget.
			if i != 0 {
				gadget, err := parseGadget(gadgetHeader, gadgetJson, &gadgets)
				if err != nil {
					return nil, err
				}
				gadgets = append(gadgets, *gadget)
			}
			gadgetHeader = str
			gadgetJson = ""
		} else {
			gadgetJson = gadgetJson + str
		}
	}
	// last gadget will never be parsed by the loop
	gadget, err := parseGadget(gadgetHeader, gadgetJson, &gadgets)
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
	err := (error)(nil)
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
	// refactor this to not be for/break, it's gross
	for true {
		dir, _, gadgets, err = loadGadgetsForPath(searchDir, gadgets)
		if err != nil {
			return nil, err
		}
		if dir != "" {
			searchDir = dir
		} else {
			break
		}
	}
	return gadgets, nil
}
