package types

import (
	"encoding/json"
	fmt "fmt"
	"testing"

	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"

	sdk "github.com/cosmos/cosmos-sdk/types"

	ibctypes "github.com/cosmos/ibc-go/v2/modules/apps/transfer/types"

	"github.com/stretchr/testify/require"
)

func TestCookbookDenom(t *testing.T) {
	valid1, _ := CookbookDenom("test", "pylons")
	valid2, _ := CookbookDenom("a12341234", "pylons")
	invalid1 := "1234/567"
	invalid2 := "pylons"
	invalid3, _ := CookbookDenom("12341234", "pylons")

	for _, tc := range []struct {
		desc  string
		denom string
		is    bool
	}{
		{desc: "valid1", denom: valid1, is: true},
		{desc: "valid2", denom: valid2, is: true},
		{desc: "invalid1", denom: invalid1, is: false},
		{desc: "invalid2", denom: invalid2, is: false},
		{desc: "invalid3", denom: invalid3, is: false},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			require.Equal(t, tc.is, IsCookbookDenom(tc.denom))
		})
	}
}

func TestIBCDenom(t *testing.T) {
	valid1Trace := ibctypes.ParseDenomTrace("portidone/channelidone/uatom")
	valid1 := valid1Trace.IBCDenom()
	valid2 := "ibc/529ba5e3e86ba7796d7caab4fc02728935fbc75c0f7b25a9e611c49dd7d68a35"

	invalid1 := "pylons"

	for _, tc := range []struct {
		desc  string
		denom string
		is    bool
	}{
		{desc: "valid1", denom: valid1, is: true},
		{desc: "valid2", denom: valid2, is: true},
		{desc: "invalid1", denom: invalid1, is: false},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			require.Equal(t, tc.is, IsIBCDenomRepresentation(tc.denom))
		})
	}
}

func TestCreateValidCoinOutputsList(t *testing.T) {
	validCookbookID := "cookbookID"
	invalidCookbookID := "invalid"

	valid := []CoinOutput{
		{
			ID:      "test1",
			Coin:    sdk.Coin{Denom: validCookbookID + denomDivider + "denom1", Amount: sdk.OneInt()},
			Program: "",
		},
		{
			ID:      "test1",
			Coin:    sdk.Coin{Denom: validCookbookID + denomDivider + "denom2", Amount: sdk.OneInt()},
			Program: "",
		},
	}

	invalid := []CoinOutput{
		{
			ID:      "test1",
			Coin:    sdk.Coin{Denom: validCookbookID + denomDivider + "denom1", Amount: sdk.OneInt()},
			Program: "",
		},
		{
			ID:      "test1",
			Coin:    sdk.Coin{Denom: invalidCookbookID + denomDivider + "denom2", Amount: sdk.OneInt()},
			Program: "",
		},
	}

	for _, tc := range []struct {
		desc        string
		cookbookID  string
		coinOutputs []CoinOutput
		err         error
	}{
		{desc: "valid1", cookbookID: validCookbookID, coinOutputs: valid, err: nil},
		{desc: "invalid1", cookbookID: invalidCookbookID, coinOutputs: valid, err: sdkerrors.ErrInvalidRequest},
		{desc: "invalid2", cookbookID: validCookbookID, coinOutputs: invalid, err: sdkerrors.ErrInvalidRequest},
		{desc: "invalid3", cookbookID: invalidCookbookID, coinOutputs: invalid, err: sdkerrors.ErrInvalidRequest},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			_, err := CreateValidCoinOutputsList(tc.cookbookID, tc.coinOutputs)
			require.ErrorIs(t, err, tc.err)
		})
	}
}

