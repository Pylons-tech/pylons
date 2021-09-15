package types

import (
	"fmt"
	"strings"

	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"

	sdk "github.com/cosmos/cosmos-sdk/types"
	banktypes "github.com/cosmos/cosmos-sdk/x/bank/types"
	ibctypes "github.com/cosmos/ibc-go/modules/apps/transfer/types"
)

const (
	// PylonsCoinDenom is the pylons denom string with the u prefix indicating "micropylon"
	PylonsCoinDenom = "upylon"
	// StakingCoinDenom is the staking denom string with the u prefix indicating "microbedrock"
	StakingCoinDenom = "ubedrock"
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
		cookbookDenom, err := CookbookDenom(cookbookID, coinOutput.Coin.Denom)
		if err != nil {
			return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "cannot convert denom to cookbookDenom")
		}

		if !IsCookbookDenom(coinOutput.Coin.Denom) {
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
			return nil, fmt.Errorf("coin Output cookbook prefix %s does not match cookbook prefix %s", split[0], cookbookID)
		}

		validCoinOutputs[i] = coinOutput
	}

	return validCoinOutputs, nil
}

// TODO add Name and Symbol fields after SDK upgrade

func PylonsCoinMetadata() banktypes.Metadata {
	return banktypes.Metadata{
		Description: "The native engagement token of the Pylons Ecosystem.",
		DenomUnits: []*banktypes.DenomUnit{
			{Denom: PylonsCoinDenom, Exponent: uint32(0), Aliases: []string{"micropylon"}},
			{Denom: "mpylon", Exponent: uint32(3), Aliases: []string{"millipylon"}},
			{Denom: "pylon", Exponent: uint32(6), Aliases: nil},
		},
		Base:    PylonsCoinDenom,
		Display: "pylon",
	}
}

func StakingCoinMetadata() banktypes.Metadata {
	return banktypes.Metadata{
		Description: "The native staking token of the Pylons Ecosystem.",
		DenomUnits: []*banktypes.DenomUnit{
			{Denom: StakingCoinDenom, Exponent: uint32(0), Aliases: []string{"microbedrock"}},
			{Denom: "mbedrock", Exponent: uint32(3), Aliases: []string{"millibedrock"}},
			{Denom: "bedrock", Exponent: uint32(6), Aliases: nil},
		},
		Base:    StakingCoinDenom,
		Display: "bedrock",
	}
}

func AtomCoinMetadata() banktypes.Metadata {
	return banktypes.Metadata{
		Description: "The native staking token of the Cosmos Hub.",
		DenomUnits: []*banktypes.DenomUnit{
			{Denom: "uatom", Exponent: uint32(0), Aliases: []string{"microatom"}},
			{Denom: "matom", Exponent: uint32(3), Aliases: []string{"milliatom"}},
			{Denom: "atom", Exponent: uint32(6), Aliases: nil},
		},
		Base:    "uatom",
		Display: "atom",
	}
}
