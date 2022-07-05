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
				ProductId:         "pylons_10",
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
				ProductId:         "pylons_10",
				PurchaseToken:     "hafokgmjfkcpdnbffanijckj.AO-J1OxXkrKdM8q14T49Qo5a723VG_8h_4MCY_M2Tqn91L0e7FjiVXsZ2Qxc1SnvoFzHN9jBCJpjZqD4ErYIquMG6Li_jUfcuKuXti_wsa7r48eWNA1Oh0o",
				ReceiptDataBase64: to64(`{"productId":"pylons_55000","purchaseToken":"hafokgmjfkcpdnbffanijckj.AO-J1OxXkrKdM8q14T49Qo5a723VG_8h_4MCY_M2Tqn91L0e7FjiVXsZ2Qxc1SnvoFzHN9jBCJpjZqD4ErYIquMG6Li_jUfcuKuXti_wsa7r48eWNA1Oh0o","purchaseTime":1595031050407,"developerPayload":null}`),
				Signature:         "HEo0RYQeH0+8nmYa6ETKP9f3S/W/cUuQTBme7VSh3Lzm+1+1GwJIl1pdF1dh32YGhd3BtyMoLVGzr9ZajfHhhznIvbowS/XIlyJJCE6dI+zg68mKo5rDt0wB2BY8azk0+WCkc5XT5y8biRNXe5RyvmuqYKPXmEsgHaYKo6x3mHs6oXrECckKv/c9T9MHCvdAqVFrml9W7K41sRHbpOdFmYnO33bkNITCCaf/C1PDGMVOItxvq7uXi+F0DpjXwXko9AU6L3pK6zDICcD38HblbzumOg6LGsuWCjOw8QwNobYOUNtrdj01fEXqkKhfYzFZcwxM6xsphN38gnO0ksDdyw==",
			},
			err: sdkerrors.Wrap(sdkerrors.ErrorInvalidSigner, "Google IAP Signature is invalid"),
		},
		{
			desc: "Valid1",
			request: &types.MsgGoogleInAppPurchaseGetCoins{
				Creator:           types.GenTestBech32FromString("sender2"),
				ProductId:         "pylons_10",
				PurchaseToken:     "hfoocbljoggmdeiekfolbime.AO-J1OwBrsrwLSggvMSVLJR6wl1xaxCQCF0M5oN7viEEev5GERL8a0GN3t8z1ZPpdNrq8tpgzZCM3IgcP5v2kabElNltsbh6GA",
				ReceiptDataBase64: "eyJvcmRlcklkIjoiR1BBLjMzOTYtNjQwNy00NDUyLTYyMDIwIiwicGFja2FnZU5hbWUiOiJ0ZWNoLnB5bG9ucy53YWxsZXQiLCJwcm9kdWN0SWQiOiJweWxvbnNfMTAiLCJwdXJjaGFzZVRpbWUiOjE2NTU5MDEzMTY5NDEsInB1cmNoYXNlU3RhdGUiOjAsInB1cmNoYXNlVG9rZW4iOiJoZm9vY2Jsam9nZ21kZWlla2ZvbGJpbWUuQU8tSjFPd0Jyc3J3TFNnZ3ZNU1ZMSlI2d2wxeGF4Q1FDRjBNNW9ON3ZpRUVldjVHRVJMOGEwR04zdDh6MVpQcGROcnE4dHBnelpDTTNJZ2NQNXYya2FiRWxObHRzYmg2R0EiLCJhY2tub3dsZWRnZWQiOmZhbHNlfQ==",
				Signature:         "LZXvpQwMzGPUnPx06ueOhHDT8INhvxo+YYpqNK17pv1JoU5efoQk7/nHiNvMIHUaX9n0DRF0+Cg/VhZw70zvb4n+18jqRRyKBj/wHt8VSJEco1cHmnwh15OE4FY49YINidBERCBo01xD6qhuMnh7ZB0CwWRBSrDLHKuk4Y9Qybhn72/MtVeMCs+4aK1iWi7iJ9ABfHFbbomFDkOSQvxwAboPcg7VfiZMXS2K67dxWK6YaSQVc21zLtABgigiAqg6mRKiG5d2BdHSXo5qh13f/py2fj6CRf+b9lcVDM0cDGXcsBkPME/OUWQNyqd2tFMlcZn6SwOR7suuzzoB4A8rHg==",
			},
			balance: sdk.NewCoins(sdk.NewCoin(types.PylonsCoinDenom, sdk.NewInt(10000000))),
		},
		{
			desc: "Valid2",
			request: &types.MsgGoogleInAppPurchaseGetCoins{
				Creator:           types.GenTestBech32FromString("sender2"),
				ProductId:         "pylons_35",
				PurchaseToken:     "nfipfpjachbfdolpikhhbiea.AO-J1Ox125dG3250jaXlbdrVzn0CfNtyl1A51d6f7I3oqBHAQw7N3YKUlYhVDc8HEYTaLCzYRpVpB8NjqVZUS3k_6J0At-j-3w",
				ReceiptDataBase64: "eyJvcmRlcklkIjoiR1BBLjMzODYtMjU3MC00NDY4LTQ3MTY0IiwicGFja2FnZU5hbWUiOiJ0ZWNoLnB5bG9ucy53YWxsZXQiLCJwcm9kdWN0SWQiOiJweWxvbnNfMzUiLCJwdXJjaGFzZVRpbWUiOjE2NTU5MDEzNjk3NTUsInB1cmNoYXNlU3RhdGUiOjAsInB1cmNoYXNlVG9rZW4iOiJuZmlwZnBqYWNoYmZkb2xwaWtoaGJpZWEuQU8tSjFPeDEyNWRHMzI1MGphWGxiZHJWem4wQ2ZOdHlsMUE1MWQ2ZjdJM29xQkhBUXc3TjNZS1VsWWhWRGM4SEVZVGFMQ3pZUnBWcEI4TmpxVlpVUzNrXzZKMEF0LWotM3ciLCJhY2tub3dsZWRnZWQiOmZhbHNlfQ==",
				Signature:         "kj8+9dVWtJbCtT92KhrXiXpq6oDfSu+yq+eOGjsiX856vS4ZD0JptbV0aB75NV2vIfbmsMcWafuLip64c78akqPxCwXTCH1eNcJxzHdsUumYt7y7BrdsrDc7PwDTloV9+Qe2ReRVUQISD4a+J7fGiQTVHkAbVvUoRAtShojByJHxqgMIx2/WGqtY+tDwlyqMtc44JlK+zrEn+1n93/v6ZS9X1Nv+I9HYWMhdxMXaJ+POnxH7hz/2LzKWlyoi82L/RBouOVzGpVfqiqyap0hiVxmQPP6K+vNBSiUgreNpMD+2qlslOHDugORgjqHf1eLs4hrBO99iDjYMWX5g+Bz0bQ==",
			},
			balance: sdk.NewCoins(sdk.NewCoin(types.PylonsCoinDenom, sdk.NewInt(45000000))),
		},
		{
			desc: "Valid3",
			request: &types.MsgGoogleInAppPurchaseGetCoins{
				Creator:           types.GenTestBech32FromString("sender2"),
				ProductId:         "pylons_60",
				PurchaseToken:     "mcnpknojkpcigegbomchikin.AO-J1OyFegY1FDeNA9KzlYeEmOIwkXiAXehfVyloqvb8TXf2Wmobr1w8emccAKnjez_9e6NC1i4CKq7KnTlPkkSkldVr8C1c1g",
				ReceiptDataBase64: "eyJvcmRlcklkIjoiR1BBLjMzMTgtMjc2MS0zODk1LTI5NDcwIiwicGFja2FnZU5hbWUiOiJ0ZWNoLnB5bG9ucy53YWxsZXQiLCJwcm9kdWN0SWQiOiJweWxvbnNfNjAiLCJwdXJjaGFzZVRpbWUiOjE2NTU5MDEzODY4MjAsInB1cmNoYXNlU3RhdGUiOjAsInB1cmNoYXNlVG9rZW4iOiJtY25wa25vamtwY2lnZWdib21jaGlraW4uQU8tSjFPeUZlZ1kxRkRlTkE5S3psWWVFbU9Jd2tYaUFYZWhmVnlsb3F2YjhUWGYyV21vYnIxdzhlbWNjQUtuamV6XzllNk5DMWk0Q0txN0tuVGxQa2tTa2xkVnI4QzFjMWciLCJhY2tub3dsZWRnZWQiOmZhbHNlfQ==",
				Signature:         "FREfEWfRXaNzRCgD6MLAaKpc1kZ2FbNVfeXLazKoxpY4tHFo1VsmEqCPdsYymCZys0yehWczPaQJMkB5YwGgwPSKGtWKgwP68gG6SsO21f5SKqcLjvuWyShspifDNjJ7vNy+XPwfjd6PWwYQWVNogr2dC8dN433X+1guY+FExeT0UwbgY8SedsaxRT2nOH2ONLDVx/rR0+kNie13bg/AUZzRkFKYKtUuUQtXq3F1CyDGg/ARgut0EFNJVaW6nrK9as2/7l6V3/+16iDP3dknk7sL9y+VpgfwFrGwQKX23DR33qepjhh7uY67DjxST7Ci4AoALkYdRJ7/TRyDXKe8xw==",
			},
			balance: sdk.NewCoins(sdk.NewCoin(types.PylonsCoinDenom, sdk.NewInt(105000000))),
		},
		{
			// re-using IAP from Valid1
			desc: "ReuseIAP",
			request: &types.MsgGoogleInAppPurchaseGetCoins{
				Creator:           types.GenTestBech32FromString("sender2"),
				ProductId:         "pylons_1",
				PurchaseToken:     "mcnpknojkpcigegbomchikin.AO-J1OyFegY1FDeNA9KzlYeEmOIwkXiAXehfVyloqvb8TXf2Wmobr1w8emccAKnjez_9e6NC1i4CKq7KnTlPkkSkldVr8C1c1g",
				ReceiptDataBase64: "eyJvcmRlcklkIjoiR1BBLjMzMTgtMjc2MS0zODk1LTI5NDcwIiwicGFja2FnZU5hbWUiOiJ0ZWNoLnB5bG9ucy53YWxsZXQiLCJwcm9kdWN0SWQiOiJweWxvbnNfNjAiLCJwdXJjaGFzZVRpbWUiOjE2NTU5MDEzODY4MjAsInB1cmNoYXNlU3RhdGUiOjAsInB1cmNoYXNlVG9rZW4iOiJtY25wa25vamtwY2lnZWdib21jaGlraW4uQU8tSjFPeUZlZ1kxRkRlTkE5S3psWWVFbU9Jd2tYaUFYZWhmVnlsb3F2YjhUWGYyV21vYnIxdzhlbWNjQUtuamV6XzllNk5DMWk0Q0txN0tuVGxQa2tTa2xkVnI4QzFjMWciLCJhY2tub3dsZWRnZWQiOmZhbHNlfQ==",
				Signature:         "FREfEWfRXaNzRCgD6MLAaKpc1kZ2FbNVfeXLazKoxpY4tHFo1VsmEqCPdsYymCZys0yehWczPaQJMkB5YwGgwPSKGtWKgwP68gG6SsO21f5SKqcLjvuWyShspifDNjJ7vNy+XPwfjd6PWwYQWVNogr2dC8dN433X+1guY+FExeT0UwbgY8SedsaxRT2nOH2ONLDVx/rR0+kNie13bg/AUZzRkFKYKtUuUQtXq3F1CyDGg/ARgut0EFNJVaW6nrK9as2/7l6V3/+16iDP3dknk7sL9y+VpgfwFrGwQKX23DR33qepjhh7uY67DjxST7Ci4AoALkYdRJ7/TRyDXKe8xw==",
			},
			err: sdkerrors.Wrap(types.ErrReceiptAlreadyUsed, "the Google IAP order ID is already being used"),
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
