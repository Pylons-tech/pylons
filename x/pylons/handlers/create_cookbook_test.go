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

func TestHandlerMsgCreateCookbook(t *testing.T) {
	mockedCoinInput := keep.SetupTestCoinInput()

	sender1, _ := sdk.AccAddressFromBech32("cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337")
	sender2, _ := sdk.AccAddressFromBech32("cosmos16wfryel63g7axeamw68630wglalcnk3l0zuadc")

	mockedCoinInput.Bk.AddCoins(mockedCoinInput.Ctx, sender1, types.PremiumTier.Fee)

	cases := map[string]struct {
		name         string
		desc         string
		sender       sdk.AccAddress
		level        types.Level
		desiredError string
		showError    bool
	}{
		"success check": {
			name:         "cookbook-00001",
			desc:         "this has to meet character limits",
			sender:       sender1,
			level:        1,
			desiredError: "",
			showError:    false,
		},
		"cookbook name length check": {
			name:         "id01",
			desc:         "this has to meet character limits",
			sender:       sender1,
			level:        0,
			desiredError: "the name of the cookbook should have more than 8 characters",
			showError:    true,
		},
		"balance check": {
			name:         "cookbook-00001",
			desc:         "this has to meet character limits",
			sender:       sender2,
			level:        0,
			desiredError: "the user doesn't have enough pylons",
			showError:    true,
		},
		"invalid plan check": {
			name:         "cookbook-00001",
			desc:         "this has to meet character limits",
			sender:       sender1,
			level:        2,
			desiredError: "Invalid cookbook plan",
			showError:    true,
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			msg := msgs.NewMsgCreateCookbook(tc.name, "", tc.desc, "SketchyCo", "1.0.0", "example@example.com", tc.level, msgs.DefaultCostPerBlock, tc.sender)

			result := HandlerMsgCreateCookbook(mockedCoinInput.Ctx, mockedCoinInput.PlnK, msg)

			if !tc.showError {
				cbData := CreateCBResponse{}
				err := json.Unmarshal(result.Data, &cbData)
				require.True(t, err == nil)
				require.True(t, len(cbData.CookbookID) > 0)
			} else {
				require.True(t, strings.Contains(result.Log, tc.desiredError))
			}
		})
	}
}

func TestSameCookbookIDCreation(t *testing.T) {
	mockedCoinInput := keep.SetupTestCoinInput()
	sender1, _ := sdk.AccAddressFromBech32("cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337")
	msg := msgs.NewMsgCreateCookbook("samecookbookID-0001", "samecookbookID-0001", "some description with 20 characters", "SketchyCo", "1.0.0", "example@example.com", 0, msgs.DefaultCostPerBlock, sender1)
	mockedCoinInput.Bk.AddCoins(mockedCoinInput.Ctx, sender1, types.NewPylon(10000000))

	result := HandlerMsgCreateCookbook(mockedCoinInput.Ctx, mockedCoinInput.PlnK, msg)
	cbData := CreateCBResponse{}
	err := json.Unmarshal(result.Data, &cbData)
	require.True(t, err == nil)
	require.True(t, len(cbData.CookbookID) > 0)

	secondResult := HandlerMsgCreateCookbook(mockedCoinInput.Ctx, mockedCoinInput.PlnK, msg)
	require.True(t, strings.Contains(secondResult.Log, "A cookbook with CookbookID samecookbookID-0001 already exists"))

}
