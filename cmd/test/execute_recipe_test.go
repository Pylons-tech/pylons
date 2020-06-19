package inttest

import (
	originT "testing"

	"github.com/Pylons-tech/pylons/x/pylons/config"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	testing "github.com/Pylons-tech/pylons_sdk/cmd/fixtures_test/evtesting"

	inttestSDK "github.com/Pylons-tech/pylons_sdk/cmd/test"
	"github.com/Pylons-tech/pylons_sdk/x/pylons/msgs"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

func TestExecuteRecipeViaCLI(originT *originT.T) {
	t := testing.NewT(originT)
	t.Parallel()

	pylonsLLCAddress, err := sdk.AccAddressFromBech32(config.Config.Validators.PylonsLLC)
	t.MustNil(err)
	pylonsLLCAccInfo := inttestSDK.GetAccountInfoFromAddr(pylonsLLCAddress.String(), &t)

	tests := []struct {
		name                   string
		rcpName                string
		itemIDs                []string
		desiredItemName        string
		checkPylonDistribution bool
		pylonsLLCDistribution  int64
	}{
		{
			name:                   "item build from pylons recipe",
			rcpName:                "TESTRCP_ExecuteRecipe_003",
			itemIDs:                []string{},
			desiredItemName:        "TESTITEM_ExecuteRecipe_003",
			checkPylonDistribution: true,
			pylonsLLCDistribution:  1,
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

			rcp, err := inttestSDK.GetRecipeByGUID(guid)
			t.MustNil(err)

			eugenAddr := inttestSDK.GetAccountAddr("eugen", t)
			sdkAddr, err := sdk.AccAddressFromBech32(eugenAddr)
			t.MustNil(err)
			txhash, err := inttestSDK.TestTxWithMsgWithNonce(
				t,
				msgs.NewMsgExecuteRecipe(rcp.ID, sdkAddr, tc.itemIDs),
				"eugen",
				false,
			)
			if err != nil {
				t.WithFields(testing.Fields{
					"error": err,
				}).Fatal("unexpected transaction broadcast error")
				return
			}

			_, err = inttestSDK.WaitAndGetTxData(txhash, 3, t)
			if err != nil {
				t.WithFields(testing.Fields{
					"error": err,
				}).Fatal("error waiting for transaction")
			}
			// inttestSDK.WaitForNextBlock()
			items, err := inttestSDK.ListItemsViaCLI("")
			if err != nil {
				t.WithFields(testing.Fields{
					"error": err,
				}).Fatal("error listing items via cli")
			}

			_, ok := inttestSDK.FindItemFromArrayByName(items, tc.desiredItemName, false)
			t.MustTrue(ok)

			if tc.checkPylonDistribution {
				accInfo := inttestSDK.GetAccountInfoFromAddr(pylonsLLCAddress.String(), t)
				originPylonAmount := pylonsLLCAccInfo.Coins.AmountOf(types.Pylon)
				pylonAvailOnLLC := accInfo.Coins.AmountOf(types.Pylon).GTE(sdk.NewInt(originPylonAmount.Int64() + tc.pylonsLLCDistribution))
				t.MustTrue(pylonAvailOnLLC)
			}
		})
	}
}
