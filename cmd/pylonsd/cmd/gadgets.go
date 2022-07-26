package cmd

import (
	"errors"
	"os"
	"path"
)

type Gadget struct {
	name            string
	json            string
	parametersCount int
}

const gadgetsFilename = "pylons.gadgets"

var builtinGadgets []Gadget = []Gadget{
	{"test_gadget", `{"%0" : "%1"}`, 2},
}
var reservedNames = []string{"include"}

// one iteration
func loadGadgetsForPath(d string, gadgets *[]Gadget) (string, string, *[]Gadget) {
	_, err := os.Stat(path.Join(d, gadgetsFilename))
	if err != nil {
		if errors.Is(err, os.ErrNotExist) {
			return "", "", nil
		} else {
			panic(err)
		}
	} else {
		bytes, err := os.ReadFile(d)
		if err != nil {
			panic(err)
		}
		parse := parseGadgets(string(bytes))
		g := append(parse, *gadgets...)
		gadgets = &g
	}
	dir, file := path.Split(d)
	return dir, file, gadgets
}

func parseGadgets(s string) []Gadget {
	// todo: what does a gadget file actually look like?
	// probably header, json, header, json
	//
	// #gadget 42
	// {
	//	"some_json": "true".
	//	"some_more_json": "false"
	// }
	//
	// #different_gadget 1
	// {
	//	"other_json": "true".
	//	"some_other_json": "false"
	// }
}

func LoadGadgetsForPath(p string) *[]Gadget {
	gadgets := builtinGadgets
	info, err := os.Stat(p)
	if err != nil {
		panic(err)
	}

	if info.IsDir() {
		for true {
			//f, d, gadgets := loadGadgetsForPath(p, )
		}
	} else {

	}
	// get pylons.gadgets for the dir we're in, then for each parent dir that has one
	// read out gadget files, error check them, add them to a gadget list
	// append builtin gadgets and return
}
