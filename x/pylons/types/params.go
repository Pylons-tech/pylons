package types

import (
	"encoding/base64"
	"fmt"

	"github.com/cosmos/cosmos-sdk/x/bank/types"

	"github.com/cosmos/cosmos-sdk/crypto/keys/ed25519"

	"gopkg.in/yaml.v2"

	sdk "github.com/cosmos/cosmos-sdk/types"
	paramtypes "github.com/cosmos/cosmos-sdk/x/params/types"
)

// Default parameter namespace
const (
	// DefaultMinNameFieldLength is the default minimum character length of a request's name field
	DefaultMinNameFieldLength uint64 = 8
	// DefaultMinDescriptionFieldLength is the default minimum character length of a request's description field
	DefaultMinDescriptionFieldLength uint64 = 20
)

var (
	DefaultCoinIssuers = []CoinIssuer{
		{
			CoinDenom: PylonsCoinDenom,
			Packages: []GoogleInAppPurchasePackage{
				{PackageName: "com.pylons.loud", ProductID: "pylons_1000", Amount: sdk.NewInt(1000)},
				{PackageName: "com.pylons.loud", ProductID: "pylons_55000", Amount: sdk.NewInt(55000)},
			},
			GoogleInAppPurchasePubKey: "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwZsjhk6eN5Pve9pP3uqz2MwBFixvmCRtQJoDQLTEJo3zTd9VMZcXoerQX8cnDPclZWmMZWkO+BWcN1ikYdGHvU2gC7yBLi+TEkhsEkixMlbqOGRdmNptJJhqxuVmXK+drWTb6W0IgQ9g8CuCjZUiMTc0UjHb5mPOE/IhcuTZ0wCHdoqc5FS2spdQqrohvSEP7gR4ZgGzYNI1U+YZHskIEm2qC4ZtSaX9J/fDkAmmJFV2hzeDMcljCxY9+ZM1mdzIpZKwM7O6UdWRpwD1QJ7yXND8AQ9M46p16F0VQuZbbMKCs90NIcKkx6jDDGbVmJrFnUT1Oq1uYxNYtiZjTp+JowIDAQAB",
			EntityName:                "Pylons_Inc",
		},
	}

	DefaultProcessorPercentage  = sdk.MustNewDecFromStr("0.003")
	DefaultValidatorsPercentage = sdk.ZeroDec()
	DefaultPylonsIncPubKey      = "EVK1dqjD6K8hGylacMpWAa/ru/OnWUDtCZ+lPkv2TTA=" // this is a testing key, do not use in production!
	DefaultPaymentProcessors    = []PaymentProcessor{
		{
			CoinDenom:            StripeCoinDenom,
			PubKey:               DefaultPylonsIncPubKey,
			ProcessorPercentage:  DefaultProcessorPercentage,
			ValidatorsPercentage: DefaultValidatorsPercentage,
			Name:                 "Pylons_Inc",
		},
	}
	DefaultPaymentProcessorsTokensBankParams = []types.SendEnabled{
		{Denom: StripeCoinDenom, Enabled: false},
	}

	DefaultRecipeFeePercentage, _       = sdk.NewDecFromStr("0.10")
	DefaultItemTransferFeePercentage, _ = sdk.NewDecFromStr("0.10")
	DefaultUpdateItemStringFee          = sdk.NewCoin(PylonsCoinDenom, sdk.NewInt(10))
	DefaultUpdateUsernameFee            = sdk.NewCoin(PylonsCoinDenom, sdk.NewInt(10))
	DefaultMinTransferFee               = sdk.OneInt()
	DefaultMaxTransferFee               = sdk.NewInt(10000)
	DefaultDistrEpochIdentifier         = "day"
)

// Parameter Store Keys
var (
	ParamStoreKeyMinNameFieldLength        = []byte("MinNameFieldLength")
	ParamStoreKeyMinDescriptionFieldLength = []byte("MinDescriptionFieldLength")
	ParamStoreKeyCoinIssuers               = []byte("CoinIssuers")
	ParamStoreKeyPaymentProcessors         = []byte("PaymentProcessors")
	ParamStoreKeyRecipeFeePercentage       = []byte("RecipeFeePercentage")
	ParamStoreKeyItemTransferFeePercentage = []byte("ItemTransferFeePercentage")
	ParamStoreKeyUpdateItemStringFee       = []byte("UpdateItemStringFee")
	ParamStoreKeyMinTransferFee            = []byte("MinTransferFee")
	ParamStoreKeyMaxTransferFee            = []byte("MaxTransferFee")
	ParamStoreKeyUpdateUsernameFee         = []byte("UpdateUsernameFee")
	ParamStoreKeyDistrEpochIdentifier      = []byte("DistrEpochIdentifier")
)

