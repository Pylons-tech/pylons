package keeper_test

import (
	"encoding/base64"
	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (suite *IntegrationTestSuite) TestValidateGoogleIAPSignature() {

	k := suite.k
	require := suite.Require()
	coinIssuer := types.DefaultCoinIssuers[0]

	cases := map[string]struct {
		productID       string
		purchaseToken   string
		receiptData     string
		signature       string
		fromAddress     string
		showError       bool
		desiredError    string
		reqAmount       int64
		tryReuseOrderID bool
		tryReuseErr     string
	}{
		"successful check": {
			productID:     "pylons_1000",
			purchaseToken: "hafokgmjfkcpdnbffanijckj.AO-J1OxXkrKdM8q14T49Qo5a723VG_8h_4MCY_M2Tqn91L0e7FjiVXsZ2Qxc1SnvoFzHN9jBCJpjZqD4ErYIquMG6Li_jUfcuKuXti_wsa7r48eWNA1Oh0o",
			receiptData:   to64(`{"productId":"pylons_1000","purchaseToken":"hafokgmjfkcpdnbffanijckj.AO-J1OxXkrKdM8q14T49Qo5a723VG_8h_4MCY_M2Tqn91L0e7FjiVXsZ2Qxc1SnvoFzHN9jBCJpjZqD4ErYIquMG6Li_jUfcuKuXti_wsa7r48eWNA1Oh0o","purchaseTime":1595031050407,"developerPayload":null}`),
			// Correct signature
			signature:       "HEo0RYQeH0+8nmYa6ETKP9f3S/W/cUuQTBme7VSh3Lzm+1+1GwJIl1pdF1dh32YGhd3BtyMoLVGzr9ZajfHhhznIvbowS/XIlyJJCE6dI+zg68mKo5rDt0wB2BY8azk0+WCkc5XT5y8biRNXe5RyvmuqYKPXmEsgHaYKo6x3mHs6oXrECckKv/c9T9MHCvdAqVFrml9W7K41sRHbpOdFmYnO33bkNITCCaf/C1PDGMVOItxvq7uXi+F0DpjXwXko9AU6L3pK6zDICcD38HblbzumOg6LGsuWCjOw8QwNobYOUNtrdj01fEXqkKhfYzFZcwxM6xsphN38gnO0ksDdyw==",
			fromAddress:     "sender1",
			showError:       false,
			desiredError:    "",
			reqAmount:       1000,
			tryReuseOrderID: true,
			tryReuseErr:     "the iap order ID is already being used",
		},
		"successful check2": {
			productID:     "pylons_1000",
			purchaseToken: "agpgcdbplfjjpkbgadnfkmec.AO-J1OxqC40C2YfQkf5jjDqN8gparJ6W-EbGtygUKQlbc_bPn1ZvZz2-a9UnfY3i6HUYk8M5p92uf29pE7ffNwTUg4XmGrR8y3dhz7EKssD6qp-dejCg2Rs",
			receiptData:   to64(`{"orderId":"GPA.3376-6117-5921-78573","packageName":"com.pylons.loud","productId":"pylons_1000","purchaseTime":1596428485456,"purchaseState":0,"purchaseToken":"agpgcdbplfjjpkbgadnfkmec.AO-J1OxqC40C2YfQkf5jjDqN8gparJ6W-EbGtygUKQlbc_bPn1ZvZz2-a9UnfY3i6HUYk8M5p92uf29pE7ffNwTUg4XmGrR8y3dhz7EKssD6qp-dejCg2Rs","acknowledged":false}`),
			// Correct signature
			signature:       "m1futpaJjRE/LwFQvvJmSN0uZrkzLRRUvkecuWLHKb3O+CDBkiQIg4PyIckzgjRcWkLEqKBrmlH8CoJ6T/+kEa0AJPbaxpOMyv3P6NAAkD9WOZYoh+cSOUCuhf9gDqucIfTKtU0f3fTNcFwqEovDXa06XocXPiq3T6yuewyzfCxPDAYGNyO9bj6phxYkwvVqeua6nYpFynFIe6UgyECBu9dydm3deDRublKolfF/GIGRJLvTSLkUN5O+ugMvz08Lun4RUrPUg5+RoV7Uq91JgYTrxCQu3fUMeGa3B8paIc+qO6m6Ezz/gkdUkPFmeUJGADrLBBJVw283+8ZySoP6sQ==",
			fromAddress:     "sender2",
			showError:       false,
			desiredError:    "",
			reqAmount:       1000,
			tryReuseOrderID: true,
			tryReuseErr:     "the iap order ID is already being used",
		},
		"wrong signature base64 encoding": {
			productID:     "pylons_1000",
			purchaseToken: "hafokgmjfkcpdnbffanijckj.AO-J1OxXkrKdM8q14T49Qo5a723VG_8h_4MCY_M2Tqn91L0e7FjiVXsZ2Qxc1SnvoFzHN9jBCJpjZqD4ErYIquMG6Li_jUfcuKuXti_wsa7r48eWNA1Oh0o",
			receiptData:   to64(`{"productId":"pylons_1000","purchaseToken":"hafokgmjfkcpdnbffanijckj.AO-J1OxXkrKdM8q14T49Qo5a723VG_8h_4MCY_M2Tqn91L0e7FjiVXsZ2Qxc1SnvoFzHN9jBCJpjZqD4ErYIquMG6Li_jUfcuKuXti_wsa7r48eWNA1Oh0o","purchaseTime":1595031050407,"developerPayload":null}`),
			// Invalid base64 formatting
			signature:    "Invalid signature",
			fromAddress:  "sender3",
			showError:    true,
			desiredError: "msg signature base64 decoding failure: illegal base64 data at input byte 7",
		},
		"wrong signature check": {
			productID:     "pylons_55000",
			purchaseToken: "hafokgmjfkcpdnbffanijckj.AO-J1OxXkrKdM8q14T49Qo5a723VG_8h_4MCY_M2Tqn91L0e7FjiVXsZ2Qxc1SnvoFzHN9jBCJpjZqD4ErYIquMG6Li_jUfcuKuXti_wsa7r48eWNA1Oh0o",
			receiptData:   to64(`{"productId":"pylons_55000","purchaseToken":"hafokgmjfkcpdnbffanijckj.AO-J1OxXkrKdM8q14T49Qo5a723VG_8h_4MCY_M2Tqn91L0e7FjiVXsZ2Qxc1SnvoFzHN9jBCJpjZqD4ErYIquMG6Li_jUfcuKuXti_wsa7r48eWNA1Oh0o","purchaseTime":1595031050407,"developerPayload":null}`),
			// Correct signature
			signature:    "HEo0RYQeH0+8nmYa6ETKP9f3S/W/cUuQTBme7VSh3Lzm+1+1GwJIl1pdF1dh32YGhd3BtyMoLVGzr9ZajfHhhznIvbowS/XIlyJJCE6dI+zg68mKo5rDt0wB2BY8azk0+WCkc5XT5y8biRNXe5RyvmuqYKPXmEsgHaYKo6x3mHs6oXrECckKv/c9T9MHCvdAqVFrml9W7K41sRHbpOdFmYnO33bkNITCCaf/C1PDGMVOItxvq7uXi+F0DpjXwXko9AU6L3pK6zDICcD38HblbzumOg6LGsuWCjOw8QwNobYOUNtrdj01fEXqkKhfYzFZcwxM6xsphN38gnO0ksDdyw==",
			fromAddress:  "sender3",
			showError:    true,
			desiredError: "crypto/rsa: verification error",
		},
	}

	for _,data := range cases {
			testData := types.MsgGoogleInAppPurchaseGetCoins {
				Creator: data.fromAddress,
				ProductID: data.productID,
				PurchaseToken: data.purchaseToken,
				ReceiptDataBase64: data.receiptData,
				Signature: data.signature,
			}
			err := k.ValidateGoogleIAPSignature(&testData, coinIssuer)
			if data.showError {
				require.True(data.desiredError == err.Error())
			}else{
				require.NoError(err)
			}
	}
}

func to64(data string) string {
	return 	base64.StdEncoding.EncodeToString([]byte(data))
}

