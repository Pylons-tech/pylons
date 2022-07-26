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

// group 1: (whole raw string tokens encapsulated '''like this'')
// group 2: (tokens not contianing whitespace, separated by whitespace)
// group 3: (whatever is in front of the first whitespace)
var gadgetParamParseRegex = regexp.MustCompile(`(\s'''.*''')|(\s.\S*)|(\S*)`)

const (
	cookbookExtension = ".plc"
	recipeExtension   = ".plr"
	moduleExtension   = ".pdt"

	includeDirective = "#include "
)

func forFile(path string, perCookbook func(path string, cookbook types.Cookbook), perRecipe func(path string, recipe types.Recipe)) {
	// this is slow, we should avoid reloading gadgets w/ every file when we can do some rewriting
	gadgets := LoadGadgetsForPath(path)
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
		} else {
			forFile(path, perCookbook, perRecipe)
		}
	}
}

func loadModuleFromPath(modulePath string, currentPath string) string {
	bytes, err := os.ReadFile(path.Join(currentPath, modulePath+moduleExtension))
	if err != nil {
		panic(err)
	}
	return string(bytes)
}

func loadModulesInline(bytes []byte, path string, info os.FileInfo, gadgets *[]Gadget) string {
	json := string(bytes)
	lines := strings.Split(json, "\n")
	for i, line := range lines {
		lineTrimmed := strings.TrimLeft(line, " ")
		if lineTrimmed[0] == '#' {
			appendComma := strings.HasSuffix(lines[i], ",")
			if strings.Contains(line, includeDirective) {
				modulePath := strings.TrimSpace(strings.Split(line, includeDirective)[1])
				lines[i] = loadModuleFromPath(modulePath, strings.TrimSuffix(path, info.Name())) + "\n"
			} else {
				splut := gadgetParamParseRegex.Split(strings.TrimPrefix(lineTrimmed, "#"), -1)
				gadget := GetGadget(strings.TrimSpace(splut[0]), gadgets)
				lines[i] = ExpandGadget(gadget, splut[1:])
			}
			if appendComma {
				lines[i] = lines[i] + "," // this is slow/clumsy but worry abt it later
			}
		}
	}
	json = strings.Join(lines, "")
	return json
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
