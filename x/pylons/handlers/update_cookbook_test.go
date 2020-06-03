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

func TestHandlerMsgUpdateCookbook(t *testing.T) {
	mockedCoinInput := keep.SetupTestCoinInput()

	sender1, _ := sdk.AccAddressFromBech32("cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337")
	sender2, _ := sdk.AccAddressFromBech32("cosmos16wfryel63g7axeamw68630wglalcnk3l0zuadc")

	_, err := mockedCoinInput.Bk.AddCoins(mockedCoinInput.Ctx, sender1, types.NewPylon(1000000))
	require.True(t, err == nil)

	cb := types.NewCookbook(
		"example@example.com",
		sender1,
		"1.0.0",
		"cookbook0001",
		"this has to meet character limits",
		"SketchyCo",
		msgs.DefaultCostPerBlock,
	)
	err = mockedCoinInput.PlnK.SetCookbook(mockedCoinInput.Ctx, cb)
	require.True(t, err == nil)

	cases := map[string]struct {
		cbID         string
		desc         string
		sender       sdk.AccAddress
		level        types.Level
		desiredError string
		showError    bool
	}{
		"success check": {
			cbID:         cb.ID,
			desc:         "this has to meet character limits - updated description",
			sender:       sender1,
			level:        1,
			desiredError: "",
			showError:    false,
		},
		"owner check": {
			cbID:         cb.ID,
			desc:         "this has to meet character limits - updated description",
			sender:       sender2,
			level:        1,
			desiredError: "the owner of the cookbook is different then the current sender",
			showError:    true,
		},
		"invalid cookbookID check": {
			cbID:         "invalidCookbookID",
			desc:         "this has to meet character limits - updated description",
			sender:       sender2,
			level:        1,
			desiredError: "The cookbook doesn't exist",
			showError:    true,
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			msg := msgs.NewMsgUpdateCookbook(tc.cbID, tc.desc, "SketchyCo", "1.0.0", "example@example.com", tc.sender)

			_, err := HandlerMsgUpdateCookbook(mockedCoinInput.Ctx, mockedCoinInput.PlnK, msg)

			if !tc.showError {
				readCookbook, err2 := mockedCoinInput.PlnK.GetCookbook(mockedCoinInput.Ctx, tc.cbID)
				require.True(t, err2 == nil)
				require.True(t, readCookbook.Description == tc.desc)
			} else {
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			}
		})
	}
}
