package types

import (
	"fmt"
	"testing"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"
)

func Test_validateUint(t *testing.T) {
	type args struct {
		i interface{}
	}

	tests := []struct {
		name    string
		args    args
		wantErr bool
	}{
		{"invalid type sdk coins", args{sdk.NewCoin("fail", sdk.OneInt())}, true},
		{"invalid type int64 -1", args{-1}, true},
		{"invalid type int32 1", args{int32(1)}, true},
		{"invalid type int64 1", args{int64(1)}, true},
		{"invalid type uint32 1", args{uint32(1)}, true},
		{"valid type uint64 1", args{uint64(1)}, false},
	}

	for _, tt := range tests {
		tt := tt
		t.Run(tt.name, func(t *testing.T) {
			require.Equal(t, tt.wantErr, validateUint(tt.args.i) != nil)
		})
	}
}

func Test_validateCoinFee(t *testing.T) {
	type args struct {
		i interface{}
	}

	tests := []struct {
		name    string
		args    args
		wantErr bool
	}{
		{name: "invalid type sdk coins negative", args: args{sdk.Coin{Denom: "fail", Amount: sdk.NewInt(-1)}}, wantErr: true},

		{name: "valid sdk coins", args: args{sdk.Coin{Denom: "pass", Amount: sdk.OneInt()}}, wantErr: false},
	}

	for _, tt := range tests {
		tt := tt
		t.Run(tt.name, func(t *testing.T) {
			fmt.Println(validateCoinFee(tt.args.i))
			require.Equal(t, tt.wantErr, validateCoinFee(tt.args.i) != nil)
		})
	}
}

// validateCoinIssuers
func Test_validateCoinIssuers(t *testing.T) {
	type args struct {
		i interface{}
	}

	invalidPackages := make([]GoogleInAppPurchasePackage, 0)
	invalidPackage := GoogleInAppPurchasePackage{
		PackageName: "",
		ProductID:   "",
		Amount:      sdk.Int{},
	}

	invalidPackages = append(invalidPackages, invalidPackage)

	validPackages := make([]GoogleInAppPurchasePackage, 0)
	validPackage := GoogleInAppPurchasePackage{
		PackageName: "package",
		ProductID:   "product",
		Amount:      sdk.OneInt(),
	}

	validPackages = append(validPackages, validPackage)

	invalidCoinIssuerPackages := make([]CoinIssuer, 1)
	invalidCoinIssuerCoinDenom := make([]CoinIssuer, 1)
	noCoinIssuerPubkey := make([]CoinIssuer, 1)
	validCoinIssuer := make([]CoinIssuer, 1)

	invalidCoinIssuerPackages[0] = CoinIssuer{
		CoinDenom:                 "pylons",
		Packages:                  invalidPackages,
		GoogleInAppPurchasePubKey: "asdg",
		EntityName:                "test",
	}

	invalidCoinIssuerCoinDenom[0] = CoinIssuer{
		CoinDenom:                 "",
		Packages:                  validPackages,
		GoogleInAppPurchasePubKey: "asdf",
		EntityName:                "test",
	}

	noCoinIssuerPubkey[0] = CoinIssuer{
		CoinDenom:                 "pylons",
		Packages:                  validPackages,
		GoogleInAppPurchasePubKey: "",
		EntityName:                "test",
	}

	validCoinIssuer[0] = CoinIssuer{
		CoinDenom:                 "pylons",
		Packages:                  validPackages,
		GoogleInAppPurchasePubKey: "asdf",
		EntityName:                "test",
	}

	tests := []struct {
		name    string
		args    args
		wantErr bool
	}{
		{
			name:    "invalid packages",
			args:    args{invalidCoinIssuerPackages},
			wantErr: true,
		},
		{
			name:    "invalid CoinDenom",
			args:    args{invalidCoinIssuerCoinDenom},
			wantErr: true,
		},
		{
			name:    "invalid PubKey",
			args:    args{noCoinIssuerPubkey},
			wantErr: false,
		},
		{
			name:    "valid",
			args:    args{validCoinIssuer},
			wantErr: false,
		},
	}

	for _, tt := range tests {
		tt := tt
		t.Run(tt.name, func(t *testing.T) {
			fmt.Println(validateCoinIssuers(tt.args.i))
			require.Equal(t, tt.wantErr, validateCoinIssuers(tt.args.i) != nil)
		})
	}
}

// validateInt
// validateDecPercentage

func Test_validateParams(t *testing.T) {
	params := DefaultParams()

	// default params must have no error
	require.NoError(t, params.ValidateBasic())
}
