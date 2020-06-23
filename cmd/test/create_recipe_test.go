package inttest

import (
	"strings"
	originT "testing"

	testing "github.com/Pylons-tech/pylons_sdk/cmd/fixtures_test/evtesting"

	"github.com/Pylons-tech/pylons_sdk/x/pylons/types"

	inttestSDK "github.com/Pylons-tech/pylons_sdk/cmd/test"
	"github.com/Pylons-tech/pylons_sdk/x/pylons/handlers"
	"github.com/Pylons-tech/pylons_sdk/x/pylons/msgs"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

func TestCreateRecipeViaCLI(originT *originT.T) {
	t := testing.NewT(originT)
	t.Parallel()

	tests := []struct {
		name         string
		rcpName      string
		outputDenom  string
		desiredError string
		showError    bool
	}{
		{
			name:        "basic flow test",
			rcpName:     "TESTRCP_CreateRecipe_001",
			outputDenom: "chair",
			showError:   false,
		},
		{
			name:         "recipe with pylon denom as output",
			rcpName:      "TESTRCP_CreateRecipe_002",
			outputDenom:  "pylon",
			desiredError: "There should not be a recipe which generate pylon denom as an output",
			showError:    true,
		},
	}

	mCB := GetMockedCookbook(&t)

	for _, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			eugenAddr := inttestSDK.GetAccountAddr("eugen", t)
			sdkAddr, err := sdk.AccAddressFromBech32(eugenAddr)
			t.MustNil(err, "error converting string address to AccAddress struct")
			txhash, err := inttestSDK.TestTxWithMsgWithNonce(t,
				msgs.NewMsgCreateRecipe(
					tc.rcpName,
					mCB.ID,
					"",
					"this has to meet character limits lol",
					types.GenCoinInputList("wood", 5),
					types.GenItemInputList("Raichu"),
					types.GenEntries(tc.outputDenom, "Raichu"),
					types.GenOneOutput(2),
					0,
					sdkAddr),
				"eugen",
				false,
			)
			if err != nil {
				if tc.desiredError != "" {
					t.WithFields(testing.Fields{
						"txhash":        txhash,
						"error":         err,
						"desired_error": tc.desiredError,
					}).MustTrue(strings.Contains(err.Error(), tc.desiredError))
				} else {
					t.WithFields(testing.Fields{
						"txhash": txhash,
						"error":  err,
					}).Fatal("unexpected transaction broadcast error")
				}
				return
			}

			err = inttestSDK.WaitForNextBlock()
			t.MustNil(err, "error waiting for next block")

			txHandleResBytes, err := inttestSDK.WaitAndGetTxData(txhash, 3, t)
			t.WithFields(testing.Fields{
				"txhash":          txhash,
				"tx_result_bytes": string(txHandleResBytes),
			}).MustNil(err, "error geting transaction data")
			resp := handlers.CreateRecipeResponse{}
			err = inttestSDK.GetAminoCdc().UnmarshalJSON(txHandleResBytes, &resp)
			t.WithFields(testing.Fields{
				"tx_result_bytes": string(txHandleResBytes),
			}).MustNil(err, "error unmarshaling transaction result")
			t.MustTrue(resp.RecipeID != "", "recipe id should exist")
		})
	}
}
