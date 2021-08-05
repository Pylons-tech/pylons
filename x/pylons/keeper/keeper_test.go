package keeper

import (
	"os"
	"testing"

	"github.com/Pylons-tech/pylons/app"
	"github.com/Pylons-tech/pylons/testutil/simapp"

	sdk "github.com/cosmos/cosmos-sdk/types"
	tmproto "github.com/tendermint/tendermint/proto/tendermint/types"
)

func setupKeeper(t testing.TB) (*Keeper, sdk.Context) {
	simAppHomeDir := app.DefaultNodeHome + "-sim"
	simApp := simapp.New(simAppHomeDir).(*app.App)
	ctx := simApp.NewContext(true, tmproto.Header{})

	defer func(path string) {
		err := os.RemoveAll(path)
		if err != nil {
		}
	}(simAppHomeDir)

	return &simApp.PylonsKeeper, ctx
}