func TestParseCoinInputStringArray(t *testing.T) {
	for _, tc := range []struct {
		desc       string
		coinsStr   []string
		coinInputs []CoinInput
		err        error
	}{
		{
			desc:     "valid1",
			coinsStr: []string{"10uatom,10upylon"},
			coinInputs: []CoinInput{{
				Coins: sdk.NewCoins(
					sdk.NewCoin("uatom", sdk.NewInt(10)),
					sdk.NewCoin("upylon", sdk.NewInt(10)),
				),
			}},
			err: nil,
		},
		{
			desc:     "valid2",
			coinsStr: []string{"10uatom,10upylon", "1000upylon,10000000uatom"},
			coinInputs: []CoinInput{{
				Coins: sdk.NewCoins(
					sdk.NewCoin("uatom", sdk.NewInt(10)),
					sdk.NewCoin("upylon", sdk.NewInt(10)),
				),
			},
				{
					Coins: sdk.NewCoins(
						sdk.NewCoin("upylon", sdk.NewInt(1000)),
						sdk.NewCoin("uatom", sdk.NewInt(10000000)),
					),
				}},
			err: nil,
		},
		{
			desc:     "invalidDuplicate1",
			coinsStr: []string{"10uatom,10uatom"},
			coinInputs: []CoinInput{{
				Coins: sdk.NewCoins(
					sdk.NewCoin("uatom", sdk.NewInt(20)),
				),
			}},
			err: fmt.Errorf("duplicate denomination %s", "uatom"),
		},
		{
			desc:       "invalidStr1",
			coinsStr:   []string{"test", "1000upylon,10000000uatom"},
			coinInputs: []CoinInput{{}},
			err:        fmt.Errorf("invalid decimal coin expression: %s", "test"),
		},
		{
			desc:       "invalidStr2",
			coinsStr:   []string{"1000upylon,10000000uatom", "test"},
			coinInputs: []CoinInput{{}},
			err:        fmt.Errorf("invalid decimal coin expression: %s", "test"),
		},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			parsed, err := ParseCoinInputStringArray(tc.coinsStr)
			if err != nil {
				require.Contains(t, err.Error(), tc.err.Error())
			} else {
				require.Equal(t, tc.coinInputs, parsed)
			}
		})
	}
}

func TestParseCoinInputsCLI(t *testing.T) {
	coinInputs1, err := json.Marshal([]CoinInput{
		{Coins: sdk.NewCoins(
			sdk.NewCoin("uatom", sdk.NewInt(10)),
			sdk.NewCoin("upylon", sdk.NewInt(10)),
		)},
	})
	require.NoError(t, err)

	coinInputs2, err := json.Marshal([]CoinInput{{
		Coins: sdk.NewCoins(
			sdk.NewCoin("uatom", sdk.NewInt(10)),
			sdk.NewCoin("upylon", sdk.NewInt(10)),
		),
	},
		{
			Coins: sdk.NewCoins(
				sdk.NewCoin("uatom", sdk.NewInt(1000)),
			),
		},
	})
	require.NoError(t, err)

	for _, tc := range []struct {
		desc       string
		arg        string
		coinInputs []CoinInput
		err        error
	}{
		{
			desc: "valid1String",
			arg:  "[\"10uatom,10upylon\"]",
			coinInputs: []CoinInput{{
				Coins: sdk.NewCoins(
					sdk.NewCoin("uatom", sdk.NewInt(10)),
					sdk.NewCoin("upylon", sdk.NewInt(10)),
				),
			}},
			err: nil,
		},
		{
			desc: "validString2",
			arg:  "[\"10uatom,10upylon\",\"1000uatom\"]",
			coinInputs: []CoinInput{{
				Coins: sdk.NewCoins(
					sdk.NewCoin("uatom", sdk.NewInt(10)),
					sdk.NewCoin("upylon", sdk.NewInt(10)),
				),
			},
				{
					Coins: sdk.NewCoins(
						sdk.NewCoin("uatom", sdk.NewInt(1000)),
					),
				},
			},
			err: nil,
		},
		{
			desc: "validJSON1",
			arg:  string(coinInputs1),
			coinInputs: []CoinInput{{
				Coins: sdk.NewCoins(
					sdk.NewCoin("uatom", sdk.NewInt(10)),
					sdk.NewCoin("upylon", sdk.NewInt(10)),
				),
			}},
			err: nil,
		},
		{
			desc: "validJSON2",
			arg:  string(coinInputs2),
			coinInputs: []CoinInput{{
				Coins: sdk.NewCoins(
					sdk.NewCoin("uatom", sdk.NewInt(10)),
					sdk.NewCoin("upylon", sdk.NewInt(10)),
				),
			},
				{
					Coins: sdk.NewCoins(
						sdk.NewCoin("uatom", sdk.NewInt(1000)),
					),
				},
			},
			err: nil,
		},
		{
			desc:       "invalid1",
			arg:        "[\"10uatom,joij\"]",
			coinInputs: []CoinInput{},
			err:        fmt.Errorf("invalid decimal coin expression: %s", "joij"),
		},
		{
			desc:       "invalid2",
			arg:        "[\"10uatom,10uatom\"]",
			coinInputs: []CoinInput{},
			err:        fmt.Errorf("duplicate denomination %s", "uatom"),
		},
		{
			desc:       "invalid3",
			arg:        "[\"10uatom,10upylon\",\"test\"]",
			coinInputs: []CoinInput{},
			err:        fmt.Errorf("invalid decimal coin expression: %s", "test"),
		},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			parsed, err := ParseCoinInputsCLI(tc.arg)
			fmt.Println(parsed)
			if err != nil {
				require.Contains(t, err.Error(), tc.err.Error())
			} else {
				require.Equal(t, tc.coinInputs, parsed)
			}
		})
	}
}

