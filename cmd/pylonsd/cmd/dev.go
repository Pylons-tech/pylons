package cmd

import (
	"errors"
	"fmt"
	"io"
	"os"
	"path"
	"path/filepath"
	"regexp"
	"strings"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	_ "github.com/gogo/protobuf/gogoproto" //nolint:revive // imported for side effects
	"github.com/gogo/protobuf/jsonpb"
)

var Out io.Writer = os.Stdout // modified during testing

// group 1: (whole raw string tokens encapsulated ```like this```)
// group 2: (tokens not containing whitespace, separated by whitespace)
// group 3: (whatever is in front of the first whitespace)
var gadgetParamParseRegex = regexp.MustCompile(`(\s'''.*''')|(\s.\S*)|(\S*)`)

const (
	cookbookExtension = ".plc"
	recipeExtension   = ".plr"
	moduleExtension   = ".pdt"
	includeDirective  = "#include "
)

func forFile(path string, perCookbook func(path string, cookbook types.Cookbook), perRecipe func(path string, recipe types.Recipe)) {
	gadgets, err := LoadGadgetsForPath(path)
	if err != nil {
		panic(err)
	}
	if filepath.Ext(path) == cookbookExtension {
		cb, _, err := loadCookbookFromPath(path, gadgets)
		if err != nil {
			fmt.Fprintln(Out, "File ", path, " is not a cookbook - parsing error:\n", err)
		} else {
			perCookbook(path, cb)
		}
	} else if filepath.Ext(path) == recipeExtension {
		rcp, _, err := loadRecipeFromPath(path, gadgets)
		if err != nil {
			fmt.Fprintln(Out, "File ", path, " is not a recipe - parsing error:\n", err)
		} else {
			perRecipe(path, rcp)
		}
	}
}

// Calls the provided callbacks on each cookbook file or recipe file found in the provided path.
// Path is walked using filepath.Walk, so note that this can potentially take a very, very long time
// if you give it too much to do.
func ForFiles(path string, perCookbook func(path string, cookbook types.Cookbook), perRecipe func(path string, recipe types.Recipe)) {
	file, err := os.Stat(path)
	if errors.Is(err, os.ErrNotExist) {
		fmt.Fprintln(Out, "Path ", path, " not found")
	} else {
		if file.IsDir() {
			err := filepath.Walk(path, func(p string, info os.FileInfo, e error) error {
				if !info.IsDir() {
					forFile(p, perCookbook, perRecipe)
				}
				return nil
			})
			if err != nil {
				panic(err)
			}
		}
		forFile(path, perCookbook, perRecipe)
	}
}

func loadModuleFromPath(modulePath, currentPath string) string {
	bytes, err := os.ReadFile(path.Join(currentPath, modulePath+moduleExtension))
	if err != nil {
		panic(err)
	}
	return string(bytes)
}

func loadModulesInline(bytes []byte, path string, info os.FileInfo, gadgets *[]Gadget) string {
	lines := strings.Split(string(bytes), "\n")
	for i, line := range lines {
		line = strings.TrimSpace(line)
		if len(line) != 0 && line[0] == '#' {
			appendComma := line[len(line)-1] == ','
			if appendComma {
				// we know it ends w/ `,`
				line = line[:len(line)-1]
			}
			if strings.Contains(line, includeDirective) {
				modulePath := strings.TrimSpace(strings.Split(line, includeDirective)[1])
				lines[i] = loadModuleFromPath(modulePath, strings.TrimSuffix(path, info.Name())) + "\n"
			} else {
				// we know first character of line is `#`
				splut := gadgetParamParseRegex.FindAllString(line[1:], -1)
				gadget := GetGadget(strings.TrimSuffix(strings.TrimSpace(splut[0]), ","), gadgets)
				lines[i] = ExpandGadget(gadget, splut[1:])
			}
			if appendComma {
				lines[i] += ","
			}
		}
	}
	return strings.Join(lines, "\n")
}

func loadCookbookFromPath(path string, gadgets *[]Gadget) (types.Cookbook, string, error) {
	bytes, _ := os.ReadFile(path)
	info, _ := os.Stat(path)
	var cb types.Cookbook

	json := loadModulesInline(bytes, path, info, gadgets)
	err := jsonpb.UnmarshalString(json, &cb)

	return cb, json, err
}

func loadRecipeFromPath(path string, gadgets *[]Gadget) (types.Recipe, string, error) {
	bytes, _ := os.ReadFile(path)
	info, _ := os.Stat(path)
	var rcp types.Recipe

	json := loadModulesInline(bytes, path, info, gadgets)
	err := jsonpb.UnmarshalString(json, &rcp)
	return rcp, string(bytes), err
}
