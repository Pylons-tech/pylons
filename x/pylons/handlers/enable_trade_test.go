package handlers

import (
	"strings"
	"testing"

	"github.com/MikeSofaer/pylons/x/pylons/keep"
	"github.com/MikeSofaer/pylons/x/pylons/msgs"
	"github.com/MikeSofaer/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/google/uuid"
	"github.com/stretchr/testify/require"
)

func TestHandlerMsgEnableTrade(t *testing.T) {
	mockedCoinInput := keep.SetupTestCoinInput()

	sender, _ := sdk.AccAddressFromBech32("cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337")
	sender2, _ := sdk.AccAddressFromBech32("cosmos16wfryel63g7axeamw68630wglalcnk3l0zuadc")

	mockedCoinInput.Bk.AddCoins(mockedCoinInput.Ctx, sender, types.NewPylon(100000))
	mockedCoinInput.Bk.AddCoins(mockedCoinInput.Ctx, sender2, types.NewPylon(100000))

	id := uuid.New()
	id2 := uuid.New()

	// add 3 trades. one open trade by each sender and one closed trade
	mockedCoinInput.PlnK.SetTrade(mockedCoinInput.Ctx, types.Trade{
		ID:          id.String(),
		ItemInputs:  types.GenItemInputList("Pikachu"),
		CoinOutputs: types.NewPylon(10000),
		Sender:      sender,
		Disabled:    true, // we disable this trade initially
	})

	mockedCoinInput.PlnK.SetTrade(mockedCoinInput.Ctx, types.Trade{
		ID:          id2.String(),
		ItemInputs:  types.GenItemInputList("Richu"),
		CoinOutputs: types.NewPylon(10000),
		Sender:      sender2,
	})

	cases := map[string]struct {
		tradeID      string
		sender       sdk.AccAddress
		desiredError string
		showError    bool
	}{
		"enable a trade successfully": {
			tradeID: id.String(),
			sender:  sender,
		},
		"enable a trade failure due to unauthorized sender": {
			tradeID:      id2.String(),
			showError:    true,
			sender:       sender,
			desiredError: "Trade initiator is not the same as sender",
		},
	}

	for name, tc := range cases {
		t.Run(name, func(t *testing.T) {

			delTrdMsg := msgs.NewMsgEnableTrade(tc.tradeID, tc.sender)
			result := HandlerMsgEnableTrade(mockedCoinInput.Ctx, mockedCoinInput.PlnK, delTrdMsg)
			if tc.showError == false {
				trd, _ := mockedCoinInput.PlnK.GetTrade(mockedCoinInput.Ctx, tc.tradeID)
				require.False(t, trd.Disabled)
			} else {
				require.True(t, strings.Contains(result.Log, tc.desiredError))
			}
		})
	}

}
