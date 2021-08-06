package config

import (
	"fmt"
	"os"
	"path/filepath"

	"gopkg.in/yaml.v2"
)

// FeeConfiguration is a struct to manage fee configuration
type FeeConfiguration struct {
	RecipePercent                          int64 `yaml:"recipe_fee_percentage"`
	BasicTierCookbook                      int64 `yaml:"cookbook_basic_fee"`
	PremiumTireCookbook                    int64 `yaml:"cookbook_premium_fee"`
	PylonsTradePercent                     int64 `yaml:"pylons_trade_percentage"`
	MinTradePrice                          int64 `yaml:"minimum_trade_price"`
	UpdateItemFieldString                  int64 `yaml:"update_item_string_field_fee"`
	MinItemTransferFee                     int64 `yaml:"min_item_transfer_fee"`
	MaxItemTransferFee                     int64 `yaml:"max_item_transfer_fee"`
	ItemTransferCookbookOwnerProfitPercent int64 `yaml:"item_transfer_cookbook_owner_profit_percent"`
}

// ValidatorsConfiguration is a struct to manage validators configuration
type ValidatorsConfiguration struct {
	PylonsLLC string `yaml:"pylons_llc"`
}

// GoogleIAPConfiguration is a struct to manage google iap packages and products
type GoogleIAPConfiguration struct {
	PackageName string `yaml:"package_name"`
	ProductID   string `yaml:"product_id"`
	Amount      int64  `yaml:"amount"`
}

type StripeIAPConfiguration struct {
	PackageName string `yaml:"package_name"`
	ProductID   string `yaml:"product_id"`
	Amount      int64  `yaml:"amount"`
}

type StripeConfiguration struct {
	StripeSecretKey   string `yaml:"stripe_secretKey"`
	StripePubKey      string `yaml:"stripe_publicKey"`
	StripeClientID    string `yaml:"stripe_client_id"`
	StripeRedirectURI string `yaml:"stripe_redirect_uri"`
	StripeCancelURI   string `yaml:"stripe_cancel_url"`
	StripeCountry     string `yaml:"stripeCountry"`
	Country           string `yaml:"country"`
	Currency          string `yaml:"currency"`
	PaymentMethods    string `yaml:"paymentMethods"`
	StripeSkuID       string `yaml:"stripe_sku_id"`
}

// Configuration is a struct to manage game configuration
type Configuration struct {
	Fee             FeeConfiguration         `yaml:"fees"`
	Validators      ValidatorsConfiguration  `yaml:"validators"`
	GoogleIAP       []GoogleIAPConfiguration `yaml:"google_iap"`
	GoogleIAPPubKey string                   `yaml:"google_iap_pubkey"`
	StripeIAP       []StripeIAPConfiguration `yaml:"stripe_iap"`
	StripeConfig    StripeConfiguration      `yaml:"stripe_config"`
	IsProduction    bool                     `yaml:"is_production"`
}

// Config is for managing configuration
var Config Configuration

func init() {
	err := ReadConfig()
	if err != nil {
		fmt.Println("config reading error", err)
		os.Exit(1)
	}
}

func PaymentMethods() string {
	paymentMethodsString := os.Getenv("PAYMENT_METHODS")
	if paymentMethodsString == "" {
		return "card"
	}
	return paymentMethodsString
}

// ReadConfig is a function to read configuration
func ReadConfig() error {
	userHomeDir, err := os.UserHomeDir()
	if err != nil {
		panic(err)
	}
	cfgFileNames := [3]string{
		filepath.Join(userHomeDir, ".pylonsd", "config", "pylons.yml"),
		filepath.Join(userHomeDir, "config", "pylons.yml"),
		"./pylons.yml"}

	for _, cfgFileName := range cfgFileNames {
		configf, err := os.Open(cfgFileName)
		if err == nil {
			decoder := yaml.NewDecoder(configf)
			cfg := decoder.Decode(&Config)
			err := configf.Close()
			if err != nil {
				panic(err)
			}
			return cfg
		}
	}
	Config = Configuration{
		Fee: FeeConfiguration{
			RecipePercent:                          10,
			BasicTierCookbook:                      10000,
			PremiumTireCookbook:                    50000,
			PylonsTradePercent:                     10,
			MinTradePrice:                          10,
			UpdateItemFieldString:                  10,
			MinItemTransferFee:                     1,
			MaxItemTransferFee:                     100000,
			ItemTransferCookbookOwnerProfitPercent: 90,
		},
		Validators: ValidatorsConfiguration{
			PylonsLLC: "cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337",
		},
		GoogleIAP: []GoogleIAPConfiguration{
			{
				PackageName: "com.pylons.loud",
				ProductID:   "pylons_1000",
				Amount:      1000,
			},
			{
				PackageName: "com.pylons.loud",
				ProductID:   "pylons_55000",
				Amount:      55000,
			},
		},
		GoogleIAPPubKey: "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwZsjhk6eN5Pve9pP3uqz2MwBFixvmCRtQJoDQLTEJo3zTd9VMZcXoerQX8cnDPclZWmMZWkO+BWcN1ikYdGHvU2gC7yBLi+TEkhsEkixMlbqOGRdmNptJJhqxuVmXK+drWTb6W0IgQ9g8CuCjZUiMTc0UjHb5mPOE/IhcuTZ0wCHdoqc5FS2spdQqrohvSEP7gR4ZgGzYNI1U+YZHskIEm2qC4ZtSaX9J/fDkAmmJFV2hzeDMcljCxY9+ZM1mdzIpZKwM7O6UdWRpwD1QJ7yXND8AQ9M46p16F0VQuZbbMKCs90NIcKkx6jDDGbVmJrFnUT1Oq1uYxNYtiZjTp+JowIDAQAB",
		StripeIAP: []StripeIAPConfiguration{
			{
				PackageName: "com.pylons.loud",
				ProductID:   "pylons_1000",
				Amount:      1000,
			},
			{
				PackageName: "com.pylons.loud",
				ProductID:   "pylons_55000",
				Amount:      55000,
			},
		},
		StripeConfig: StripeConfiguration{
			StripeSecretKey:   "StripeSecretKey",
			StripePubKey:      "StripePubKey",
			StripeClientID:    "StripeClientID",
			StripeRedirectURI: "https://wallet.pylons.tech",
			StripeCancelURI:   "https://wallet.pylons.tech/cancel",
			StripeCountry:     "us",
			Country:           "US",
			Currency:          "USD",
			PaymentMethods:    PaymentMethods(),
			StripeSkuID:       "PaymentMethods",
		},
		IsProduction: false,
	}
	return nil
}
