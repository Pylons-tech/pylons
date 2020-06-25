package config

import (
	"fmt"
	"os"

	"gopkg.in/yaml.v2"
)

// FeeConfiguration is a struct to manage fee configuration
type FeeConfiguration struct {
	RecipePercent               int64 `yaml:"recipe_fee_percentage"`
	BasicTierCookbook           int64 `yaml:"cookbook_basic_fee"`
	PremiumTireCookbook         int64 `yaml:"cookbook_premium_fee"`
	PylonsTradePercent          int64 `yaml:"pylons_trade_percentage"`
	MinTradePrice               int64 `yaml:"minimum_trade_price"`
	UpdateItemFieldString       int64 `yaml:"update_item_string_field_fee"`
	BasicItemTransferFee        int64 `yaml:"basic_item_transfer_fee"`
	PylonsItemTransferPercent   int64 `yaml:"pylons_item_transfer_percent"`
	CbSenderItemTransferPercent int64 `yaml:"cb_sender_item_transfer_percent"`
}

// ValidatorsConfiguration is a struct to manage validators configuration
type ValidatorsConfiguration struct {
	PylonsLLC string `yaml:"pylons_llc"`
}

// Configuration is a struct to manage game configuration
type Configuration struct {
	Fee        FeeConfiguration        `yaml:"fees"`
	Validators ValidatorsConfiguration `yaml:"validators"`
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

// ReadConfig is a function to read configuration
func ReadConfig() error {
	cfgFileName := "./pylons.yml"

	configf, err := os.Open(cfgFileName)
	if err == nil {
		defer configf.Close()

		decoder := yaml.NewDecoder(configf)
		return decoder.Decode(&Config)
	}
	Config = Configuration{
		Fee: FeeConfiguration{
			RecipePercent:               10,
			BasicTierCookbook:           10000,
			PremiumTireCookbook:         50000,
			PylonsTradePercent:          10,
			MinTradePrice:               10,
			UpdateItemFieldString:       10,
			BasicItemTransferFee:        300,
			PylonsItemTransferPercent:   10,
			CbSenderItemTransferPercent: 90,
		},
		Validators: ValidatorsConfiguration{
			PylonsLLC: "cosmos105wr8t6y97rwv90xzhxd4juj4lsajtjaass6h7",
		},
	}
	return nil
}
