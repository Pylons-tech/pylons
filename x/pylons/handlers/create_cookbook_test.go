package handlers

import (
	"encoding/json"
	"strings"
	"testing"

	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	"github.com/Pylons-tech/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"
)

func TestHandlerMsgCreateCookbook(t *testing.T) {
	tci := keep.SetupTestCoinInput()
	sender1, sender2 := SetupTestAccounts(t, tci, types.NewPylon(1000000))

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

			result, err := HandlerMsgCreateCookbook(tci.Ctx, tci.PlnK, msg)

			if !tc.showError {
				cbData := CreateCBResponse{}
				err := json.Unmarshal(result.Data, &cbData)
				require.True(t, err == nil)
				require.True(t, len(cbData.CookbookID) > 0)
			} else {
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			}
		})
	}
}

func TestSameCookbookIDCreation(t *testing.T) {
	tci := keep.SetupTestCoinInput()
	sender1, _ := sdk.AccAddressFromBech32("cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337")
	msg := msgs.NewMsgCreateCookbook("samecookbookID-0001", "samecookbookID-0001", "some description with 20 characters", "SketchyCo", "1.0.0", "example@example.com", 0, msgs.DefaultCostPerBlock, sender1)
	_, err := tci.Bk.AddCoins(tci.Ctx, sender1, types.NewPylon(10000000))
	require.True(t, err == nil)

	result, _ := HandlerMsgCreateCookbook(tci.Ctx, tci.PlnK, msg)
	cbData := CreateCBResponse{}
	err = json.Unmarshal(result.Data, &cbData)
	require.True(t, err == nil)
	require.True(t, len(cbData.CookbookID) > 0)

	_, err = HandlerMsgCreateCookbook(tci.Ctx, tci.PlnK, msg)
	require.True(t, strings.Contains(err.Error(), "A cookbook with CookbookID samecookbookID-0001 already exists"))

}
