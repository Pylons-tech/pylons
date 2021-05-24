package inttest

import (
	"encoding/base64"
	"fmt"
	originT "testing"
	"time"

	testing "github.com/Pylons-tech/pylons_sdk/cmd/evtesting"

	inttestSDK "github.com/Pylons-tech/pylons_sdk/cmd/test_utils"
	"github.com/Pylons-tech/pylons_sdk/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

func TesStripeGetPylonsViaCLI(originT *originT.T) {
	t := testing.NewT(originT)
	t.Parallel()

	tests := []struct {
		name            string
		productID       string
		paymentId       string
		paymentMethod   string
		receiptData     string
		signature       string
		fromAddress     sdk.AccAddress
		showError       bool
		desiredError    string
		reqAmount       int64
		tryReuseOrderID bool
		tryReuseErr     string
	}{
		{
			name:          "successful check2",
			productID:     "pylons_1000",
			paymentId:     "pi_1DoShv2eZvKYlo2CqsROyFun",
			paymentMethod: "card",
			receiptData:   `{"orderId":"GPA.3376-6117-5921-78573","packageName":"com.pylons.loud","productId":"pylons_1000","purchaseTime":1596428485456,"purchaseState":0,"purchaseToken":"agpgcdbplfjjpkbgadnfkmec.AO-J1OxqC40C2YfQkf5jjDqN8gparJ6W-EbGtygUKQlbc_bPn1ZvZz2-a9UnfY3i6HUYk8M5p92uf29pE7ffNwTUg4XmGrR8y3dhz7EKssD6qp-dejCg2Rs","acknowledged":false}`,
			// Correct signature
			signature:       "m1futpaJjRE/LwFQvvJmSN0uZrkzLRRUvkecuWLHKb3O+CDBkiQIg4PyIckzgjRcWkLEqKBrmlH8CoJ6T/+kEa0AJPbaxpOMyv3P6NAAkD9WOZYoh+cSOUCuhf9gDqucIfTKtU0f3fTNcFwqEovDXa06XocXPiq3T6yuewyzfCxPDAYGNyO9bj6phxYkwvVqeua6nYpFynFIe6UgyECBu9dydm3deDRublKolfF/GIGRJLvTSLkUN5O+ugMvz08Lun4RUrPUg5+RoV7Uq91JgYTrxCQu3fUMeGa3B8paIc+qO6m6Ezz/gkdUkPFmeUJGADrLBBJVw283+8ZySoP6sQ==",
			showError:       false,
			desiredError:    "",
			reqAmount:       0,
			tryReuseOrderID: true,
			tryReuseErr:     "the iap order ID is already being used",
		},
	}

	for tcNum, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			getPylonsKey := fmt.Sprintf("TestStripeGetPylonsViaCLI%d_%d", tcNum, time.Now().Unix())
			MockAccount(getPylonsKey, t) // mock account with initial balance

			getPylonsAddr := inttestSDK.GetAccountAddr(getPylonsKey, t)
			getPylonsAccInfo := inttestSDK.GetAccountBalanceFromAddr(getPylonsAddr, t)

			receiptDataBase64 := base64.StdEncoding.EncodeToString([]byte(tc.receiptData))

			msgStripeGetPylons := types.NewMsgStripeGetPylons(tc.productID, tc.paymentId, receiptDataBase64, tc.signature, getPylonsAccInfo.Address)
			txhash, err := inttestSDK.TestTxWithMsgWithNonce(t,
				&msgStripeGetPylons,
				getPylonsKey,
				false,
			)
			if err != nil {
				TxBroadcastErrorExpected(txhash, err, tc.desiredError, t)
				return
			}

			GetTxHandleResult(txhash, t)
			if tc.showError {
			} else {
				accInfo := inttestSDK.GetAccountBalanceFromAddr(getPylonsAddr, t)
				balanceOk := accInfo.Coins.AmountOf(types.Pylon).Equal(sdk.NewInt(getPylonsAccInfo.Coins.AmountOf(types.Pylon).Int64() + tc.reqAmount))
				t.WithFields(testing.Fields{
					"iap_get_pylons_key":     getPylonsKey,
					"iap_get_pylons_address": getPylonsAddr,
					"request_amount":         tc.reqAmount,
					"base_amount":            getPylonsAccInfo.Coins.AmountOf(types.Pylon).Int64(),
					"actual_amount":          accInfo.Coins.AmountOf(types.Pylon).Int64(),
				}).MustTrue(balanceOk, "pylons requestor should get correct revenue")
			}

			if tc.tryReuseOrderID {
				txhash, err := inttestSDK.TestTxWithMsgWithNonce(t,
					&msgStripeGetPylons,
					getPylonsKey,
					false,
				)
				t.MustNil(err)
				txHandleErr := GetTxHandleError(txhash, t)
				t.MustContain(string(txHandleErr), tc.tryReuseErr)
			}
		})
	}
}
