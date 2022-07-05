package cmd

import (
	"errors"
	"fmt"
	"io"
	"os"
	"path/filepath"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	"github.com/gogo/protobuf/jsonpb"
)

var Out io.Writer = os.Stdout // modified during testing

const (
	cookbookExtension = ".plc"
	recipeExtension   = ".plr"
)

// const moduleExtension = ".pdt" // we don't use this yet, but we will

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

func loadCookbookFromPath(path string) (types.Cookbook, string, error) {
	bytes, _ := os.ReadFile(path)
	var cb types.Cookbook
	err := jsonpb.UnmarshalString(string(bytes), &cb)
	return cb, string(bytes), err
}

func loadRecipeFromPath(path string) (types.Recipe, string, error) {
	bytes, _ := os.ReadFile(path)
	var rcp types.Recipe
	err := jsonpb.UnmarshalString(string(bytes), &rcp)
	return rcp, string(bytes), err
}
