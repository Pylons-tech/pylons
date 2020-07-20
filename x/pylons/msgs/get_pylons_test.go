package msgs

import (
	"testing"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

func TestGoogleIAPSignatureVerification(t *testing.T) {
	sender, _ := sdk.AccAddressFromBech32("cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337")

	cases := map[string]struct {
		orderID       string
		packageName   string
		productID     string
		purchaseTime  int64
		purchaseState int64
		signature     string
		sender        sdk.AccAddress
		desiredError  string
		showError     bool
	}{
		"invalid token check": {
			orderID:       "GPA.3387-0058-0649-87584",
			packageName:   "com.pylons.loud",
			productID:     "pylons_1000",
			purchaseTime:  1595031050407,
			purchaseState: 0,
			// Correct token
			signature:    "HEo0RYQeH0+8nmYa6ETKP9f3S/W/cUuQTBme7VSh3Lzm+1+1GwJIl1pdF1dh32YGhd3BtyMoLVGzr9ZajfHhhznIvbowS/XIlyJJCE6dI+zg68mKo5rDt0wB2BY8azk0+WCkc5XT5y8biRNXe5RyvmuqYKPXmEsgHaYKo6x3mHs6oXrECckKv/c9T9MHCvdAqVFrml9W7K41sRHbpOdFmYnO33bkNITCCaf/C1PDGMVOItxvq7uXi+F0DpjXwXko9AU6L3pK6zDICcD38HblbzumOg6LGsuWCjOw8QwNobYOUNtrdj01fEXqkKhfYzFZcwxM6xsphN38gnO0ksDdyw==",
			sender:       sender,
			showError:    false,
			desiredError: "",
		},
		"successful check": {
			orderID:       "GPA.3387-0058-0649-87585",
			packageName:   "com.pylons.loud",
			productID:     "pylons_1000",
			purchaseTime:  1595031050410,
			purchaseState: 0,
			signature:     "FakeToken0833XweaU==", // Incorrect token
			sender:        sender,
			desiredError:  "wrong purchase token",
			showError:     true,
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			t.Log(tc)
			// msg := NewMsgGetPylons(tc.orderID, tc.packageName, tc.productID, tc.purchaseTime, tc.purchaseState, tc.signature, tc.sender)
			// validation := msg.ValidateBasic()
			// if !tc.showError {
			// 	require.True(t, validation == nil)
			// } else {
			// 	require.True(t, validation != nil)
			// 	require.True(t, strings.Contains(validation.Error(), tc.desiredError))
			// }
		})
	}
}
