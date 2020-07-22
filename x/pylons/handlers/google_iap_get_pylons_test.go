package handlers

import (
	"encoding/base64"
	"strings"
	"testing"

	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	"github.com/Pylons-tech/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"
)

func TestHandlerMsgGoogleIAPGetPylons(t *testing.T) {
	tci := keep.SetupTestCoinInput()
	sender1, _, sender3, _ := keep.SetupTestAccounts(t, tci, nil, nil, nil, nil)

	cases := map[string]struct {
		productID       string
		purchaseToken   string
		receiptData     string
		signature       string
		fromAddress     sdk.AccAddress
		showError       bool
		desiredError    string
		reqAmount       int64
		tryReuseOrderID bool
		tryReuseErr     string
	}{
		"successful check": {
			productID:     "pylons_1000",
			purchaseToken: "hafokgmjfkcpdnbffanijckj.AO-J1OxXkrKdM8q14T49Qo5a723VG_8h_4MCY_M2Tqn91L0e7FjiVXsZ2Qxc1SnvoFzHN9jBCJpjZqD4ErYIquMG6Li_jUfcuKuXti_wsa7r48eWNA1Oh0o",
			receiptData:   `{"productId":"pylons_1000","purchaseToken":"hafokgmjfkcpdnbffanijckj.AO-J1OxXkrKdM8q14T49Qo5a723VG_8h_4MCY_M2Tqn91L0e7FjiVXsZ2Qxc1SnvoFzHN9jBCJpjZqD4ErYIquMG6Li_jUfcuKuXti_wsa7r48eWNA1Oh0o","purchaseTime":1595031050407,"developerPayload":null}`,
			// Correct signature
			signature:       "HEo0RYQeH0+8nmYa6ETKP9f3S/W/cUuQTBme7VSh3Lzm+1+1GwJIl1pdF1dh32YGhd3BtyMoLVGzr9ZajfHhhznIvbowS/XIlyJJCE6dI+zg68mKo5rDt0wB2BY8azk0+WCkc5XT5y8biRNXe5RyvmuqYKPXmEsgHaYKo6x3mHs6oXrECckKv/c9T9MHCvdAqVFrml9W7K41sRHbpOdFmYnO33bkNITCCaf/C1PDGMVOItxvq7uXi+F0DpjXwXko9AU6L3pK6zDICcD38HblbzumOg6LGsuWCjOw8QwNobYOUNtrdj01fEXqkKhfYzFZcwxM6xsphN38gnO0ksDdyw==",
			fromAddress:     sender1,
			showError:       false,
			desiredError:    "",
			reqAmount:       1000,
			tryReuseOrderID: true,
			tryReuseErr:     "the iap order ID is already being used",
		},
		"wrong signature check": {
			productID:     "pylons_1000",
			purchaseToken: "hafokgmjfkcpdnbffanijckj.AO-J1OxXkrKdM8q14T49Qo5a723VG_8h_4MCY_M2Tqn91L0e7FjiVXsZ2Qxc1SnvoFzHN9jBCJpjZqD4ErYIquMG6Li_jUfcuKuXti_wsa7r48eWNA1Oh0o",
			receiptData:   `{"productId":"pylons_1000","purchaseToken":"hafokgmjfkcpdnbffanijckj.AO-J1OxXkrKdM8q14T49Qo5a723VG_8h_4MCY_M2Tqn91L0e7FjiVXsZ2Qxc1SnvoFzHN9jBCJpjZqD4ErYIquMG6Li_jUfcuKuXti_wsa7r48eWNA1Oh0o","purchaseTime":1595031050407,"developerPayload":null}`,
			// Correct signature
			signature:       "Invalid signature",
			fromAddress:     sender3,
			showError:       true,
			desiredError:    "crypto/rsa: verification error",
			reqAmount:       1000,
			tryReuseOrderID: false,
			tryReuseErr:     "",
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			receiptDataBase64 := base64.StdEncoding.EncodeToString([]byte(tc.receiptData))
			msg := msgs.NewMsgGoogleIAPGetPylons(
				tc.productID,
				tc.purchaseToken,
				receiptDataBase64,
				tc.signature,
				tc.fromAddress)
			_, err := HandlerMsgGoogleIAPGetPylons(tci.Ctx, tci.PlnK, msg)

			if !tc.showError {
				require.True(t, err == nil, err)
				require.True(t, tci.PlnK.CoinKeeper.HasCoins(tci.Ctx, tc.fromAddress, types.NewPylon(tc.reqAmount)))
				require.False(t, tci.PlnK.CoinKeeper.HasCoins(tci.Ctx, tc.fromAddress, types.NewPylon(tc.reqAmount+1)))
				require.True(t, tci.PlnK.CoinKeeper.HasCoins(tci.Ctx, tc.fromAddress, types.NewPylon(tc.reqAmount-1)))
			} else {
				require.True(t, err != nil)
				require.True(t, strings.Contains(err.Error(), tc.desiredError), err.Error())
			}

			if tc.tryReuseOrderID {
				_, err := HandlerMsgGoogleIAPGetPylons(tci.Ctx, tci.PlnK, msg)
				require.True(t, err != nil)
				require.True(t, strings.Contains(err.Error(), tc.tryReuseErr))
			}
		})
	}
}
