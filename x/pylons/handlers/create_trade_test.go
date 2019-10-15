package handlers

import (
	"encoding/json"
	"strings"
	"testing"

	"github.com/MikeSofaer/pylons/x/pylons/keep"
	"github.com/MikeSofaer/pylons/x/pylons/msgs"
	"github.com/MikeSofaer/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"
)

func TestHandlerMsgCreateTrade(t *testing.T) {
	mockedCoinInput := keep.SetupTestCoinInput()

	sender, _ := sdk.AccAddressFromBech32("cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337")
	mockedCoinInput.Bk.AddCoins(mockedCoinInput.Ctx, sender, types.PremiumTier.Fee)

	cases := map[string]struct {
		recipeDesc   string
		sender       sdk.AccAddress
		desiredError string
		showError    bool
	}{
		"successful check": {
			recipeDesc:   "this has to meet character limits",
			sender:       sender,
			desiredError: "",
			showError:    false,
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			msg := msgs.NewMsgCreateTrade("name", tc.recipeDesc,
				types.GenCoinInputList("wood", 5),
				types.GenItemInputList("Raichu"),
				types.GenEntries("chair", "Raichu"),
				0,
				tc.sender,
			)

			result := HandlerMsgCreateTrade(mockedCoinInput.Ctx, mockedCoinInput.PlnK, msg)
			if !tc.showError {
				recipeData := CreateTradeResponse{}
				err := json.Unmarshal(result.Data, &recipeData)
				require.True(t, err == nil)
				require.True(t, len(recipeData.TradeID) > 0)
			} else {
				require.True(t, strings.Contains(result.Log, tc.desiredError))
			}
		})
	}
}
