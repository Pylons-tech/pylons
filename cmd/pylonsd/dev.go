package main

import (
	"bytes"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"os"
	"path/filepath"
	"reflect"

	"github.com/xeipuuv/gojsonschema"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

var Out io.Writer = os.Stdout // modified during testing

const cookbookExtension = ".plc"
const recipeExtension = ".plr"
const moduleExtension = ".pdt"

const schemaPathRoot = "https://raw.githubusercontent.com/Pylons-tech/pylons_protos/main/schema/pylons/"
const dotJson = ".json"

func forFile(path string, perCookbook func(path string, cookbook types.Cookbook), perRecipe func(path string, recipe types.Recipe)) {
	if filepath.Ext(path) == cookbookExtension {
		cb, json, err := loadCookbookFromPath(path)
		if err != nil {
			fmt.Fprintln(Out, "File ", path, " is not a cookbook - parsing error:\n", err)
		} else {
			result, _ := validateJson(json, reflect.TypeOf(cb))
			if !result.Valid() {
				fmt.Fprintln(Out, "File ", path, " is not a cookbook - parsing error:\n", result.Errors())
			} else {
				perCookbook(path, cb)
			}
		}
	} else if filepath.Ext(path) == recipeExtension {
		rcp, json, err := loadRecipeFromPath(path)
		if err != nil {
			fmt.Fprintln(Out, "File ", path, " is not a recipe - parsing error:\n", err)
		} else {
			result, _ := validateJson(json, reflect.TypeOf(rcp))
			if !result.Valid() {
				fmt.Fprintln(Out, "File ", path, " is not a recipe - parsing error:\n", result.Errors())
			} else {
				perRecipe(path, rcp)
			}

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
			filepath.Walk(path, func(p string, info os.FileInfo, e error) error {
				if !info.IsDir() {
					forFile(p, perCookbook, perRecipe)
				}
				return nil
			})
		} else {
			forFile(path, perCookbook, perRecipe)
		}
	}
}

func loadCookbookFromPath(path string) (types.Cookbook, string, error) {
	bytes, _ := os.ReadFile(path)
	var cb types.Cookbook
	err := json.Unmarshal(bytes, &cb)
	return cb, string(bytes), err
}

func loadRecipeFromPath(path string) (types.Recipe, string, error) {
	bytes, _ := os.ReadFile(path)
	var rcp types.Recipe
	err := json.Unmarshal(bytes, &rcp)
	return rcp, string(bytes), err
}

func getSchemaUrl(t reflect.Type) string {
	var b bytes.Buffer
	b.WriteString(schemaPathRoot)
	b.WriteString(t.Name())
	b.WriteString(dotJson)
	return b.String()
}

func validateJson(json string, t reflect.Type) (*gojsonschema.Result, error) {
	schemaLoader := gojsonschema.NewReferenceLoader(getSchemaUrl(t))
	stringLoader := gojsonschema.NewStringLoader(json)
	result, err := gojsonschema.Validate(schemaLoader, stringLoader)
	return result, err
}
