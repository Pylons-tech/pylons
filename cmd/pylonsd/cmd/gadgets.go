package cmd

type Gadget struct {
	name            string
	json            string
	parametersCount int
}

const gadgetsFilename = "pylons.gadgets"

var builtinGadgets []Gadget = []Gadget{
	{"test_gadget", `{"%0" : "%1"}`, 2},
}

func LoadGadgetsForPath(path string) *[]Gadget {
	// get pylons.gadgets for the dir we're in, then for each parent dir that has one
	// read out gadget files, error check them, add them to a gadget list
	// append builtin gadgets and return
}
