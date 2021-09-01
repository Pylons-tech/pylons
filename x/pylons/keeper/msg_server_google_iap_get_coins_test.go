package keeper_test

import (
	"encoding/base64"
	"github.com/Pylons-tech/pylons/x/pylons/keeper"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	bankTypes "github.com/cosmos/cosmos-sdk/x/bank/types"
)

func (suite *IntegrationTestSuite) TestMsgServerGoogleInAppPurchaseGetCoins() {
	k := suite.k
	bk := suite.bankKeeper
	ctx := suite.ctx
	require := suite.Require()

	srv := keeper.NewMsgServerImpl(k)
	wctx := sdk.WrapSDKContext(ctx)

	// since we are testing pylons GoogleIAPs, we need to set the pylons supply to be not nil
	supply := bankTypes.NewSupply(sdk.NewCoins(sdk.NewCoin(types.PylonsCoinDenom, sdk.NewInt(1))))
	bk.SetSupply(ctx, supply)

	for _, tc := range []struct {
		desc    string
		request *types.MsgGoogleInAppPurchaseGetCoins
		balance sdk.Coins
		err     error
	}{
		{
			// need to run first - using same purchase token as valid tests
			desc: "WrongEncoding",
			request: &types.MsgGoogleInAppPurchaseGetCoins{
				Creator:           types.GenTestBech32FromString("sender"),
				ProductID:         "pylons_1000",
				PurchaseToken:     "hafokgmjfkcpdnbffanijckj.AO-J1OxXkrKdM8q14T49Qo5a723VG_8h_4MCY_M2Tqn91L0e7FjiVXsZ2Qxc1SnvoFzHN9jBCJpjZqD4ErYIquMG6Li_jUfcuKuXti_wsa7r48eWNA1Oh0o",
				ReceiptDataBase64: to64(`{"productId":"pylons_1000","purchaseToken":"hafokgmjfkcpdnbffanijckj.AO-J1OxXkrKdM8q14T49Qo5a723VG_8h_4MCY_M2Tqn91L0e7FjiVXsZ2Qxc1SnvoFzHN9jBCJpjZqD4ErYIquMG6Li_jUfcuKuXti_wsa7r48eWNA1Oh0o","purchaseTime":1595031050407,"developerPayload":null}`),
				Signature:         "invalid signature",
			},
			err: sdkerrors.Wrap(sdkerrors.ErrorInvalidSigner, "Google IAP Signature is invalid"),
		},
		{
			// need to run first - using same purchase token as valid tests
			desc: "WrongSignature",
			request: &types.MsgGoogleInAppPurchaseGetCoins{
				Creator:           types.GenTestBech32FromString("sender"),
				ProductID:         "pylons_55000",
				PurchaseToken:     "hafokgmjfkcpdnbffanijckj.AO-J1OxXkrKdM8q14T49Qo5a723VG_8h_4MCY_M2Tqn91L0e7FjiVXsZ2Qxc1SnvoFzHN9jBCJpjZqD4ErYIquMG6Li_jUfcuKuXti_wsa7r48eWNA1Oh0o",
				ReceiptDataBase64: to64(`{"productId":"pylons_55000","purchaseToken":"hafokgmjfkcpdnbffanijckj.AO-J1OxXkrKdM8q14T49Qo5a723VG_8h_4MCY_M2Tqn91L0e7FjiVXsZ2Qxc1SnvoFzHN9jBCJpjZqD4ErYIquMG6Li_jUfcuKuXti_wsa7r48eWNA1Oh0o","purchaseTime":1595031050407,"developerPayload":null}`),
				Signature:         "HEo0RYQeH0+8nmYa6ETKP9f3S/W/cUuQTBme7VSh3Lzm+1+1GwJIl1pdF1dh32YGhd3BtyMoLVGzr9ZajfHhhznIvbowS/XIlyJJCE6dI+zg68mKo5rDt0wB2BY8azk0+WCkc5XT5y8biRNXe5RyvmuqYKPXmEsgHaYKo6x3mHs6oXrECckKv/c9T9MHCvdAqVFrml9W7K41sRHbpOdFmYnO33bkNITCCaf/C1PDGMVOItxvq7uXi+F0DpjXwXko9AU6L3pK6zDICcD38HblbzumOg6LGsuWCjOw8QwNobYOUNtrdj01fEXqkKhfYzFZcwxM6xsphN38gnO0ksDdyw==",
			},
			err: sdkerrors.Wrap(sdkerrors.ErrorInvalidSigner, "Google IAP Signature is invalid"),
		},
		{
			desc: "Valid1",
			request: &types.MsgGoogleInAppPurchaseGetCoins{
				Creator:           types.GenTestBech32FromString("sender1"),
				ProductID:         "pylons_1000",
				PurchaseToken:     "hafokgmjfkcpdnbffanijckj.AO-J1OxXkrKdM8q14T49Qo5a723VG_8h_4MCY_M2Tqn91L0e7FjiVXsZ2Qxc1SnvoFzHN9jBCJpjZqD4ErYIquMG6Li_jUfcuKuXti_wsa7r48eWNA1Oh0o",
				ReceiptDataBase64: to64(`{"productId":"pylons_1000","purchaseToken":"hafokgmjfkcpdnbffanijckj.AO-J1OxXkrKdM8q14T49Qo5a723VG_8h_4MCY_M2Tqn91L0e7FjiVXsZ2Qxc1SnvoFzHN9jBCJpjZqD4ErYIquMG6Li_jUfcuKuXti_wsa7r48eWNA1Oh0o","purchaseTime":1595031050407,"developerPayload":null}`),
				Signature:         "HEo0RYQeH0+8nmYa6ETKP9f3S/W/cUuQTBme7VSh3Lzm+1+1GwJIl1pdF1dh32YGhd3BtyMoLVGzr9ZajfHhhznIvbowS/XIlyJJCE6dI+zg68mKo5rDt0wB2BY8azk0+WCkc5XT5y8biRNXe5RyvmuqYKPXmEsgHaYKo6x3mHs6oXrECckKv/c9T9MHCvdAqVFrml9W7K41sRHbpOdFmYnO33bkNITCCaf/C1PDGMVOItxvq7uXi+F0DpjXwXko9AU6L3pK6zDICcD38HblbzumOg6LGsuWCjOw8QwNobYOUNtrdj01fEXqkKhfYzFZcwxM6xsphN38gnO0ksDdyw==",
			},
			balance: sdk.NewCoins(sdk.NewCoin(types.PylonsCoinDenom, sdk.NewInt(1000))),
		},
		{
			desc: "Valid2",
			request: &types.MsgGoogleInAppPurchaseGetCoins{
				Creator:           types.GenTestBech32FromString("sender2"),
				ProductID:         "pylons_1000",
				PurchaseToken:     "agpgcdbplfjjpkbgadnfkmec.AO-J1OxqC40C2YfQkf5jjDqN8gparJ6W-EbGtygUKQlbc_bPn1ZvZz2-a9UnfY3i6HUYk8M5p92uf29pE7ffNwTUg4XmGrR8y3dhz7EKssD6qp-dejCg2Rs",
				ReceiptDataBase64: to64(`{"orderId":"GPA.3376-6117-5921-78573","packageName":"com.pylons.loud","productId":"pylons_1000","purchaseTime":1596428485456,"purchaseState":0,"purchaseToken":"agpgcdbplfjjpkbgadnfkmec.AO-J1OxqC40C2YfQkf5jjDqN8gparJ6W-EbGtygUKQlbc_bPn1ZvZz2-a9UnfY3i6HUYk8M5p92uf29pE7ffNwTUg4XmGrR8y3dhz7EKssD6qp-dejCg2Rs","acknowledged":false}`),
				Signature:         "m1futpaJjRE/LwFQvvJmSN0uZrkzLRRUvkecuWLHKb3O+CDBkiQIg4PyIckzgjRcWkLEqKBrmlH8CoJ6T/+kEa0AJPbaxpOMyv3P6NAAkD9WOZYoh+cSOUCuhf9gDqucIfTKtU0f3fTNcFwqEovDXa06XocXPiq3T6yuewyzfCxPDAYGNyO9bj6phxYkwvVqeua6nYpFynFIe6UgyECBu9dydm3deDRublKolfF/GIGRJLvTSLkUN5O+ugMvz08Lun4RUrPUg5+RoV7Uq91JgYTrxCQu3fUMeGa3B8paIc+qO6m6Ezz/gkdUkPFmeUJGADrLBBJVw283+8ZySoP6sQ==",
			},
			balance: sdk.NewCoins(sdk.NewCoin(types.PylonsCoinDenom, sdk.NewInt(1000))),
		},
		{
			// re-using IAP from Valid1
			desc: "ReuseIAP",
			request: &types.MsgGoogleInAppPurchaseGetCoins{
				Creator:           types.GenTestBech32FromString("sender1"),
				ProductID:         "pylons_1000",
				PurchaseToken:     "hafokgmjfkcpdnbffanijckj.AO-J1OxXkrKdM8q14T49Qo5a723VG_8h_4MCY_M2Tqn91L0e7FjiVXsZ2Qxc1SnvoFzHN9jBCJpjZqD4ErYIquMG6Li_jUfcuKuXti_wsa7r48eWNA1Oh0o",
				ReceiptDataBase64: to64(`{"productId":"pylons_1000","purchaseToken":"hafokgmjfkcpdnbffanijckj.AO-J1OxXkrKdM8q14T49Qo5a723VG_8h_4MCY_M2Tqn91L0e7FjiVXsZ2Qxc1SnvoFzHN9jBCJpjZqD4ErYIquMG6Li_jUfcuKuXti_wsa7r48eWNA1Oh0o","purchaseTime":1595031050407,"developerPayload":null}`),
				Signature:         "HEo0RYQeH0+8nmYa6ETKP9f3S/W/cUuQTBme7VSh3Lzm+1+1GwJIl1pdF1dh32YGhd3BtyMoLVGzr9ZajfHhhznIvbowS/XIlyJJCE6dI+zg68mKo5rDt0wB2BY8azk0+WCkc5XT5y8biRNXe5RyvmuqYKPXmEsgHaYKo6x3mHs6oXrECckKv/c9T9MHCvdAqVFrml9W7K41sRHbpOdFmYnO33bkNITCCaf/C1PDGMVOItxvq7uXi+F0DpjXwXko9AU6L3pK6zDICcD38HblbzumOg6LGsuWCjOw8QwNobYOUNtrdj01fEXqkKhfYzFZcwxM6xsphN38gnO0ksDdyw==",
			},
			err: sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "the Google IAP order ID is already being used"),
		},
	} {
		tc := tc
		suite.Run(tc.desc, func() {
			_, err := srv.GoogleInAppPurchaseGetCoins(wctx, tc.request)
			if tc.err != nil {
				require.ErrorIs(err, tc.err)
			} else {
				addr, _ := sdk.AccAddressFromBech32(tc.request.Creator)
				balance := bk.SpendableCoins(ctx, addr)
				require.True(balance.IsEqual(tc.balance))
			}
		})
	}
}

func to64(data string) string {
	return 	base64.StdEncoding.EncodeToString([]byte(data))
}

