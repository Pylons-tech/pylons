package cli

import (
	"strings"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/tendermint/starport/starport/pkg/cosmoscoin"
)

// ParseCoinArguments parses a cli argument of the format "10000000utoken,10000000ustake" and
// returns a slice of type sdk.Coin
func ParseCoinArguments(args string) ([]sdk.Coin, error) {
	coins := make([]sdk.Coin, 0)
	for _, coin := range strings.Split(args, ",") {
		coinAmount, coinDenom, err := cosmoscoin.Parse(coin)
		if err != nil {
			return nil, err
		}
		coin := sdk.NewInt64Coin(coinDenom, int64(coinAmount))
		coins = append(coins, coin)
	}

	return coins, nil
}
