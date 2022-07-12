package cmd

import (
	"errors"
	"fmt"
	"io"
	"os"
	"path"
	"path/filepath"
	"strings"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	_ "github.com/gogo/protobuf/gogoproto" //nolint:revive // imported for side effects
	"github.com/gogo/protobuf/jsonpb"
)

var Out io.Writer = os.Stdout // modified during testing

const (
	cookbookExtension = ".plc"
	recipeExtension   = ".plr"
	moduleExtension   = ".pdt"

	includeDirective = "#include "
)

func forFile(path string, perCookbook func(path string, cookbook types.Cookbook), perRecipe func(path string, recipe types.Recipe)) {
	if filepath.Ext(path) == cookbookExtension {
		cb, _, err := loadCookbookFromPath(path)
		if err != nil {
			fmt.Fprintln(Out, "File ", path, " is not a cookbook - parsing error:\n", err)
		} else {
			perCookbook(path, cb)
		}
	} else if filepath.Ext(path) == recipeExtension {
		rcp, _, err := loadRecipeFromPath(path)
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
	bytes, err := os.ReadFile(path.Join(currentPath, modulePath))
	if err != nil {
		panic(err)
	}
	return string(bytes)
}

func loadModuleInline(bytes []byte, path string, info os.FileInfo) string {
	json := string(bytes)
	lines := strings.Split(json, "\n")
	for i, line := range lines {
		if strings.Contains(line, includeDirective) {
			lines[i] = loadModuleFromPath(strings.Split(line, includeDirective)[1], strings.TrimSuffix(path, info.Name())) + "\n"
		}
	}
	json = strings.Join(lines, "")
	return json
}

func loadCookbookFromPath(path string) (types.Cookbook, string, error) {
	bytes, _ := os.ReadFile(path)
	info, _ := os.Stat(path)
	var cb types.Cookbook

	json := loadModuleInline(bytes, path, info)
	err := jsonpb.UnmarshalString(json, &cb)

	return cb, json, err
}

func loadRecipeFromPath(path string) (types.Recipe, string, error) {
	bytes, _ := os.ReadFile(path)
	info, _ := os.Stat(path)
	var rcp types.Recipe

	json := loadModuleInline(bytes, path, info)
	err := jsonpb.UnmarshalString(json, &rcp)
	return rcp, string(bytes), err
}
