package handlers

import (
	"strings"
	"testing"

	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	"github.com/google/uuid"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"
)

func TestHandlerMsgGetPylons(t *testing.T) {
	tci := keep.SetupTestCoinInput()
	sender1, sender2, sender3, _ := keep.SetupTestAccounts(t, tci, nil, nil, nil, nil)

	cases := map[string]struct {
		packageName     string
		productID       string
		fromAddress     sdk.AccAddress
		signature       string
		showError       bool
		desiredError    string
		reqAmount       int64
		tryReuseOrderID bool
		tryReuseErr     string
	}{
		"successful check": {
			packageName:     "com.pylons.loud",
			productID:       "pylons_55000",
			signature:       "TrueToken0833XweaU==", // Correct token
			fromAddress:     sender1,
			showError:       false,
			desiredError:    "",
			reqAmount:       55000,
			tryReuseOrderID: true,
			tryReuseErr:     "the iap order ID is already being used",
		},
		"different package successful check": {
			packageName:     "com.pylons.loud",
			productID:       "pylons_1000",
			signature:       "TrueToken0833XweaU==", // Correct token
			fromAddress:     sender2,
			showError:       false,
			desiredError:    "",
			reqAmount:       1000,
			tryReuseOrderID: true,
			tryReuseErr:     "the iap order ID is already being used",
		},
		"wrong signature check": {
			packageName:     "com.pylons.loud",
			productID:       "pylons_55000",
			signature:       "FakeToken0833XweaU==", // Incorrect token
			fromAddress:     sender3,
			showError:       true,
			desiredError:    "wrong purchase token",
			reqAmount:       55000,
			tryReuseOrderID: false,
			tryReuseErr:     "",
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			msg := msgs.NewMsgGetPylons(
				uuid.New().String(),
				tc.packageName,
				tc.productID,
				1526476218113,
				0,
				tc.signature,
				tc.fromAddress)
			_, err := HandlerMsgGetPylons(tci.Ctx, tci.PlnK, msg)

			if !tc.showError {
				require.True(t, tci.PlnK.CoinKeeper.HasCoins(tci.Ctx, tc.fromAddress, types.NewPylon(tc.reqAmount)))
				require.False(t, tci.PlnK.CoinKeeper.HasCoins(tci.Ctx, tc.fromAddress, types.NewPylon(tc.reqAmount+1)))
				require.True(t, tci.PlnK.CoinKeeper.HasCoins(tci.Ctx, tc.fromAddress, types.NewPylon(tc.reqAmount-1)))
			} else {
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			}

			if tc.tryReuseOrderID {
				_, err := HandlerMsgGetPylons(tci.Ctx, tci.PlnK, msg)
				require.True(t, err != nil)
				require.True(t, strings.Contains(err.Error(), tc.tryReuseErr))
			}
		})
	}
}
