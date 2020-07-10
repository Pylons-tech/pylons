package handlers

import (
	"strings"
	"testing"

	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/google/uuid"
	"github.com/stretchr/testify/require"
)

func TestHandlerMsgDisableTrade(t *testing.T) {
	tci := keep.SetupTestCoinInput()
	sender, sender2, _, _ := keep.SetupTestAccounts(t, tci, types.NewPylon(100000), nil, nil, nil)

	_, err := tci.Bk.AddCoins(tci.Ctx, sender2, types.NewPylon(100000))
	require.True(t, err == nil)

	id := uuid.New()
	id2 := uuid.New()
	id3 := uuid.New()

	// add 3 trades. one open trade by each sender and one closed trade
	err = tci.PlnK.SetTrade(tci.Ctx, types.Trade{
		ID:          id.String(),
		ItemInputs:  types.GenTradeItemInputList("LOUD-CB-001", []string{"Pikachu"}),
		CoinOutputs: types.NewPylon(10000),
		Sender:      sender,
	})
	require.True(t, err == nil)

	err = tci.PlnK.SetTrade(tci.Ctx, types.Trade{
		ID:          id2.String(),
		ItemInputs:  types.GenTradeItemInputList("LOUD-CB-001", []string{"Richu"}),
		CoinOutputs: types.NewPylon(10000),
		Sender:      sender2,
	})
	require.True(t, err == nil)

	err = tci.PlnK.SetTrade(tci.Ctx, types.Trade{
		ID:          id3.String(),
		ItemInputs:  types.GenTradeItemInputList("LOUD-CB-001", []string{"Pichu"}),
		CoinOutputs: types.NewPylon(1000),
		Sender:      sender2,
		FulFiller:   sender,
		Completed:   true,
	})
	require.True(t, err == nil)

	cases := map[string]struct {
		tradeID      string
		sender       sdk.AccAddress
		desiredError string
		showError    bool
	}{
		"disable a trade successfully": {
			tradeID: id.String(),
			sender:  sender,
		},
		"disable a trade failure due to unauthorized sender": {
			tradeID:      id2.String(),
			showError:    true,
			sender:       sender,
			desiredError: "Trade initiator is not the same as sender",
		},
		"disable a completed trade with failure": {
			tradeID:      id3.String(),
			showError:    true,
			sender:       sender2,
			desiredError: "Cannot disable a completed trade",
		},
	}

	for name, tc := range cases {
		t.Run(name, func(t *testing.T) {

			delTrdMsg := msgs.NewMsgDisableTrade(tc.tradeID, tc.sender)
			_, err := HandlerMsgDisableTrade(tci.Ctx, tci.PlnK, delTrdMsg)
			if tc.showError == false {
				trd, _ := tci.PlnK.GetTrade(tci.Ctx, tc.tradeID)
				require.True(t, trd.Disabled)
			} else {
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			}
		})
	}

}
