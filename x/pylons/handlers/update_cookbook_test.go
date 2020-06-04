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
	tci := keep.SetupTestCoinInput()
	sender1, sender2 := keep.SetupTestAccounts(t, tci, types.NewPylon(1000000))

	cb := types.NewCookbook(
		"example@example.com",
		sender1,
		"1.0.0",
		"cookbook0001",
		"this has to meet character limits",
		"SketchyCo",
		msgs.DefaultCostPerBlock,
	)
	err := tci.PlnK.SetCookbook(tci.Ctx, cb)
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

			_, err := HandlerMsgUpdateCookbook(tci.Ctx, tci.PlnK, msg)

			if !tc.showError {
				readCookbook, err2 := tci.PlnK.GetCookbook(tci.Ctx, tc.cbID)
				require.True(t, err2 == nil)
				require.True(t, readCookbook.Description == tc.desc)
			} else {
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			}
		})
	}
}
