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
	// DefaultMinFieldLength is the default minimum character length of a request's field
	DefaultMinFieldLength int = 3
	// DefaultMaxFieldLength is the default maximum character length of a request's field
	DefaultMaxFieldLength int = 65535
)

var (
	DefaultCoinIssuers = []CoinIssuer{
		{
			CoinDenom: PylonsCoinDenom,
			Packages: []GoogleInAppPurchasePackage{
				{PackageName: "tech.pylons.wallet", ProductId: "pylons_10", Amount: sdk.NewInt(10)},
				{PackageName: "tech.pylons.wallet", ProductId: "pylons_35", Amount: sdk.NewInt(35)},
				{PackageName: "tech.pylons.wallet", ProductId: "pylons_60", Amount: sdk.NewInt(60)},
			},
			GoogleInAppPurchasePubKey: "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAuMzgsJOZzyZvmOG8T9baGxDR/DWx6dgku7UdDfc6aGKthPGYouOa4KvLGEuNd+YTilwtEEryi3mmYAtl8MNtiAQCiry7HjdRNle8lLUHSKwBLVCswY3WGEAuW+5mo/V6X0klS8se65fIqCv2x/SKjtTZvKO/Oe3uehREMY1b8uWLrD5roubXzmaLsFGIRi5wdg8UWRe639LCNb2ghD2Uw0svBTJqn/ymsPmCfVjmCNNRDxfxzlA8O4EEKCK1qOdwIejMAfFMrN87u+0HTQbCKQ/xUQrR6fUhWT2mqttBGhi1NmTNBlUDyXYU+7ILbfJUVqQcKNDbFQd+xv9wBnXAhwIDAQAB",
			EntityName:                "Pylons_Inc",
		},
	}

	DefaultProcessorPercentage  = sdk.ZeroDec()
	DefaultValidatorsPercentage = sdk.MustNewDecFromStr("0.003")
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
	DefaultEngineVersion                = uint64(0)
	DefaultMaxTxsInBlock                = uint64(20)
)

// Parameter Store Keys
var (
	ParamStoreKeyCoinIssuers               = []byte("CoinIssuers")
	ParamStoreKeyPaymentProcessors         = []byte("PaymentProcessors")
	ParamStoreKeyRecipeFeePercentage       = []byte("RecipeFeePercentage")
	ParamStoreKeyItemTransferFeePercentage = []byte("ItemTransferFeePercentage")
	ParamStoreKeyUpdateItemStringFee       = []byte("UpdateItemStringFee")
	ParamStoreKeyMinTransferFee            = []byte("MinTransferFee")
	ParamStoreKeyMaxTransferFee            = []byte("MaxTransferFee")
	ParamStoreKeyUpdateUsernameFee         = []byte("UpdateUsernameFee")
	ParamStoreKeyDistrEpochIdentifier      = []byte("DistrEpochIdentifier")
	ParamStoreKeyEngineVersion             = []byte("EngineVersion")
	ParamStoreKeyMaxTxsInBlock             = []byte("MaxTxsInBlock")
)

// NewParams creates a new Params object
func NewParams(
	coinIssuers []CoinIssuer,
	paymentProcessors []PaymentProcessor,
	recipeFeePercentage sdk.Dec,
	itemTransferFeePercentage sdk.Dec,
	updateItemStringFee sdk.Coin,
	minTransferFee sdk.Int,
	maxTransferFee sdk.Int,
	updateUsernameFee sdk.Coin,
	distrEpochIdentifier string,
	engineVersion uint64,
	maxTxs uint64,
) Params {
	return Params{
		CoinIssuers:               coinIssuers,
		PaymentProcessors:         paymentProcessors,
		RecipeFeePercentage:       recipeFeePercentage,
		ItemTransferFeePercentage: itemTransferFeePercentage,
		UpdateItemStringFee:       updateItemStringFee,
		MinTransferFee:            minTransferFee,
		MaxTransferFee:            maxTransferFee,
		UpdateUsernameFee:         updateUsernameFee,
		DistrEpochIdentifier:      distrEpochIdentifier,
		EngineVersion:             engineVersion,
		MaxTxsInBlock:             maxTxs,
	}
}

// DefaultParams returns default pylons Params
func DefaultParams() Params {
	return NewParams(
		DefaultCoinIssuers,
		DefaultPaymentProcessors,
		DefaultRecipeFeePercentage,
		DefaultItemTransferFeePercentage,
		DefaultUpdateItemStringFee,
		DefaultMinTransferFee,
		DefaultMaxTransferFee,
		DefaultUpdateUsernameFee,
		DefaultDistrEpochIdentifier,
		DefaultEngineVersion,
		DefaultMaxTxsInBlock,
	)
}

// NetworkTestParams returns default pylons Params
func NetworkTestParams() Params {
	return NewParams(
		DefaultCoinIssuers,
		DefaultPaymentProcessors,
		DefaultRecipeFeePercentage,
		DefaultItemTransferFeePercentage,
		sdk.NewCoin("node0token", sdk.NewInt(10)),
		DefaultMinTransferFee,
		DefaultMaxTransferFee,
		sdk.NewCoin("node0token", sdk.NewInt(10)),
		DefaultDistrEpochIdentifier,
		DefaultEngineVersion,
		DefaultMaxTxsInBlock,
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
		paramtypes.NewParamSetPair(ParamStoreKeyItemTransferFeePercentage, &p.ItemTransferFeePercentage, validateDecPercentage),
		paramtypes.NewParamSetPair(ParamStoreKeyUpdateItemStringFee, &p.UpdateItemStringFee, validateCoinFee),
		paramtypes.NewParamSetPair(ParamStoreKeyCoinIssuers, &p.CoinIssuers, validateCoinIssuers),
		paramtypes.NewParamSetPair(ParamStoreKeyPaymentProcessors, &p.PaymentProcessors, validatePaymentProcessor),
		paramtypes.NewParamSetPair(ParamStoreKeyRecipeFeePercentage, &p.RecipeFeePercentage, validateDecPercentage),
		paramtypes.NewParamSetPair(ParamStoreKeyMinTransferFee, &p.MinTransferFee, validateInt),
		paramtypes.NewParamSetPair(ParamStoreKeyMaxTransferFee, &p.MaxTransferFee, validateInt),
		paramtypes.NewParamSetPair(ParamStoreKeyUpdateUsernameFee, &p.UpdateUsernameFee, validateCoinFee),
		paramtypes.NewParamSetPair(ParamStoreKeyDistrEpochIdentifier, &p.DistrEpochIdentifier, validateString),
		paramtypes.NewParamSetPair(ParamStoreKeyEngineVersion, &p.EngineVersion, validateInt64),
		paramtypes.NewParamSetPair(ParamStoreKeyMaxTxsInBlock, &p.MaxTxsInBlock, validateInt64),
	}
}

// ValidateBasic performs basic validation on distribution parameters.
func (p Params) ValidateBasic() error {
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
				if iapPackage.ProductId == "" {
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
				if p.ProductId == "" {
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

func validateInt64(i interface{}) error {
	_, ok := i.(uint64)
	if !ok {
		return fmt.Errorf("invalid parameter type: %T", i)
	}

	return nil
}