func TestParseCoinOutputCLI(t *testing.T) {
	coinOutput1, err := json.Marshal(sdk.NewCoins(
		sdk.NewCoin("uatom", sdk.NewInt(10)),
		sdk.NewCoin("upylon", sdk.NewInt(10)),
	),
	)
	require.NoError(t, err)

	coinOutput2, err := json.Marshal(sdk.NewCoins(
		sdk.NewCoin("uatom", sdk.NewInt(10)),
		sdk.NewCoin("upylon", sdk.NewInt(10)),
		sdk.NewCoin("ustripeusd", sdk.NewInt(10)),
	),
	)
	require.NoError(t, err)

	for _, tc := range []struct {
		desc       string
		arg        string
		coinOutput sdk.Coins
		err        error
	}{
		{
			desc: "valid1String",
			arg:  "10uatom,10upylon",
			coinOutput: sdk.NewCoins(
				sdk.NewCoin("uatom", sdk.NewInt(10)),
				sdk.NewCoin("upylon", sdk.NewInt(10)),
			),
			err: nil,
		},
		{
			desc: "validString2",
			arg:  "10uatom,10upylon,10ustripeusd",
			coinOutput: sdk.NewCoins(
				sdk.NewCoin("uatom", sdk.NewInt(10)),
				sdk.NewCoin("upylon", sdk.NewInt(10)),
				sdk.NewCoin("ustripeusd", sdk.NewInt(10)),
			),

			err: nil,
		},
		{
			desc: "validJSON1",
			arg:  string(coinOutput1),
			coinOutput: sdk.NewCoins(
				sdk.NewCoin("uatom", sdk.NewInt(10)),
				sdk.NewCoin("upylon", sdk.NewInt(10)),
			),
			err: nil,
		},
		{
			desc: "validJSON2",
			arg:  string(coinOutput2),
			coinOutput: sdk.NewCoins(
				sdk.NewCoin("uatom", sdk.NewInt(10)),
				sdk.NewCoin("upylon", sdk.NewInt(10)),
				sdk.NewCoin("ustripeusd", sdk.NewInt(10)),
			),
			err: nil,
		},
		{
			desc:       "invalid1",
			arg:        "10uatom,joij",
			coinOutput: sdk.Coins{},
			err:        fmt.Errorf("invalid decimal coin expression: %s", "joij"),
		},
		{
			desc:       "invalid2",
			arg:        "10uatom,10uatom",
			coinOutput: sdk.Coins{},
			err:        fmt.Errorf("duplicate denomination %s", "uatom"),
		},
		{
			desc:       "invalid3",
			arg:        "10uatom,10upylon,stripeusd",
			coinOutput: sdk.Coins{},
			err:        fmt.Errorf("invalid decimal coin expression: %s", "stripeusd"),
		},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			parsed, err := ParseCoinOutputCLI(tc.arg)
			fmt.Println(parsed)
			if err != nil {
				require.Contains(t, err.Error(), tc.err.Error())
			} else {
				require.Equal(t, tc.coinOutput, parsed)
			}
		})
	}
}

func TestParseCoinCLI(t *testing.T) {
	coin1, err := json.Marshal(
		sdk.NewCoin("uatom", sdk.NewInt(10)),
	)
	require.NoError(t, err)

	coin2, err := json.Marshal(
		sdk.NewCoin("upylon", sdk.NewInt(10)),
	)

	require.NoError(t, err)

	for _, tc := range []struct {
		desc string
		arg  string
		coin sdk.Coin
		err  error
	}{
		{
			desc: "valid1String",
			arg:  "10uatom",
			coin: sdk.NewCoin("uatom", sdk.NewInt(10)),
			err:  nil,
		},
		{
			desc: "validString2",
			arg:  "10upylon",
			coin: sdk.NewCoin("upylon", sdk.NewInt(10)),

			err: nil,
		},
		{
			desc: "validJSON1",
			arg:  string(coin1),
			coin: sdk.NewCoin("uatom", sdk.NewInt(10)),
			err:  nil,
		},
		{
			desc: "validJSON2",
			arg:  string(coin2),
			coin: sdk.NewCoin("upylon", sdk.NewInt(10)),

			err: nil,
		},
		{
			desc: "invalid1",
			arg:  "joij",
			coin: sdk.Coin{},
			err:  fmt.Errorf("invalid decimal coin expression: %s", "joij"),
		},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			parsed, err := ParseCoinCLI(tc.arg)
			fmt.Println(parsed)
			if err != nil {
				require.Contains(t, err.Error(), tc.err.Error())
			} else {
				require.Equal(t, tc.coin, parsed)
			}
		})
	}
}