// NewParams creates a new Params object
func NewParams(
	minNameFieldLength uint64,
	minDescriptionFieldLength uint64,
	coinIssuers []CoinIssuer,
	paymentProcessors []PaymentProcessor,
	recipeFeePercentage sdk.Dec,
	itemTransferFeePercentage sdk.Dec,
	updateItemStringFee sdk.Coin,
	minTransferFee sdk.Int,
	maxTransferFee sdk.Int,
	updateUsernameFee sdk.Coin,
	distrEpochIdentifier string,
) Params {
	return Params{
		MinNameFieldLength:        minNameFieldLength,
		MinDescriptionFieldLength: minDescriptionFieldLength,
		CoinIssuers:               coinIssuers,
		PaymentProcessors:         paymentProcessors,
		RecipeFeePercentage:       recipeFeePercentage,
		ItemTransferFeePercentage: itemTransferFeePercentage,
		UpdateItemStringFee:       updateItemStringFee,
		MinTransferFee:            minTransferFee,
		MaxTransferFee:            maxTransferFee,
		UpdateUsernameFee:         updateUsernameFee,
		DistrEpochIdentifier:      distrEpochIdentifier,
	}
}

// DefaultParams returns default pylons Params
func DefaultParams() Params {
	return NewParams(
		DefaultMinNameFieldLength,
		DefaultMinDescriptionFieldLength,
		DefaultCoinIssuers,
		DefaultPaymentProcessors,
		DefaultRecipeFeePercentage,
		DefaultItemTransferFeePercentage,
		DefaultUpdateItemStringFee,
		DefaultMinTransferFee,
		DefaultMaxTransferFee,
		DefaultUpdateUsernameFee,
		DefaultDistrEpochIdentifier,
	)
}

// NetworkTestParams returns default pylons Params
func NetworkTestParams() Params {
	return NewParams(
		DefaultMinNameFieldLength,
		DefaultMinDescriptionFieldLength,
		DefaultCoinIssuers,
		DefaultPaymentProcessors,
		DefaultRecipeFeePercentage,
		DefaultItemTransferFeePercentage,
		sdk.NewCoin("node0token", sdk.NewInt(10)),
		DefaultMinTransferFee,
		DefaultMaxTransferFee,
		sdk.NewCoin("node0token", sdk.NewInt(10)),
		DefaultDistrEpochIdentifier,
	)
}

// String implements stringer interface
func (p Params) String() string {
	out, _ := yaml.Marshal(p)
	return string(out)
}

// ParamKeyTable returns the parameter by key
func ParamKeyTable() paramtypes.KeyTable {
	return paramtypes.NewKeyTable().RegisterParamSet(&Params{})
}

// ParamSetPairs returns the parameter set pairs.
func (p *Params) ParamSetPairs() paramtypes.ParamSetPairs {
	return paramtypes.ParamSetPairs{
		paramtypes.NewParamSetPair(ParamStoreKeyMinNameFieldLength, &p.MinNameFieldLength, validateUint),
		paramtypes.NewParamSetPair(ParamStoreKeyMinDescriptionFieldLength, &p.MinDescriptionFieldLength, validateUint),
		paramtypes.NewParamSetPair(ParamStoreKeyItemTransferFeePercentage, &p.ItemTransferFeePercentage, validateDecPercentage),
		paramtypes.NewParamSetPair(ParamStoreKeyUpdateItemStringFee, &p.UpdateItemStringFee, validateCoinFee),
		paramtypes.NewParamSetPair(ParamStoreKeyCoinIssuers, &p.CoinIssuers, validateCoinIssuers),
		paramtypes.NewParamSetPair(ParamStoreKeyPaymentProcessors, &p.PaymentProcessors, validatePaymentProcessor),
		paramtypes.NewParamSetPair(ParamStoreKeyRecipeFeePercentage, &p.RecipeFeePercentage, validateDecPercentage),
		paramtypes.NewParamSetPair(ParamStoreKeyMinTransferFee, &p.MinTransferFee, validateInt),
		paramtypes.NewParamSetPair(ParamStoreKeyMaxTransferFee, &p.MaxTransferFee, validateInt),
		paramtypes.NewParamSetPair(ParamStoreKeyUpdateUsernameFee, &p.UpdateUsernameFee, validateCoinFee),
		paramtypes.NewParamSetPair(ParamStoreKeyDistrEpochIdentifier, &p.DistrEpochIdentifier, validateString),
	}
}

