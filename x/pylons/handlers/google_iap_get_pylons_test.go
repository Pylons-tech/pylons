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
	tci.PlnH = NewMsgServerImpl(tci.PlnK)
	sender1, sender2, sender3, _ := keep.SetupTestAccounts(t, tci, nil, nil, nil, nil)

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
		"successful check2": {
			productID:     "pylons_1000",
			purchaseToken: "agpgcdbplfjjpkbgadnfkmec.AO-J1OxqC40C2YfQkf5jjDqN8gparJ6W-EbGtygUKQlbc_bPn1ZvZz2-a9UnfY3i6HUYk8M5p92uf29pE7ffNwTUg4XmGrR8y3dhz7EKssD6qp-dejCg2Rs",
			receiptData:   `{"orderId":"GPA.3376-6117-5921-78573","packageName":"com.pylons.loud","productId":"pylons_1000","purchaseTime":1596428485456,"purchaseState":0,"purchaseToken":"agpgcdbplfjjpkbgadnfkmec.AO-J1OxqC40C2YfQkf5jjDqN8gparJ6W-EbGtygUKQlbc_bPn1ZvZz2-a9UnfY3i6HUYk8M5p92uf29pE7ffNwTUg4XmGrR8y3dhz7EKssD6qp-dejCg2Rs","acknowledged":false}`,
			// Correct signature
			signature:       "m1futpaJjRE/LwFQvvJmSN0uZrkzLRRUvkecuWLHKb3O+CDBkiQIg4PyIckzgjRcWkLEqKBrmlH8CoJ6T/+kEa0AJPbaxpOMyv3P6NAAkD9WOZYoh+cSOUCuhf9gDqucIfTKtU0f3fTNcFwqEovDXa06XocXPiq3T6yuewyzfCxPDAYGNyO9bj6phxYkwvVqeua6nYpFynFIe6UgyECBu9dydm3deDRublKolfF/GIGRJLvTSLkUN5O+ugMvz08Lun4RUrPUg5+RoV7Uq91JgYTrxCQu3fUMeGa3B8paIc+qO6m6Ezz/gkdUkPFmeUJGADrLBBJVw283+8ZySoP6sQ==",
			fromAddress:     sender2,
			showError:       false,
			desiredError:    "",
			reqAmount:       1000,
			tryReuseOrderID: true,
			tryReuseErr:     "the iap order ID is already being used",
		},
		"wrong signature base64 encoding": {
			productID:     "pylons_1000",
			purchaseToken: "hafokgmjfkcpdnbffanijckj.AO-J1OxXkrKdM8q14T49Qo5a723VG_8h_4MCY_M2Tqn91L0e7FjiVXsZ2Qxc1SnvoFzHN9jBCJpjZqD4ErYIquMG6Li_jUfcuKuXti_wsa7r48eWNA1Oh0o",
			receiptData:   `{"productId":"pylons_1000","purchaseToken":"hafokgmjfkcpdnbffanijckj.AO-J1OxXkrKdM8q14T49Qo5a723VG_8h_4MCY_M2Tqn91L0e7FjiVXsZ2Qxc1SnvoFzHN9jBCJpjZqD4ErYIquMG6Li_jUfcuKuXti_wsa7r48eWNA1Oh0o","purchaseTime":1595031050407,"developerPayload":null}`,
			// Invalid base64 formatting
			signature:    "Invalid signature",
			fromAddress:  sender3,
			showError:    true,
			desiredError: "msg signature base64 decoding failure",
		},
		"wrong signature check": {
			productID:     "pylons_55000",
			purchaseToken: "hafokgmjfkcpdnbffanijckj.AO-J1OxXkrKdM8q14T49Qo5a723VG_8h_4MCY_M2Tqn91L0e7FjiVXsZ2Qxc1SnvoFzHN9jBCJpjZqD4ErYIquMG6Li_jUfcuKuXti_wsa7r48eWNA1Oh0o",
			receiptData:   `{"productId":"pylons_55000","purchaseToken":"hafokgmjfkcpdnbffanijckj.AO-J1OxXkrKdM8q14T49Qo5a723VG_8h_4MCY_M2Tqn91L0e7FjiVXsZ2Qxc1SnvoFzHN9jBCJpjZqD4ErYIquMG6Li_jUfcuKuXti_wsa7r48eWNA1Oh0o","purchaseTime":1595031050407,"developerPayload":null}`,
			// Correct signature
			signature:    "HEo0RYQeH0+8nmYa6ETKP9f3S/W/cUuQTBme7VSh3Lzm+1+1GwJIl1pdF1dh32YGhd3BtyMoLVGzr9ZajfHhhznIvbowS/XIlyJJCE6dI+zg68mKo5rDt0wB2BY8azk0+WCkc5XT5y8biRNXe5RyvmuqYKPXmEsgHaYKo6x3mHs6oXrECckKv/c9T9MHCvdAqVFrml9W7K41sRHbpOdFmYnO33bkNITCCaf/C1PDGMVOItxvq7uXi+F0DpjXwXko9AU6L3pK6zDICcD38HblbzumOg6LGsuWCjOw8QwNobYOUNtrdj01fEXqkKhfYzFZcwxM6xsphN38gnO0ksDdyw==",
			fromAddress:  sender3,
			showError:    true,
			desiredError: "crypto/rsa: verification error",
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
				tc.fromAddress.String())
			_, err := tci.PlnH.GoogleIAPGetPylons(sdk.WrapSDKContext(tci.Ctx), &msg)

			if !tc.showError {
				require.True(t, err == nil, err)
				amount := tci.PlnK.CoinKeeper.GetAllBalances(tci.Ctx, tc.fromAddress).AmountOf(types.Pylon).Int64()
				require.True(t, amount == tc.reqAmount)
			} else {
				require.True(t, err != nil)
				require.True(t, strings.Contains(err.Error(), tc.desiredError), err.Error())
			}

			if tc.tryReuseOrderID {
				_, err := tci.PlnH.GoogleIAPGetPylons(sdk.WrapSDKContext(tci.Ctx), &msg)
				require.True(t, err != nil)
				require.True(t, strings.Contains(err.Error(), tc.tryReuseErr))
			}
		})
	}
}
