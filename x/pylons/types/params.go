package types

import (
	"fmt"
	sdk "github.com/cosmos/cosmos-sdk/types"
	paramtypes "github.com/cosmos/cosmos-sdk/x/params/types"
	"gopkg.in/yaml.v2"
)

const (
	// PylonsCoinDenom is the pylons denom string
	PylonsCoinDenom = "pylon"

	// DefaultBaseFee holds the value of the default base fee
	DefaultBaseFee = 10000

	// DefaultMinNameFieldLength is the default minimum character length of a request's name field
	DefaultMinNameFieldLength = 8
	// DefaultMinDescriptionFieldLength is the default minimum character length of a request's description field
	DefaultMinDescriptionFieldLength = 20
)

// Parameter Keys
var (
	ParamStoreKeyMinNameFieldLength = []byte("minnamefieldlength")
	ParamStoreKeyMinDescriptionFieldLength = []byte("mindescriptionfieldlength")
	ParamStoreKeyBaseFee = []byte("basefee")
)

type Params struct {
	MinNameFieldLength uint64
	MinDescriptionFieldLength uint64
	BaseFee sdk.Coins
}

// DefaultParams returns default pylons parameters
func DefaultParams() Params {
	return Params {
		MinNameFieldLength: DefaultMinNameFieldLength,
		MinDescriptionFieldLength: DefaultMinDescriptionFieldLength,
		BaseFee: 	sdk.Coins{sdk.NewInt64Coin(PylonsCoinDenom, DefaultBaseFee)},
	}
}

// ParamKeyTable returns the parameter by key
func ParamKeyTable() paramtypes.KeyTable {
	return paramtypes.NewKeyTable().RegisterParamSet(&Params{})
}

// String returns a human-readable string representation of the parameters.
func (p Params) String() string {
	out, _ := yaml.Marshal(p)
	return string(out)
}

// ParamSetPairs returns the parameter set pairs.
func (p *Params) ParamSetPairs() paramtypes.ParamSetPairs {
	return paramtypes.ParamSetPairs{
		paramtypes.NewParamSetPair(ParamStoreKeyMinNameFieldLength, &p.MinNameFieldLength, validateUint),
		paramtypes.NewParamSetPair(ParamStoreKeyMinDescriptionFieldLength, &p.MinDescriptionFieldLength, validateUint),
		paramtypes.NewParamSetPair(ParamStoreKeyBaseFee, &p.BaseFee, validateBaseFee),

	}
}

// ValidateBasic performs basic validation on distribution parameters.
func (p Params) ValidateBasic() error {
	// TODO validate new params
	// these may be unnecessary
	// if gov decides that we should make Description 0, maybe thats ok
	if p.MinNameFieldLength == 0 {
		return fmt.Errorf("MinNameFieldLength must at least be 1")
	}

	if p.MinDescriptionFieldLength == 0 {
		return fmt.Errorf("MinDescriptionFieldLength must at least be 1")
	}

	if p.BaseFee.Empty() || p.BaseFee.IsAnyNegative() {
		return fmt.Errorf("base fee is invalid")
	}

	return nil
}

func defaultValidateFunction(i interface{}) error {
	return nil
}

func validateUint(i interface {}) error {
	v, ok := i.(uint64)
	if !ok {
		return fmt.Errorf("invalid parameter type: %T", i)
	}

	if v <= 0 {
		return fmt.Errorf("min length parameter must be greater than 0")
	}

	return nil
}

func validateBaseFee(i interface {}) error {
	v, ok := i.(sdk.Coins)
	if !ok {
		return fmt.Errorf("invalid parameter type: %T", i)
	}

	for _, coin := range v {
		if coin.IsValid() {
			return fmt.Errorf("fee must be valid (valid denom and non-negative)")
		}

		if coin.IsZero() {
			return fmt.Errorf("fee must be non-zero")
		}
	}

	return nil
}

