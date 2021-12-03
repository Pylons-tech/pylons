package types

import (
	"encoding/json"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	"github.com/tendermint/starport/starport/pkg/cosmoscoin"
)

// ParseCoinArguments parses a coin input argument in the JSON array format
// and returns a slice of types.CoinInput
func ParseCoinArguments(args string) ([]CoinInput, error) {
	var jsonArgs [][]string
	err := json.Unmarshal([]byte(args), &jsonArgs)
	if err != nil {
		return nil, sdkerrors.Wrapf(err, "Invalid Coin Input : %s", args)
	}
	inputCoins := make([]CoinInput, 0)
	for i := range jsonArgs {
		coins := make([]sdk.Coin, 0)
		for j := range jsonArgs[i] {
			coinAmount, coinDenom, err := cosmoscoin.Parse(jsonArgs[i][j])
			if err != nil {
				return nil, sdkerrors.Wrapf(err, "Invalid Coin Input : %s", args)
			}
			coins = append(coins, sdk.NewInt64Coin(coinDenom, int64(coinAmount)))
		}
		inputCoins = append(inputCoins, CoinInput{
			Coins: coins,
		})

	}

	return inputCoins, nil
}
