package types

import (
	"testing"

	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"

	sdk "github.com/cosmos/cosmos-sdk/types"

	ibctypes "github.com/cosmos/ibc-go/modules/apps/transfer/types"

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
