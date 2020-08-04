package handlers

import (
	"encoding/json"
	"testing"

	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	"github.com/Pylons-tech/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"
)

func TestHandlerMsgCheckExecution(t *testing.T) {
	tci := keep.SetupTestCoinInput()
	sender1, sender2, _, _ := keep.SetupTestAccounts(t, tci, types.NewPylon(1000000), nil, nil, nil)

	// mock cookbook
	cbData := MockCookbook(tci, sender1)

	// mock delayed coin to coin recipe
	c2cRecipeData := MockPopularRecipe(Rcp5BlockDelayed5xWoodcoinTo1xChaircoin, tci, "existing recipe", cbData.CookbookID, sender1)

	// mock delayed more than 1 item input recipe
	knifeMergeRecipeData := MockPopularRecipe(Rcp2BlockDelayedKnifeMerge, tci,
		"knife merge recipe", cbData.CookbookID, sender1)

	// mock delayed item upgrade recipe
	knifeUpgradeRecipeData := MockPopularRecipe(Rcp2BlockDelayedKnifeUpgrade, tci,
		"knife upgrade recipe", cbData.CookbookID, sender1)

	// mock delayed knife buyer recipe
	knifeBuyerRecipeData := MockPopularRecipe(Rcp2BlockDelayedKnifeBuyer, tci,
		"knife upgrade recipe", cbData.CookbookID, sender1)

	cases := map[string]struct {
		rcpID               string
		itemIDs             []string
		dynamicItemSet      bool
		dynamicItemNames    []string
		sender              sdk.AccAddress
		payToComplete       bool
		addHeight           int64
		expectedMessage     string
		expectError         bool
		coinAddition        int64
		retryExecution      bool
		retryResMessage     string
		desiredUpgradedName string
	}{
		"coin to coin recipe execution test": {
			rcpID:            c2cRecipeData.RecipeID,
			dynamicItemSet:   false,
			dynamicItemNames: []string{},
			sender:           sender1,
			payToComplete:    false,
			addHeight:        15,
			expectedMessage:  "successfully completed the execution",
		},
		"coin to coin early pay recipe execution fail due to insufficient balance": {
			rcpID:            c2cRecipeData.RecipeID,
			dynamicItemSet:   false,
			dynamicItemNames: []string{},
			sender:           sender2,
			payToComplete:    true,
			expectError:      true,
			expectedMessage:  "insufficient balance to complete the execution",
		},
		"coin to coin early pay recipe execution test": {
			rcpID:            c2cRecipeData.RecipeID,
			dynamicItemSet:   false,
			dynamicItemNames: []string{},
			sender:           sender2,
			payToComplete:    true,
			expectedMessage:  "successfully paid to complete the execution",
			coinAddition:     300,
		},
		"item upgrade recipe success execution test": {
			rcpID:               knifeUpgradeRecipeData.RecipeID,
			dynamicItemSet:      true,
			dynamicItemNames:    []string{"Knife"},
			sender:              sender1,
			payToComplete:       false,
			addHeight:           3,
			expectedMessage:     "successfully completed the execution",
			desiredUpgradedName: "KnifeV2",
		},
		"more than 1 item input recipe success execution test": {
			rcpID:            knifeMergeRecipeData.RecipeID,
			dynamicItemSet:   true,
			dynamicItemNames: []string{"Knife1", "Knife2"},
			sender:           sender1,
			payToComplete:    false,
			addHeight:        3,
			expectedMessage:  "successfully completed the execution",
		},
		"item generation recipe success execution test": {
			rcpID:           knifeBuyerRecipeData.RecipeID,
			dynamicItemSet:  false,
			sender:          sender1,
			payToComplete:   false,
			addHeight:       3,
			expectedMessage: "successfully completed the execution",
			retryExecution:  true,
			retryResMessage: "execution already completed",
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			if tc.dynamicItemSet {
				tc.itemIDs = []string{}
				for _, iN := range tc.dynamicItemNames {
					dynamicItem := keep.GenItem(cbData.CookbookID, tc.sender, iN)
					err := tci.PlnK.SetItem(tci.Ctx, *dynamicItem)
					require.True(t, err == nil)
					tc.itemIDs = append(tc.itemIDs, dynamicItem.ID)
				}
			}
			_, err := tci.Bk.AddCoins(tci.Ctx, tc.sender, sdk.Coins{sdk.NewInt64Coin("wood", 5)})
			require.True(t, err == nil)

			execRcpResponse, err := MockExecution(tci, tc.rcpID,
				tc.sender,
				tc.itemIDs,
			)
			require.True(t, err == nil)
			require.True(t, execRcpResponse.Status == "Success")
			require.True(t, execRcpResponse.Message == "scheduled the recipe")

			if tc.coinAddition != 0 {
				_, err = tci.Bk.AddCoins(tci.Ctx, tc.sender, types.NewPylon(tc.coinAddition))
				require.True(t, err == nil)
			}

			scheduleOutput := ExecuteRecipeScheduleOutput{}
			err = json.Unmarshal(execRcpResponse.Output, &scheduleOutput)
			require.True(t, err == nil)

			if tc.dynamicItemSet && len(tc.itemIDs) > 0 {
				usedItem, err := tci.PlnK.GetItem(tci.Ctx, tc.itemIDs[0])
				require.True(t, err == nil)
				require.True(t, usedItem.OwnerRecipeID == tc.rcpID)
			}

			checkExec := msgs.NewMsgCheckExecution(scheduleOutput.ExecID, tc.payToComplete, tc.sender)

			futureContext := tci.Ctx.WithBlockHeight(tci.Ctx.BlockHeight() + tc.addHeight)
			result, _ := HandlerMsgCheckExecution(futureContext, tci.PlnK, checkExec)
			checkExecResp := CheckExecutionResponse{}
			err = json.Unmarshal(result.Data, &checkExecResp)
			require.True(t, err == nil)

			if tc.expectError {
				require.True(t, checkExecResp.Status == "Failure")
				require.True(t, checkExecResp.Message == tc.expectedMessage)

			} else {
				require.True(t, checkExecResp.Status == "Success")
				require.True(t, checkExecResp.Message == tc.expectedMessage)
			}

			if len(tc.desiredUpgradedName) > 0 && len(tc.itemIDs) > 0 {
				updatedItem, err := tci.PlnK.GetItem(futureContext, tc.itemIDs[0])
				require.True(t, err == nil)
				updatedName, ok := updatedItem.FindString("Name")
				require.True(t, ok)
				require.True(t, updatedName == tc.desiredUpgradedName)
			}

			if tc.retryExecution {
				result, _ := HandlerMsgCheckExecution(futureContext, tci.PlnK, checkExec)
				checkExecResp := CheckExecutionResponse{}
				err = json.Unmarshal(result.Data, &checkExecResp)
				require.True(t, err == nil)
				require.True(t, checkExecResp.Status == "Completed")
				require.True(t, checkExecResp.Message == tc.retryResMessage)
			}
		})
	}
}
