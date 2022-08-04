package cmd

import (
	"fmt"
	"os"
	"testing"

	"github.com/stretchr/testify/assert"

	testutil "github.com/Pylons-tech/pylons/testutil/cli"
)

const pylonsGadgetsLiteral_duplicateName = `#foobar 1
	"foo": "%0"
	#foobar 1
	"foo": "%0"`

const pylonsGadgetsLiteral_reservedName = `#include 1
	"foo": "%0"`

const pylonsGadgetsLiteral_noHeader = `"foo": "%0"
	#foobar 1
	"foo": "%0"`

const pylonsGadgetsLiteral_badHeader = `#test_gadget_with_bad_header 1 additional_garbage
"foo": "%0"`

const pylonsGadgetsLiteral_good = `#go_go_gadget_gadgets 3
	"foo": "%0",
	"bar": "%1",
	"%2": "true"`

func TestGadgets(t *testing.T) {
	// builtins!

	t.Run("Builtin gadget: price", func(t *testing.T) {
		const expected = `"coinInputs": [
			{
				"coins" : [
					{
					"denom": "test",
					"amount": "42"
					}
				]
			}
		]`
		gadget := GetGadget("price", &builtinGadgets)
		assert.EqualValues(t, expected, ExpandGadget(gadget, []string{"test", "42"}))
	})

	t.Run("Builtin gadget: no_input", func(t *testing.T) {
		const expected = `"coinInputs": [],
		"itemInputs": []`
		gadget := GetGadget("no_input", &builtinGadgets)
		assert.EqualValues(t, expected, ExpandGadget(gadget, []string{}))
	})

	t.Run("Builtin gadget: no_coin_input", func(t *testing.T) {
		const expected = `"coinInputs": []`
		gadget := GetGadget("no_coin_input", &builtinGadgets)
		assert.EqualValues(t, expected, ExpandGadget(gadget, []string{}))
	})

	t.Run("Builtin gadget: no_item_input", func(t *testing.T) {
		const expected = `"itemInputs": []`
		gadget := GetGadget("no_item_input", &builtinGadgets)
		assert.EqualValues(t, expected, ExpandGadget(gadget, []string{}))
	})

	t.Run("Builtin gadget: id_name", func(t *testing.T) {
		const expected = `"id": "foo",
		"name": "bar"`
		gadget := GetGadget("id_name", &builtinGadgets)
		assert.EqualValues(t, expected, ExpandGadget(gadget, []string{"foo", "bar"}))
	})

	t.Run("Builtin gadget: no_coin_output", func(t *testing.T) {
		const expected = `"coinOutputs": []`
		gadget := GetGadget("no_coin_output", &builtinGadgets)
		assert.EqualValues(t, expected, ExpandGadget(gadget, []string{}))
	})

	t.Run("Builtin gadget: no_item_output", func(t *testing.T) {
		const expected = `"itemOutputs": []`
		gadget := GetGadget("no_item_output", &builtinGadgets)
		assert.EqualValues(t, expected, ExpandGadget(gadget, []string{}))
	})

	t.Run("Builtin gadget: no_item_modify_output", func(t *testing.T) {
		const expected = `"itemModifyOutputs": []`
		gadget := GetGadget("no_item_modify_output", &builtinGadgets)
		assert.EqualValues(t, expected, ExpandGadget(gadget, []string{}))
	})

	t.Run("Builtin gadget: no_coin_or_item_output", func(t *testing.T) {
		const expected = `"coinOutputs": [],
		"itemOutputs": []`
		gadget := GetGadget("no_coin_or_item_output", &builtinGadgets)
		assert.EqualValues(t, expected, ExpandGadget(gadget, []string{}))
	})

	t.Run("Builtin gadget: no_coin_or_item_modify_output", func(t *testing.T) {
		const expected = `"coinOutputs": [],
		"itemModifyOutputs": []`
		gadget := GetGadget("no_coin_or_item_modify_output", &builtinGadgets)
		assert.EqualValues(t, expected, ExpandGadget(gadget, []string{}))
	})

	t.Run("Builtin gadget: no_item_or_item_modify_output", func(t *testing.T) {
		const expected = `"itemOutputs": [],
		"itemModifyOutputs": []`
		gadget := GetGadget("no_item_or_item_modify_output", &builtinGadgets)
		assert.EqualValues(t, expected, ExpandGadget(gadget, []string{}))
	})

	t.Run("Builtin gadget: solo_output", func(t *testing.T) {
		const expected = `"outputs": [
			{
				"entryIds": [
					"grumble"
				],
				"weight": 1
			}
		]`
		gadget := GetGadget("solo_output", &builtinGadgets)
		assert.EqualValues(t, expected, ExpandGadget(gadget, []string{"grumble"}))
	})

	t.Run("Builtin gadget: no_output", func(t *testing.T) {
		const expected = `"entries": {},
		"outputs": [],`
		gadget := GetGadget("no_output", &builtinGadgets)
		assert.EqualValues(t, expected, ExpandGadget(gadget, []string{}))
	})

	// gadget parse panics

	t.Run("Should not be able to register gadget with reserved name", func(t *testing.T) {
		testutil.WriteFixtureAtTestRuntime(gadgetsFilename, pylonsGadgetsLiteral_reservedName)
		assert.PanicsWithErrorf(t, fmt.Sprintf(errReservedName, "include"), func() { LoadGadgetsForPath("") }, errReservedName, "include")
		os.Remove(gadgetsFilename)
	})

	t.Run("Should not be able to register duplicate gadget names", func(t *testing.T) {
		testutil.WriteFixtureAtTestRuntime(gadgetsFilename, pylonsGadgetsLiteral_duplicateName)
		assert.PanicsWithErrorf(t, fmt.Sprintf(errDuplicateName, "foobar"), func() { LoadGadgetsForPath("") }, errDuplicateName, "foobar")
		os.Remove(gadgetsFilename)
	})

	t.Run("pylons.gadgets file must start with a gadget header", func(t *testing.T) {
		testutil.WriteFixtureAtTestRuntime(gadgetsFilename, pylonsGadgetsLiteral_noHeader)
		assert.PanicsWithError(t, errNoHeader, func() { LoadGadgetsForPath("") })
		os.Remove(gadgetsFilename)
	})

	t.Run("Should not be able to register gadget with a bad header", func(t *testing.T) {
		testutil.WriteFixtureAtTestRuntime(gadgetsFilename, pylonsGadgetsLiteral_badHeader)
		assert.PanicsWithErrorf(t, fmt.Sprintf(errBadHeader, "#test_gadget_with_bad_header 1 additional_garbage"), func() { LoadGadgetsForPath("") }, errBadHeader, "#test_gadget_with_bad_header 1 additional_garbage")
		os.Remove(gadgetsFilename)
	})

	t.Run("Registered custom gadget expands to expected value", func(t *testing.T) {
		const expected = `"foo": "a","bar": "b","is_a_gadget": "true"`
		testutil.WriteFixtureAtTestRuntime(gadgetsFilename, pylonsGadgetsLiteral_good)
		gadgets, _ := LoadGadgetsForPath("")
		gadget := GetGadget("go_go_gadget_gadgets", gadgets)
		assert.EqualValues(t, expected, ExpandGadget(gadget, []string{"a", "b", "is_a_gadget"}))
		os.Remove(gadgetsFilename)
	})
}
