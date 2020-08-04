package handlers

import (
	"strings"
	"testing"

	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	"github.com/Pylons-tech/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"
)

func TestSetMatchedItemsFromExecMsg(t *testing.T) {
	tci := keep.SetupTestCoinInput()
	sender1, _, _, _ := keep.SetupTestAccounts(t, tci, types.NewPylon(1000000), nil, nil, nil)

	cbData := MockCookbook(tci, sender1)

	// Generate initial items
	initItemNames := []string{
		"Knife1", "Knife2", "Shield1", "Eye", "Nose",
		"Attack1Item", "Attack10Item", "Attack10Level1Item",
		"Attack10Level20Item",
		"Attack10Level20Carrier",
		"Attack10Level20PersonFee1",
		"Attack10Level20PersonFee1000Locked",
	}
	initItemIDs := []string{}
	for _, iN := range initItemNames {
		newItem := keep.GenItem(cbData.CookbookID, sender1, iN)
		if iN == "Attack1Item" {
			newItem.Doubles = append(newItem.Doubles, types.DoubleKeyValue{
				Key:   "attack",
				Value: "1.0",
			})
		} else if iN == "Attack10Item" {
			newItem.Doubles = append(newItem.Doubles, types.DoubleKeyValue{
				Key:   "attack",
				Value: "10.0",
			})
		} else if iN == "Attack10Level1Item" {
			newItem.Doubles = append(newItem.Doubles, types.DoubleKeyValue{
				Key:   "attack",
				Value: "10.0",
			})
			newItem.Longs = append(newItem.Longs, types.LongKeyValue{
				Key:   "level",
				Value: 1,
			})
		} else if iN == "Attack10Level20Item" {
			newItem.Doubles = append(newItem.Doubles, types.DoubleKeyValue{
				Key:   "attack",
				Value: "10.0",
			})
			newItem.Longs = append(newItem.Longs, types.LongKeyValue{
				Key:   "level",
				Value: 20,
			})
		} else if iN == "Attack10Level20Carrier" {
			newItem.Doubles = append(newItem.Doubles, types.DoubleKeyValue{
				Key:   "attack",
				Value: "10.0",
			})
			newItem.Longs = append(newItem.Longs, types.LongKeyValue{
				Key:   "level",
				Value: 20,
			})
			newItem.Strings = append(newItem.Strings, types.StringKeyValue{
				Key:   "Type",
				Value: "Carrier",
			})
		} else if iN == "Attack10Level20PersonFee1" {
			newItem.Doubles = append(newItem.Doubles, types.DoubleKeyValue{
				Key:   "attack",
				Value: "10.0",
			})
			newItem.Longs = append(newItem.Longs, types.LongKeyValue{
				Key:   "level",
				Value: 20,
			})
			newItem.Strings = append(newItem.Strings, types.StringKeyValue{
				Key:   "Type",
				Value: "person",
			})
		} else if iN == "Attack10Level20PersonFee1000Locked" {
			newItem.Doubles = append(newItem.Doubles, types.DoubleKeyValue{
				Key:   "attack",
				Value: "10.0",
			})
			newItem.Longs = append(newItem.Longs, types.LongKeyValue{
				Key:   "level",
				Value: 20,
			})
			newItem.Strings = append(newItem.Strings, types.StringKeyValue{
				Key:   "Type",
				Value: "person",
			})
			newItem.TransferFee = 1000
			newItem.OwnerTradeID = "TRADE_ID"
		}
		err := tci.PlnK.SetItem(tci.Ctx, *newItem)
		require.True(t, err == nil)
		initItemIDs = append(initItemIDs, newItem.ID)
	}

	knifeMergeRecipe := MockPopularRecipe(Rcp2BlockDelayedKnifeMerge, tci,
		"knife merge recipe", cbData.CookbookID, sender1)

	shieldMergeRecipe := MockRecipe(
		tci, "shield merge recipe",
		types.CoinInputList{},
		types.GenItemInputList("Shield1", "Shield2"),
		types.GenItemOnlyEntry("MRGShield"),
		types.GenOneOutput("MRGShield"),
		cbData.CookbookID,
		0,
		sender1,
	)

	diffItemMergeRecipe := MockRecipe(
		tci, "head build recipe",
		types.CoinInputList{},
		types.GenItemInputList("Eye", "Nose"),
		types.GenItemOnlyEntry("Head"),
		types.GenOneOutput("Head"),
		cbData.CookbookID,
		0,
		sender1,
	)

	personSleepRecipe := MockRecipe(
		tci, "sleep recipe",
		types.CoinInputList{},
		types.ItemInputList{
			{
				Doubles: types.DoubleInputParamList{{Key: "attack", MinValue: "10.0", MaxValue: "1000.0"}},
				Longs:   types.LongInputParamList{{Key: "level", MinValue: 20, MaxValue: 100}},
				Strings: types.StringInputParamList{{Key: "Type", Value: "person"}},
				TransferFee: types.FeeInputParam{
					MinValue: 10,
					MaxValue: 10000,
				},
			},
		},
		nil,
		nil,
		cbData.CookbookID,
		0,
		sender1,
	)

	cases := map[string]struct {
		itemIDs      []string
		rcpID        string
		sender       sdk.AccAddress
		desiredError string
		showError    bool
	}{
		"correct same item merge recipe": {
			itemIDs:      []string{initItemIDs[0], initItemIDs[1]},
			rcpID:        knifeMergeRecipe.RecipeID,
			sender:       sender1,
			desiredError: "",
			showError:    false,
		},
		"wrong same item merge recipe": {
			itemIDs:      []string{initItemIDs[2], initItemIDs[2]},
			rcpID:        shieldMergeRecipe.RecipeID,
			sender:       sender1,
			desiredError: "multiple use of same item as item inputs",
			showError:    true,
		},
		"input item order change test": {
			itemIDs:      []string{initItemIDs[4], initItemIDs[3]},
			rcpID:        diffItemMergeRecipe.RecipeID,
			sender:       sender1,
			desiredError: "[0]th item does not match: Name key value does not match",
			showError:    true,
		},
		"double key is not available on the item": {
			itemIDs:      []string{initItemIDs[4]},
			rcpID:        personSleepRecipe.RecipeID,
			sender:       sender1,
			desiredError: "[0]th item does not match: attack key is not available on the item",
			showError:    true,
		},
		"double key range does not match": {
			itemIDs:      []string{initItemIDs[5]},
			rcpID:        personSleepRecipe.RecipeID,
			sender:       sender1,
			desiredError: "[0]th item does not match: attack key range does not match",
			showError:    true,
		},
		"long key is not available on the item": {
			itemIDs:      []string{initItemIDs[6]},
			rcpID:        personSleepRecipe.RecipeID,
			sender:       sender1,
			desiredError: "[0]th item does not match: level key is not available on the item",
			showError:    true,
		},
		"long key range does not match": {
			itemIDs:      []string{initItemIDs[7]},
			rcpID:        personSleepRecipe.RecipeID,
			sender:       sender1,
			desiredError: "[0]th item does not match: level key range does not match",
			showError:    true,
		},
		"string key is not available on the item": {
			itemIDs:      []string{initItemIDs[8]},
			rcpID:        personSleepRecipe.RecipeID,
			sender:       sender1,
			desiredError: "[0]th item does not match: Type key is not available on the item",
			showError:    true,
		},
		"string key value does not match": {
			itemIDs:      []string{initItemIDs[9]},
			rcpID:        personSleepRecipe.RecipeID,
			sender:       sender1,
			desiredError: "[0]th item does not match: Type key value does not match",
			showError:    true,
		},
		"item transfer fee does not match": {
			itemIDs:      []string{initItemIDs[10]},
			rcpID:        personSleepRecipe.RecipeID,
			sender:       sender1,
			desiredError: "[0]th item does not match: item transfer fee does not match",
			showError:    true,
		},
		"item is locked": {
			itemIDs:      []string{initItemIDs[11]},
			rcpID:        personSleepRecipe.RecipeID,
			sender:       sender1,
			desiredError: "[0]th item is locked: Item is owned by a trade",
			showError:    true,
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			msg := msgs.NewMsgExecuteRecipe(tc.rcpID, tc.sender, tc.itemIDs)
			rcp, err := tci.PlnK.GetRecipe(tci.Ctx, msg.RecipeID)
			require.True(t, err == nil)
			p := ExecProcess{ctx: tci.Ctx, keeper: tci.PlnK, recipe: rcp}
			err = p.SetMatchedItemsFromExecMsg(msg)
			if tc.showError {
				require.True(t, err != nil)
				require.True(t, strings.Contains(err.Error(), tc.desiredError), err.Error(), tc.desiredError)
			} else {
				require.True(t, err == nil, err)
			}
		})
	}
}

