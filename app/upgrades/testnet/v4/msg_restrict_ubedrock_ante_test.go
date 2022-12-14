package v4_test

import (
	"testing"
	"time"

	"github.com/Pylons-tech/pylons/app"
	v4 "github.com/Pylons-tech/pylons/app/upgrades/v4"
	sdk "github.com/cosmos/cosmos-sdk/types"
	banktypes "github.com/cosmos/cosmos-sdk/x/bank/types"
	"github.com/stretchr/testify/require"
	tmproto "github.com/tendermint/tendermint/proto/tendermint/types"
)

func noOpAnteDecorator() sdk.AnteHandler {
	return func(ctx sdk.Context, _ sdk.Tx, _ bool) (sdk.Context, error) {
		return ctx, nil
	}
}

func createTestContext() (sdk.Context, app.PylonsApp) {
	pylonsApp := app.Setup(false)

	ctx := pylonsApp.BaseApp.NewContext(true, tmproto.Header{Height: 1, ChainID: "pylons-1", Time: time.Now().UTC()})
	return ctx, *pylonsApp
}

func TestMsgRestrictUbedrockDecorator(t *testing.T) {
	ctx, pylonsApp := createTestContext()
	handler := v4.NewMsgRestrictUbedrockDecorator(pylonsApp.PylonsKeeper)
	txCfg := app.MakeEncodingConfig().TxConfig

	addr1 := sdk.AccAddress([]byte("address1---------------"))
	addr2 := sdk.AccAddress([]byte("address2---------------"))

	testCases := []struct {
		name      string
		ctx       sdk.Context
		msgs      []sdk.Msg
		expectErr bool
	}{
		{
			name: "Valid account",
			ctx:  ctx,
			msgs: []sdk.Msg{
				banktypes.NewMsgSend(addr1, addr2, sdk.NewCoins(sdk.NewInt64Coin("foo", 5))),
			},
			expectErr: false,
		},
		{
			name: "Invalid account",
			ctx:  ctx,
			msgs: []sdk.Msg{
				banktypes.NewMsgSend(addr1, addr2, sdk.NewCoins(sdk.NewInt64Coin("ubedrock", 1))),
			},
			expectErr: true,
		},
	}

	for _, tc := range testCases {
		tc := tc
		t.Run(tc.name, func(t *testing.T) {
			txBuilder := txCfg.NewTxBuilder()
			require.NoError(t, txBuilder.SetMsgs(tc.msgs...))

			_, err := handler.AnteHandle(tc.ctx, txBuilder.GetTx(), false, noOpAnteDecorator())
			if tc.expectErr {
				require.Error(t, err)
			} else {
				require.NoError(t, err)
			}
		})
	}
}
