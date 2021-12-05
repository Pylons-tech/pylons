package types

import (
	"encoding/json"
	"fmt"
	"strings"

	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"

	sdk "github.com/cosmos/cosmos-sdk/types"
	ibctypes "github.com/cosmos/ibc-go/v2/modules/apps/transfer/types"
)

const (
	// PylonsCoinDenom is the pylons denom string with the u prefix indicating "micropylon"
	PylonsCoinDenom = "upylon"
	// StakingCoinDenom is the staking denom string with the u prefix indicating "microbedrock"
	StakingCoinDenom = "ubedrock"
	// StripeCoinDenom is the denom string for Stripe-based USD
	StripeCoinDenom = "ustripeusd"
	// CosmosCoinDenom is the atom denom string with the u prefix indicating "uatom"
	CosmosCoinDenom = "uatom"

	denomDivider = "/"
	ibcPrefix    = "ibc"
)

func CookbookDenom(cookbookID, denom string) (string, error) {
	cookbookDenom := cookbookID + denomDivider + denom
	if !IsCookbookDenom(cookbookDenom) {
		return "", fmt.Errorf("cookbook denom cannot be created with cookbookID: %s and denom: %s", cookbookID, denom)
	}
	return cookbookDenom, nil
}

func IsCookbookDenom(denom string) bool {
	split := strings.Split(denom, denomDivider)
	if len(split) != 2 {
		return false
	}

	// validate cookbook ID
	err := ValidateID(split[0])
	if err != nil {
		return false
	}

	// validate denom
	coin := sdk.Coin{Denom: split[1], Amount: sdk.OneInt()}
	err = coin.Validate()
	return err == nil
}

func IBCDenom(hash string) (string, error) {
	ibcDenom := ibcPrefix + denomDivider + hash
	if !IsIBCDenomRepresentation(ibcDenom) {
		return "", fmt.Errorf("ibc denom cannot be created with hash: %s", hash)
	}
	return ibcDenom, nil
}

func IsIBCDenomRepresentation(denom string) bool {
	split := strings.Split(denom, denomDivider)
	if len(split) != 2 {
		return false
	}

	err := ibctypes.ValidateIBCDenom(denom)
	return err == nil
}

func CreateValidCoinOutputsList(cookbookID string, coinOutputs []CoinOutput) ([]CoinOutput, error) {
	validCoinOutputs := make([]CoinOutput, len(coinOutputs))
	for i, coinOutput := range coinOutputs {
		// recipes can only mint Cookbook denoms (form "cookbookID/denom")
		if !IsCookbookDenom(coinOutput.Coin.Denom) {
			cookbookDenom, err := CookbookDenom(cookbookID, coinOutput.Coin.Denom)
			if err != nil {
				return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "cannot convert denom to cookbookDenom")
			}

			validCoinOutputs[i] = CoinOutput{
				ID:      coinOutput.ID,
				Coin:    sdk.NewCoin(cookbookDenom, coinOutput.Coin.Amount),
				Program: coinOutput.Program,
			}
			continue
		}

		// make sure that the cookbookPrefix is the properly provided one
		split := strings.Split(coinOutput.Coin.Denom, denomDivider)
		if split[0] != cookbookID {
			return nil, sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, "coin Output cookbook prefix %s does not match cookbook prefix %s", split[0], cookbookID)
		}

		validCoinOutputs[i] = coinOutput
	}

	return validCoinOutputs, nil
}

func ParseCoinInputStringArray(coinsStr []string) ([]CoinInput, error) {
	coinInputs := make([]CoinInput, len(coinsStr))

	for i, coinStr := range coinsStr {
		coins, err := sdk.ParseCoinsNormalized(coinStr)
		if err != nil {
			return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidCoins, err.Error())
		}
		coinInputs[i].Coins = coins
	}

	return coinInputs, nil
}

func ParseCoinInputsCLI(arg string) ([]CoinInput, error) {
	coinInputs := make([]CoinInput, 0)
	err := json.Unmarshal([]byte(arg), &coinInputs)
	if err != nil {
		// try to marshal as []string
		var coinStrs []string
		err = json.Unmarshal([]byte(arg), &coinStrs)
		if err != nil {
			return nil, sdkerrors.Wrap(err, "cannot convert to []string or []CoinInput")
		}
		coinInputs, err = ParseCoinInputStringArray(coinStrs)
		if err != nil {
			return nil, err
		}
	}

	return coinInputs, nil
}

func ParseCoinOutputCLI(arg string) (sdk.Coins, error) {
	coinOutputs := sdk.NewCoins()
	err := json.Unmarshal([]byte(arg), &coinOutputs)
	if err != nil {
		// arg is in format "10uatom,100upylon"
		coinOutputs, err = sdk.ParseCoinsNormalized(arg)
		if err != nil {
			return nil, err
		}
	}

	return coinOutputs, nil
}

func ParseCoinCLI(arg string) (sdk.Coin, error) {
	coin := sdk.Coin{}
	err := json.Unmarshal([]byte(arg), &coin)
	if err != nil {
		coin, err = sdk.ParseCoinNormalized(arg)
		if err != nil {
			return sdk.Coin{}, err
		}
	}
	return coin, nil
}