// ValidateBasic performs basic validation on distribution parameters.
func (p Params) ValidateBasic() error {
	if p.MinNameFieldLength == 0 {
		return fmt.Errorf("MinNameFieldLength must at least be 1")
	}

	if p.MinDescriptionFieldLength == 0 {
		return fmt.Errorf("MinDescriptionFieldLength must at least be 1")
	}

	if !(p.RecipeFeePercentage.GTE(sdk.ZeroDec()) && p.RecipeFeePercentage.LT(sdk.OneDec())) {
		return fmt.Errorf("percentage parameter should be in the range [0,1)")
	}

	if !(p.ItemTransferFeePercentage.GTE(sdk.ZeroDec()) && p.ItemTransferFeePercentage.LT(sdk.OneDec())) {
		return fmt.Errorf("percentage parameter should be in the range [0,1)")
	}

	if p.MinTransferFee.IsNegative() {
		return fmt.Errorf("parameter cannot be negative")
	}

	if p.MaxTransferFee.IsNegative() {
		return fmt.Errorf("parameter cannot be negative")
	}

	if p.MinTransferFee.GT(p.MaxTransferFee) {
		return fmt.Errorf("MinTransferFee cannot be larger than MaxTransferFee")
	}

	if !p.UpdateItemStringFee.IsValid() {
		return fmt.Errorf("invalid coin")
	}

	for _, ci := range p.CoinIssuers {
		if !sdk.NewCoin(ci.CoinDenom, sdk.OneInt()).IsValid() {
			return fmt.Errorf("invalid denom")
		}

		if ci.GoogleInAppPurchasePubKey != "" {
			for _, iapPackage := range ci.Packages {
				if iapPackage.ProductID == "" {
					return fmt.Errorf("empty string for PackageID")
				}
				if iapPackage.PackageName == "" {
					return fmt.Errorf("empty string for PackageName")
				}
				if iapPackage.Amount.IsNegative() {
					return fmt.Errorf("invalid amount")
				}
			}
		}

		err := ValidateID(ci.EntityName)
		if err != nil {
			return err
		}
	}

	if p.DistrEpochIdentifier == "" {
		return fmt.Errorf("invalid empty DistrEpochIdentifier")
	}

	return nil
}

func validateUint(i interface{}) error {
	v, ok := i.(uint64)
	if !ok {
		return fmt.Errorf("invalid parameter type: %T", i)
	}

	if v <= 0 {
		return fmt.Errorf("min length parameter must be greater than 0")
	}

	return nil
}

func validateDecPercentage(i interface{}) error {
	v, ok := i.(sdk.Dec)
	if !ok {
		return fmt.Errorf("invalid parameter type: %T", i)
	}

	if !(v.GTE(sdk.ZeroDec()) && v.LT(sdk.OneDec())) {
		return fmt.Errorf("percentage parameter should be in the range [0,1)")
	}
	return nil
}

func validateInt(i interface{}) error {
	v, ok := i.(sdk.Int)
	if !ok {
		return fmt.Errorf("invalid parameter type: %T", i)
	}

	if v.IsNegative() {
		return fmt.Errorf("parameter cannot be negative")
	}
	return nil
}

func validateCoinFee(i interface{}) error {
	v, ok := i.(sdk.Coin)
	if !ok {
		return fmt.Errorf("invalid parameter type: %T", i)
	}

	if !v.IsValid() {
		return fmt.Errorf("invalid coin")
	}
	return nil
}

func validateCoinIssuers(i interface{}) error {
	v, ok := i.([]CoinIssuer)
	if !ok {
		return fmt.Errorf("invalid parameter type: %T", i)
	}

	for _, ci := range v {
		coin := sdk.Coin{Denom: ci.CoinDenom, Amount: sdk.OneInt()}
		if !coin.IsValid() {
			return fmt.Errorf("invalid denom")
		}
		err := ValidateID(ci.EntityName)
		if err != nil {
			return err
		}
		if ci.GoogleInAppPurchasePubKey != "" {
			for _, p := range ci.Packages {
				if p.ProductID == "" {
					return fmt.Errorf("empty string for PackageID")
				}
				if p.PackageName == "" {
					return fmt.Errorf("empty string for PackageName")
				}
				if p.Amount.IsNegative() {
					return fmt.Errorf("invalid amount")
				}
			}
		}
	}
	return nil
}

func validatePaymentProcessor(i interface{}) error {
	v, ok := i.([]PaymentProcessor)
	if !ok {
		return fmt.Errorf("invalid parameter type: %T", i)
	}

	for _, pp := range v {
		coin := sdk.Coin{Denom: pp.CoinDenom, Amount: sdk.OneInt()}
		if !coin.IsValid() {
			return fmt.Errorf("invalid denom")
		}
		if err := validateDecPercentage(pp.ProcessorPercentage); err != nil {
			return fmt.Errorf("payment processor percentage must be in the range [0, 1), got %v", pp.ProcessorPercentage.String())
		}
		if err := validateDecPercentage(pp.ValidatorsPercentage); err != nil {
			return fmt.Errorf("validators percentage must be in the range [0, 1), got %v", pp.ValidatorsPercentage.String())
		}
		if err := validateDecPercentage(pp.ProcessorPercentage.Add(pp.ValidatorsPercentage)); err != nil {
			return fmt.Errorf("the sum of payment processor percentage and validators percentage must be in the range [0, 1)")
		}
		pubKeyBytes, err := base64.StdEncoding.DecodeString(pp.PubKey)
		if err != nil {
			return fmt.Errorf("pubKey decoding failure: %s", err.Error())
		}
		if len(pubKeyBytes) != ed25519.PubKeySize {
			return fmt.Errorf("invalid pubKey size")
		}
		if pp.Name == "" {
			return fmt.Errorf("empty string for name")
		}
	}
	return nil
}

func validateString(i interface{}) error {
	v, ok := i.(string)
	if !ok {
		return fmt.Errorf("invalid parameter type: %T", i)
	}

	if v == "" {
		return fmt.Errorf("invalid empty string")
	}
	return nil
}
