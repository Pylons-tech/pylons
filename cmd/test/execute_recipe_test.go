package inttest

import (
	originT "testing"

	"github.com/Pylons-tech/pylons/x/pylons/config"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	testing "github.com/Pylons-tech/pylons_sdk/cmd/evtesting"

	inttestSDK "github.com/Pylons-tech/pylons_sdk/cmd/test_utils"
	"github.com/Pylons-tech/pylons_sdk/x/pylons/msgs"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

func TestExecuteRecipeViaCLI(originT *originT.T) {
	t := testing.NewT(originT)
	t.Parallel()

	pylonsLLCAddress, err := sdk.AccAddressFromBech32(config.Config.Validators.PylonsLLC)
	t.MustNil(err, "error converting string address to AccAddress struct")
	pylonsLLCAccInfo := inttestSDK.GetAccountInfoFromAddr(pylonsLLCAddress.String(), &t)

	tests := []struct {
		name                  string
		rcpName               string
		itemIDs               []string
		desiredItemName       string
		pylonsLLCDistribution int64
		// cbOwnerDistribution   int64
	}{
		{
			name:                  "item build from pylons recipe",
			rcpName:               "TESTRCP_ExecuteRecipe_003",
			itemIDs:               []string{},
			desiredItemName:       "TESTITEM_ExecuteRecipe_003",
			pylonsLLCDistribution: 1,
			// cbOwnerDistribution:   4,
		},
	}

	for _, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			guid, err := MockNoDelayItemGenRecipeGUID(tc.rcpName, tc.desiredItemName, t)
			if err != nil {
				t.WithFields(testing.Fields{
					"error": err,
				}).Fatal("error mocking recipe")
			}

			// eugenAddr := inttestSDK.GetAccountAddr("eugen", t)
			// cbOwnerAddress, err := sdk.AccAddressFromBech32(eugenAddr)
			t.MustNil(err, "error converting string address to AccAddress struct")
			// cbOwnerAccInfo := inttestSDK.GetAccountInfoFromAddr(cbOwnerAddress.String(), t)

			rcp, err := inttestSDK.GetRecipeByGUID(guid)
			t.WithFields(testing.Fields{
				"recipe_guid": guid,
			}).MustNil(err, "error getting recipe from guid")

			michaelAddr := inttestSDK.GetAccountAddr("michael", t)
			michaelSdkAddress, err := sdk.AccAddressFromBech32(michaelAddr)
			t.MustNil(err, "error converting string address to AccAddress struct")
			txhash, err := inttestSDK.TestTxWithMsgWithNonce(
				t,
				msgs.NewMsgExecuteRecipe(rcp.ID, michaelSdkAddress, tc.itemIDs),
				"michael",
				false,
			)
			if err != nil {
				TxBroadcastErrorCheck(txhash, err, t)
				return
			}

			GetTxHandleResult(txhash, t)

			items, err := inttestSDK.ListItemsViaCLI("")
			if err != nil {
				t.WithFields(testing.Fields{
					"error": err,
				}).Fatal("error listing items via cli")
			}

			_, ok := inttestSDK.FindItemFromArrayByName(items, tc.desiredItemName, false, false)
			t.WithFields(testing.Fields{
				"item_name": tc.desiredItemName,
			}).MustTrue(ok, "item id with specific name does not exist")

			if tc.pylonsLLCDistribution > 0 {
				accInfo := inttestSDK.GetAccountInfoFromAddr(pylonsLLCAddress.String(), t)
				originPylonAmount := pylonsLLCAccInfo.Coins.AmountOf(types.Pylon)
				pylonAvailOnLLC := accInfo.Coins.AmountOf(types.Pylon).GTE(sdk.NewInt(originPylonAmount.Int64() + tc.pylonsLLCDistribution))
				t.MustTrue(pylonAvailOnLLC, "Pylons LLC should get correct revenue")
			}
			// TODO should enable this when we create new account per cookbook and per recipes for parallel
			// if tc.cbOwnerDistribution > 0 {
			// 	accInfo := inttestSDK.GetAccountInfoFromAddr(cbOwnerAddress.String(), t)
			// 	originPylonAmount := cbOwnerAccInfo.Coins.AmountOf(types.Pylon)
			// 	t.Log("originPylonAmount.Int64() + tc.cbOwnerDistribution", originPylonAmount.Int64(), tc.cbOwnerDistribution, accInfo.Coins.AmountOf(types.Pylon))
			// 	pylonAvailOnCBOwner := accInfo.Coins.AmountOf(types.Pylon).GTE(sdk.NewInt(originPylonAmount.Int64() + tc.cbOwnerDistribution))
			// 	t.MustTrue(pylonAvailOnCBOwner, "cookbook owner should get correct revenue")
			// }
		})
	}
}
