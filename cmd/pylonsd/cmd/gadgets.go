package cmd

import (
	"errors"
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

var builtinGadgets []Gadget = []Gadget{
	{"test_gadget", `{"%0" : "%1"}`, 2},
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
}
var reservedNames = []string{"include"}

// one iteration
func loadGadgetsForPath(p string, gadgets *[]Gadget) (string, string, *[]Gadget) {
	_, err := os.Stat(path.Join(p, gadgetsFilename))
	if err != nil {
		if errors.Is(err, os.ErrNotExist) {
			return "", "", nil
		} else {
			panic(err)
		}
	} else {
		bytes, err := os.ReadFile(p)
		if err != nil {
			panic(err)
		}
		parse := parseGadgets(string(bytes))
		g := append(parse, *gadgets...)
		gadgets = &g
	}
	dir, file := path.Split(p)
	return dir, file, gadgets
}

func parseGadget(header string, json string, gadgets *[]Gadget) *Gadget {
	splut := strings.Split(strings.TrimPrefix(header, "#"), " ")
	if len(splut) != 2 {
		panic(errors.New("Not a valid gadget header: \n" + header))
	}
	gadgetName := splut[0]
	if GetGadget(gadgetName, gadgets) != nil {
		panic(errors.New("Duplicate gadget name: " + gadgetName))
	}

	// we will never have enough reserved names to warrant a real search algorithm here
	for _, s := range reservedNames {
		if s == gadgetName {
			panic("Can't register a gadget of reserved name " + gadgetName)
		}
	}

	gadgetArgs, err := strconv.Atoi(splut[1])
	if err != nil {
		panic(err)
	}
	// todo: we should actually validate the json!
	return &Gadget{name: gadgetName, json: json, parametersCount: gadgetArgs}
}

func parseGadgets(s string) []Gadget {
	gadgets := []Gadget{}
	const winNewline = "\r\n"
	const normalNewline = "\n"
	var nl = normalNewline
	if strings.Contains(s, winNewline) {
		nl = winNewline
	}
	splut := strings.Split(s, nl)
	if splut[0][0] != '#' {
		panic(errors.New("pylons.gadgets file does not start with a valid gadget header")) // todo: this should specify which file, but that can wait
	}
	gadgetHeader := ""
	gadgetJson := ""
	for i, s := range splut {
		if s[0] == '#' {
			// this line is a header, so parse out the gadget we've built. unless this is the first gadget.
			if i != 0 {
				gadgets = append(gadgets, *parseGadget(gadgetHeader, gadgetJson, &gadgets))
			}
			gadgetHeader = s
			gadgetJson = ""
		} else {
			gadgetJson = gadgetJson + s
		}
	}
	// last gadget will never be parsed by the loop
	gadgets = append(gadgets, *parseGadget(gadgetHeader, gadgetJson, &gadgets))
	return gadgets
}

func ExpandGadget(gadget *Gadget, params []string) string {
	str := gadget.json
	for i := 0; i < gadget.parametersCount; i++ {
		strings.ReplaceAll(str, "%"+strconv.Itoa(i), strings.TrimSpace(params[i]))
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

func LoadGadgetsForPath(p string) *[]Gadget {
	gadgets := &builtinGadgets
	info, err := os.Stat(p)
	if err != nil {
		panic(err)
	}

	searchDir := p
	if !info.IsDir() {
		searchDir, _ = path.Split(p)
	}

	var dir string
	// refactor this to not be for/break, it's gross
	for true {
		dir, _, gadgets = loadGadgetsForPath(searchDir, gadgets)
		if dir != "" {
			searchDir = dir
		} else {
			break
		}
	}
	return gadgets
}
