package keeper_test

import (
	"encoding/base64"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"

	"github.com/Pylons-tech/pylons/x/pylons/keeper"
	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (suite *IntegrationTestSuite) TestMsgServerGoogleInAppPurchaseGetCoins() {
	k := suite.k
	bk := suite.bankKeeper
	ctx := suite.ctx
	require := suite.Require()

	srv := keeper.NewMsgServerImpl(k)
	wctx := sdk.WrapSDKContext(ctx)

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
				ProductId:         "pylons_1000",
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
				ProductId:         "pylons_55000",
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
				ProductId:         "pylons_20",
				PurchaseToken:     "ppbcdoahebkbcfaolknndoki.AO-J1Oym5aVmouDNSBd4MoC1oGid3SGuJZ78ABjzOMZunxZSAhcDgsBq93ZVTFz3obw62mtXw0OROkW3ixnA73TBKSV5oUb5Zg",
				ReceiptDataBase64: to64(`{"orderId":"GPA.3325-1538-6613-37513","packageName":"tech.pylons.wallet","productId":"pylons_20","purchaseTime":1655204433288,"purchaseState":0,"purchaseToken":"ppbcdoahebkbcfaolknndoki.AO-J1Oym5aVmouDNSBd4MoC1oGid3SGuJZ78ABjzOMZunxZSAhcDgsBq93ZVTFz3obw62mtXw0OROkW3ixnA73TBKSV5oUb5Zg","acknowledged":false}`),
				Signature:         "HZkPblIOy+pHCZuFBylA3mHdS8TgZuqotErySLtoJ64GN96lLxX28icCEobZ+BX5/3ubGWptFaV/NBfQljLqfovh26O2dSyWbHA7+dWb5/Lu7/w0x0E1R91ts1rmQKiGtAZ+dBASlewv6g5jFvm5JOewl/j3fZboisEddY1AVJR/EQKzi00QfDpFbI6SLi1O5k+qgssX9TtUIxqImXSORpfnjcE7BQjI99+jBy8NySXenZrqQ2pCSe1I0avu5DqZAXrS9KcWFOO1BCkEw9g4V5zTEONZ0QIoKFP2ttCaaNKttvXf9rxxzMNuKW+SvIjoW7lJ/FIaIRqXdkiDql2N0w==",
			},
			balance: sdk.NewCoins(sdk.NewCoin(types.PylonsCoinDenom, sdk.NewInt(20))),
		},
		{
			desc: "Valid2",
			request: &types.MsgGoogleInAppPurchaseGetCoins{
				Creator:           types.GenTestBech32FromString("sender2"),
				ProductId:         "pylons_5",
				PurchaseToken:     "kecoklhikhaepfedhadhiebp.AO-J1Ox-sOzcaUmNMBWuXE7pQklGCJblzObbV7kuPyPFegQeILaXuhf-NuV0H2DZEWIAvETdX3OEgFEXsIlNsx-uZBDaLJF8oA",
				ReceiptDataBase64: to64(`{"orderId":"GPA.3308-1418-1838-26432","packageName":"tech.pylons.wallet","productId":"pylons_5","purchaseTime":1655206339882,"purchaseState":0,"purchaseToken":"kecoklhikhaepfedhadhiebp.AO-J1Ox-sOzcaUmNMBWuXE7pQklGCJblzObbV7kuPyPFegQeILaXuhf-NuV0H2DZEWIAvETdX3OEgFEXsIlNsx-uZBDaLJF8oA","acknowledged":false}`),
				Signature:         "C4qPmpyiGhmJZraiftEEqYT+sfQ5XRkG3DaGAR24A/mtZyKi2Ix0qR7RVYJVjpMkn2zZcZWNs23e52G8viAXQHhlleEDSCgNgIf23AwuM+4Lu2lzJCrftYxVLAksviUMtPaj/XGOx1UcLOwtK4XDBDlkgYOeCT9vZGZ88suguINR/OpNe5/j2Pzkx5wAuKUjirXonOZpvu+XrXnf42Eb7IepgbiBWa1PPJttJBDKSxbYC56D6+InRmT1Vyhpp8tWsM4r4riAB9goHR2EtD9WjEQxP9bMyp/e64C5i2d9lMrHArmOPIZoIaBgPN6CJ/KoNqVJe3SyBaW3xqMO3eouww==",
			},
			balance: sdk.NewCoins(sdk.NewCoin(types.PylonsCoinDenom, sdk.NewInt(5))),
		},
		{
			// re-using IAP from Valid1
			desc: "ReuseIAP",
			request: &types.MsgGoogleInAppPurchaseGetCoins{
				Creator:           types.GenTestBech32FromString("sender1"),
				ProductId:         "pylons_5",
				PurchaseToken:     "kecoklhikhaepfedhadhiebp.AO-J1Ox-sOzcaUmNMBWuXE7pQklGCJblzObbV7kuPyPFegQeILaXuhf-NuV0H2DZEWIAvETdX3OEgFEXsIlNsx-uZBDaLJF8oA",
				ReceiptDataBase64: to64(`{"orderId":"GPA.3308-1418-1838-26432","packageName":"tech.pylons.wallet","productId":"pylons_5","purchaseTime":1655206339882,"purchaseState":0,"purchaseToken":"kecoklhikhaepfedhadhiebp.AO-J1Ox-sOzcaUmNMBWuXE7pQklGCJblzObbV7kuPyPFegQeILaXuhf-NuV0H2DZEWIAvETdX3OEgFEXsIlNsx-uZBDaLJF8oA","acknowledged":false}`),
				Signature:         "C4qPmpyiGhmJZraiftEEqYT+sfQ5XRkG3DaGAR24A/mtZyKi2Ix0qR7RVYJVjpMkn2zZcZWNs23e52G8viAXQHhlleEDSCgNgIf23AwuM+4Lu2lzJCrftYxVLAksviUMtPaj/XGOx1UcLOwtK4XDBDlkgYOeCT9vZGZ88suguINR/OpNe5/j2Pzkx5wAuKUjirXonOZpvu+XrXnf42Eb7IepgbiBWa1PPJttJBDKSxbYC56D6+InRmT1Vyhpp8tWsM4r4riAB9goHR2EtD9WjEQxP9bMyp/e64C5i2d9lMrHArmOPIZoIaBgPN6CJ/KoNqVJe3SyBaW3xqMO3eouww==",
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
	return base64.StdEncoding.EncodeToString([]byte(data))
}
