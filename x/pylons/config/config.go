package config

import (
	"fmt"
	"os"

	"gopkg.in/yaml.v2"
)

// Configuration is a struct to manage game configuration
type Configuration struct {
	Fee struct {
		RecipePercent       int64 `yaml:"recipe_fee_percentage"`
		BasicTierCookbook   int64 `yaml:"cookbook_basic_fee"`
		PremiumTireCookbook int64 `yaml:"cookbook_premium_fee"`
		PylonsTradePercent  int64 `yaml:"pylons_trade_percentage"`
		MinTradePrice       int64 `yaml:"minimum_trade_price"`
	} `yaml:"fees"`
	Validators struct {
		PylonsLLC string `yaml:"pylons_llc"`
	} `yaml:"validators"`
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
	cfgFileName := "pylons.yml"

	configf, err := os.Open(cfgFileName)
	if err == nil {
		defer configf.Close()

		decoder := yaml.NewDecoder(configf)
		err = decoder.Decode(&Config)
	}
	return err
}
