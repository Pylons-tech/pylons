package inttest

import (
	"fmt"
	originT "testing"
	"time"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	testing "github.com/Pylons-tech/pylons_sdk/cmd/evtesting"

	inttestSDK "github.com/Pylons-tech/pylons_sdk/cmd/test_utils"
	"github.com/Pylons-tech/pylons_sdk/x/pylons/msgs"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

func TestExecuteRecipeViaCLI(originT *originT.T) {
	t := testing.NewT(originT)
	t.Parallel()

	pylonsLLCAddress, pylonsLLCBalance := GetPylonsLLCAddressAndBalance(&t)

	tests := []struct {
		name                  string
		rcpName               string
		itemIDs               []string
		desiredItemName       string
		pylonsLLCDistribution int64
		cbOwnerDistribution   int64
		rcpExecutorSpend      int64
	}{
		{
			name:                  "item build from pylons recipe",
			rcpName:               "TESTRCP_ExecuteRecipe_003",
			itemIDs:               []string{},
			desiredItemName:       "TESTITEM_ExecuteRecipe_003",
			pylonsLLCDistribution: 1,
			cbOwnerDistribution:   4,
			rcpExecutorSpend:      5,
		},
	}

	for tcNum, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			cbOwnerKey := fmt.Sprintf("TestExecuteRecipeViaCLI%d_CBOWNER_%d", tcNum, time.Now().Unix())
			rcpExecutorKey := fmt.Sprintf("TestExecuteRecipeViaCLI%d_RCP_EXECUTOR_%d", tcNum, time.Now().Unix())
			MockAccount(cbOwnerKey, t)     // mock account with initial balance
			MockAccount(rcpExecutorKey, t) // mock account with initial balance
			guid := MockNoDelayItemGenRecipeGUID(cbOwnerKey, tc.rcpName, tc.desiredItemName, t)

			cbOwnerAccBalance := inttestSDK.GetAccountBalanceFromAddr(cbOwnerKey, t)
			rcpExecutorBalance := inttestSDK.GetAccountBalanceFromAddr(rcpExecutorKey, t)

			rcp, err := inttestSDK.GetRecipeByGUID(guid)
			t.WithFields(testing.Fields{
				"recipe_guid": guid,
			}).MustNil(err, "error getting recipe from guid")

			execMsg := msgs.NewMsgExecuteRecipe(rcp.ID, rcpExecutorBalance.Address, tc.itemIDs)
			txhash, err := inttestSDK.TestTxWithMsgWithNonce(t, &execMsg, rcpExecutorKey, false)
			if err != nil {
				TxBroadcastErrorCheck(txhash, err, t)
				return
			}

			GetTxHandleResult(txhash, t)

			items, err := inttestSDK.ListItemsViaCLI("")
			t.MustNil(err, "error listing items via cli")

			_, ok := inttestSDK.FindItemFromArrayByName(items, tc.desiredItemName, false, false)
			t.WithFields(testing.Fields{
				"item_name": tc.desiredItemName,
			}).MustTrue(ok, "item id with specific name does not exist")

			if tc.pylonsLLCDistribution > 0 {
				accInfo := inttestSDK.GetAccountBalanceFromAddr(pylonsLLCAddress.String(), t)
				originPylonAmount := pylonsLLCBalance.Coins.AmountOf(types.Pylon)
				balanceOk := accInfo.Coins.AmountOf(types.Pylon).GTE(sdk.NewInt(originPylonAmount.Int64() + tc.pylonsLLCDistribution))
				t.WithFields(testing.Fields{
					"pylons_llc_address":  pylonsLLCAddress.String(),
					"origin_amount":       originPylonAmount.Int64(),
					"target_distribution": tc.pylonsLLCDistribution,
					"actual_amount":       accInfo.Coins.AmountOf(types.Pylon).Int64(),
				}).Log("Pylons LLC amount change")
				t.MustTrue(balanceOk, "Pylons LLC should get correct revenue")
			}
			if tc.cbOwnerDistribution > 0 {
				accInfo := inttestSDK.GetAccountBalanceFromAddr(cbOwnerAccBalance.Address, t)
				originPylonAmount := cbOwnerAccBalance.Coins.AmountOf(types.Pylon)
				balanceOk := accInfo.Coins.AmountOf(types.Pylon).Equal(sdk.NewInt(originPylonAmount.Int64() + tc.cbOwnerDistribution))
				t.WithFields(testing.Fields{
					"cbowner_key":         cbOwnerKey,
					"cbowner_address":     cbOwnerAccBalance.Address,
					"origin_amount":       originPylonAmount.Int64(),
					"target_distribution": tc.cbOwnerDistribution,
					"actual_amount":       accInfo.Coins.AmountOf(types.Pylon).Int64(),
				}).MustTrue(balanceOk, "cookbook owner should get correct revenue")
			}
			if tc.rcpExecutorSpend != 0 {
				accInfo := inttestSDK.GetAccountBalanceFromAddr(rcpExecutorBalance.Address, t)
				originPylonAmount := rcpExecutorBalance.Coins.AmountOf(types.Pylon)
				balanceOk := accInfo.Coins.AmountOf(types.Pylon).Equal(sdk.NewInt(originPylonAmount.Int64() - tc.rcpExecutorSpend))
				t.WithFields(testing.Fields{
					"executor_key":     rcpExecutorKey,
					"executor_address": rcpExecutorBalance.Address,
					"origin_amount":    originPylonAmount.Int64(),
					"target_spend":     tc.rcpExecutorSpend,
					"actual_amount":    accInfo.Coins.AmountOf(types.Pylon).Int64(),
				}).MustTrue(balanceOk, "recipe executor should spend correct amount")
			}
		})
	}
}
