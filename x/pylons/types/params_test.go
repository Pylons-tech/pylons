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

func Test_validateBaseFee(t *testing.T) {
	type args struct {
		i interface{}
	}

	tests := []struct {
		name    string
		args    args
		wantErr bool
	}{
		{"invalid type sdk coins zero", args{sdk.Coins{sdk.Coin{Denom: "fail", Amount: sdk.NewInt(0)}}}, true},
		{"invalid type sdk coins negative", args{sdk.Coins{sdk.Coin{Denom: "fail", Amount: sdk.NewInt(-1)}}}, true},

		{"valid sdk coins", args{sdk.NewCoins(sdk.NewCoin("pass", sdk.NewInt(1)))}, false},
	}

	for _, tt := range tests {
		tt := tt
		t.Run(tt.name, func(t *testing.T) {
			fmt.Println(validateBaseFee(tt.args.i))
			require.Equal(t, tt.wantErr, validateBaseFee(tt.args.i) != nil)
		})
	}
}

func Test_validateParams(t *testing.T) {
	params := DefaultParams()

	// default params must have no error
	require.NoError(t, params.ValidateBasic())
}
