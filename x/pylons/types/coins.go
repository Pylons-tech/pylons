package types

import (
	"encoding/json"
	"fmt"
	"strings"

	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"

	sdk "github.com/cosmos/cosmos-sdk/types"
	ibctypes "github.com/cosmos/ibc-go/v3/modules/apps/transfer/types"
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

	// minimum splits for cookbook
	minCookBookDenomSplits = 2

	// index for cook book id after splits
	cookbookIDIndex = 0
)

// CookbookDenom converts a cookbookID, denom pair into a valid cookbookDenom string
func CookbookDenom(cookbookID, denom string) (string, error) {
	cookbookDenom := cookbookID + denomDivider + denom
	if !IsCookbookDenom(cookbookDenom) {
		return "", fmt.Errorf("cookbook denom cannot be created with cookbookID: %s and denom: %s", cookbookID, denom)
	}
	return cookbookDenom, nil
}

// IsCookbookDenom checks if an inputted denom is a valid cookbookDenom
// If denom is IBC denom we will not consider for CookBookDenom
func IsCookbookDenom(denom string) bool {
	split := strings.Split(denom, denomDivider)
	if len(split) != minCookBookDenomSplits {
		return false
	}

	// check if it is IBC denom
	if IsIBCDenomRepresentation(denom) {
		return false
	}
	// validate cookbook ID
	err := ValidateID(split[cookbookIDIndex])
	if err != nil {
		return false
	}

	// validate denom
	coin := sdk.Coin{Denom: split[1], Amount: sdk.OneInt()}
	err = coin.Validate()
	return err == nil
}

// IBCDenom converts a trace hash into a properly formatted IBCDenom string
func IBCDenom(hash string) (string, error) {
	ibcDenom := ibcPrefix + denomDivider + hash
	if !IsIBCDenomRepresentation(ibcDenom) {
		return "", fmt.Errorf("ibc denom cannot be created with hash: %s", hash)
	}
	return ibcDenom, nil
}

// IsIBCDenomRepresentation checks if an inputted denom is a valid IBCDenom
func IsIBCDenomRepresentation(denom string) bool {
	split := strings.Split(denom, denomDivider)
	if len(split) != 2 {
		return false
	}

	err := ValidateIBCDenom(denom)
	return err == nil
}

func ValidateIBCDenom(denom string) error {
	if err := sdk.ValidateDenom(denom); err != nil {
		return err
	}

	denomSplit := strings.SplitN(denom, "/", 2)

	switch {
	case strings.TrimSpace(denom) == "",
		len(denomSplit) == 1 && denomSplit[0] == ibctypes.DenomPrefix,
		len(denomSplit) == 2 && (denomSplit[0] != ibctypes.DenomPrefix || strings.TrimSpace(denomSplit[1]) == ""):
		return sdkerrors.Wrapf(ibctypes.ErrInvalidDenomForTransfer, "denomination should be prefixed with the format 'ibc/{hash(trace + \"/\" + %s)}'", denom)

	case denomSplit[0] == denom && strings.TrimSpace(denom) != "":
		return nil
	}

	if _, err := ibctypes.ParseHexHash(denomSplit[1]); err != nil {
		return sdkerrors.Wrapf(err, "invalid denom trace hash %s", denomSplit[1])
	}

	return nil
}

// CreateValidCoinOutputsList checks a list of coinOutputs to check if they are valid.  Valid coinOuputs
// must have cookbookDenoms that are only from the proper cookbook and cannot mint payment tokens
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

// ParseCoinInputStringArray converts a []string of form {"100tokenA,100tokenB","1000tokenC"}
// and converts it to a []CoinInput
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

// ParseCoinInputsCLI parses a string and returns a []CoinInput.
// The string can either be of the json form of a []CoinInput,
// or be of form: {"100tokenA,100tokenB","1000tokenC"} as a string.
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

// ParseCoinsCLI parses a string and returns an sdk.Coins type.
// The string can either be in the json form of the sdk.Coins type
// or of form: "100tokenA,200tokenB,300tokenC"
func ParseCoinsCLI(arg string) (sdk.Coins, error) {
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

// ParseCoinCLI parses a string and returns an sdk.Coin type.
// The string can either be in the json form of the sdk.Coin type
// or in the string form: "100tokenA"
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
