package handlers

import (
	"strings"
	"testing"

	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"
)

func TestHandlerMsgCreateCookbook(t *testing.T) {
	tci := keep.SetupTestCoinInput()
	tci.PlnH = NewMsgServerImpl(tci.PlnK)
	sender1, sender2, _, _ := keep.SetupTestAccounts(t, tci, types.NewPylon(1000000), nil, nil, nil)

	cases := map[string]struct {
		name         string
		desc         string
		sender       sdk.AccAddress
		level        int64
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
			msg := types.NewMsgCreateCookbook(tc.name, "", tc.desc, "SketchyCo",
				"1.0.0", "example@example.com", tc.level, types.DefaultCostPerBlock, tc.sender.String())

			result, err := tci.PlnH.CreateCookbook(sdk.WrapSDKContext(tci.Ctx), &msg)

			if !tc.showError {
				require.True(t, len(result.CookbookID) > 0)
			} else {
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			}
		})
	}
}

func TestSameCookbookIDCreation(t *testing.T) {
	tci := keep.SetupTestCoinInput()
	tci.PlnH = NewMsgServerImpl(tci.PlnK)
	sender1, _, _, _ := keep.SetupTestAccounts(t, tci, types.NewPylon(10000000), nil, nil, nil)

	msg := types.NewMsgCreateCookbook("samecookbookID-0001", "samecookbookID-0001", "some description with 20 characters", "SketchyCo", "1.0.0", "example@example.com", 0, types.DefaultCostPerBlock, sender1.String())

	result, _ := tci.PlnH.CreateCookbook(sdk.WrapSDKContext(tci.Ctx), &msg)
	require.True(t, len(result.CookbookID) > 0)

	_, err := tci.PlnH.CreateCookbook(sdk.WrapSDKContext(tci.Ctx), &msg)
	require.True(t, strings.Contains(err.Error(), "A cookbook with CookbookID samecookbookID-0001 already exists"))
}
