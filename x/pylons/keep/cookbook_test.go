package keep

import (
	"testing"

	"github.com/MikeSofaer/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"
)

func TestKeeperGetCookbook(t *testing.T) {
	mockedCoinInput := setupTestCoinInput()

	sender, _ := sdk.AccAddressFromBech32("cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337")

	mockedCoinInput.bk.AddCoins(mockedCoinInput.ctx, sender, types.PremiumTier.Fee)

	cases := map[string]struct {
		name         string
		desc         string
		sender       sdk.AccAddress
		level        types.Level
		desiredError string
		showError    bool
	}{
		"basic flow test": {
			name:         "cookbook-00001",
			desc:         "this has to meet character limits",
			sender:       sender,
			level:        1,
			desiredError: "",
			showError:    false,
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			cb := types.NewCookbook(
				"example@example.com", // msg.SupportEmail,
				tc.sender,             // msg.Sender,
				"1.0.0",               // msg.Version,
				tc.name,               // msg.Name,
				tc.desc,               // msg.Description,
				"SketchyCo",           // msg.Developer
			)
			err := mockedCoinInput.plnK.SetCookbook(mockedCoinInput.ctx, cb)
			require.True(t, err == nil)

			readCookbook, err2 := mockedCoinInput.plnK.GetCookbook(mockedCoinInput.ctx, cb.ID)
			// t.Errorf("CookbookTEST LOG:: %+v", err2)
			require.True(t, err2 == nil)
			require.True(t, cb.SupportEmail == readCookbook.SupportEmail)
		})
	}
}