func TestGenerateCelEnvVarFromInputItems(t *testing.T) {
	tci := keep.SetupTestCoinInput()
	sender1, _, _, _ := keep.SetupTestAccounts(t, tci, types.NewPylon(1000000), nil, nil, nil)

	cbData := MockCookbook(tci, sender1)

	initItemIDs := []string{}

	newItem := types.NewItem(
		cbData.CookbookID,
		[]types.DoubleKeyValue{
			{
				Key:   "attack",
				Value: "1.0",
			},
		},
		[]types.LongKeyValue{
			{
				Key:   "level",
				Value: 1,
			},
		},
		[]types.StringKeyValue{
			{
				Key:   "Name",
				Value: "Raichu",
			},
		},
		sender1,
		0,
		0,
	)
	err := tci.PlnK.SetItem(tci.Ctx, *newItem)
	require.True(t, err == nil)
	initItemIDs = append(initItemIDs, newItem.ID)

	exmpRcpMsg := msgs.NewMsgCreateRecipe("name", cbData.CookbookID, "exmplRcp-0001", "this has to meet character limits",
		types.GenCoinInputList("wood", 5),
		types.GenItemInputList("Raichu"),
		types.GenEntries("wood", "Raichu"),
		types.GenOneOutput("wood", "Raichu"),
		0,
		sender1,
	)

	_, err = HandlerMsgCreateRecipe(tci.Ctx, tci.PlnK, exmpRcpMsg)
	require.True(t, err == nil, err)

	cases := map[string]struct {
		itemIDs      []string
		rcpID        string
		sender       sdk.AccAddress
		desiredError string
		showError    bool
	}{
		"correct same item merge recipe": {
			itemIDs:      []string{initItemIDs[0]},
			rcpID:        exmpRcpMsg.RecipeID,
			sender:       sender1,
			desiredError: "",
			showError:    false,
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			msg := msgs.NewMsgExecuteRecipe(tc.rcpID, tc.sender, tc.itemIDs)
			rcp, err := tci.PlnK.GetRecipe(tci.Ctx, msg.RecipeID)
			require.True(t, err == nil)
			p := ExecProcess{ctx: tci.Ctx, keeper: tci.PlnK, recipe: rcp}
			err = p.SetMatchedItemsFromExecMsg(msg)
			require.True(t, err == nil, err)
			err = p.GenerateCelEnvVarFromInputItems()
			if tc.showError {
				require.True(t, err != nil)
				require.True(t, strings.Contains(err.Error(), tc.desiredError), err.Error(), tc.desiredError)
			} else {
				require.True(t, err == nil, err)
				ec := p.GetEnvCollection()
				level, err := ec.EvalInt64("Raichu.level")
				require.True(t, err == nil, err)
				require.True(t, level == 1)
				attack, err := ec.EvalFloat64("Raichu.attack")
				require.True(t, err == nil, err)
				require.True(t, attack == 1)
				name, err := ec.EvalString("Raichu.Name")
				require.True(t, err == nil, err)
				require.True(t, name == "Raichu")

				level, err = ec.EvalInt64("input0.level")
				require.True(t, err == nil, err)
				require.True(t, level == 1)
				attack, err = ec.EvalFloat64("input0.attack")
				require.True(t, err == nil, err)
				require.True(t, attack == 1)
				name, err = ec.EvalString("input0.Name")
				require.True(t, err == nil, err)
				require.True(t, name == "Raichu")

				level, err = ec.EvalInt64("level")
				require.True(t, err == nil, err)
				require.True(t, level == 1)
				attack, err = ec.EvalFloat64("attack")
				require.True(t, err == nil, err)
				require.True(t, attack == 1)
				name, err = ec.EvalString("Name")
				require.True(t, err == nil, err)
				require.True(t, name == "Raichu")
			}
		})
	}
}
