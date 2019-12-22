package handlers

import (
	"fmt"
	"testing"

	"github.com/MikeSofaer/pylons/x/pylons/keep"
	"github.com/MikeSofaer/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/google/uuid"
)

func TestHandlerMsgDeleteTrade(t *testing.T) {
	mockedCoinInput := keep.SetupTestCoinInput()

	sender, _ := sdk.AccAddressFromBech32("cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337")
	sender2, _ := sdk.AccAddressFromBech32("cosmos16wfryel63g7axeamw68630wglalcnk3l0zuadc")

	mockedCoinInput.Bk.AddCoins(mockedCoinInput.Ctx, sender, types.NewPylon(100000))
	mockedCoinInput.Bk.AddCoins(mockedCoinInput.Ctx, sender2, types.NewPylon(100000))

	id := uuid.New()
	id2 := uuid.New()
	id3 := uuid.New()

	// add 3 trades. one open trade by each sender and one closed trade
	mockedCoinInput.PlnK.SetTrade(mockedCoinInput.Ctx, types.Trade{
		ID:          id.String(),
		ItemInputs:  types.GenItemInputList("Pikachu"),
		CoinOutputs: types.NewPylon(10000),
		Sender:      sender,
	})

	mockedCoinInput.PlnK.SetTrade(mockedCoinInput.Ctx, types.Trade{
		ID:          id2.String(),
		ItemInputs:  types.GenItemInputList("Richu"),
		CoinOutputs: types.NewPylon(10000),
		Sender:      sender2,
	})

	mockedCoinInput.PlnK.SetTrade(mockedCoinInput.Ctx, types.Trade{
		ID:          id3.String(),
		ItemInputs:  types.GenItemInputList("Pichu"),
		CoinOutputs: types.NewPylon(1000),
		Sender:      sender2,
		FulFiller:   sender,
		Completed:   true,
	})

	cases := map[string]struct {
		tradeID      string
		sender       sdk.AccAddress
		desiredError string
		showError    bool
	}{
		"delete a trade successfully": {
			tradeID: id.String(),
			sender:  sender,
		},
		"delete a trade failure due to unauthorized sender": {
			tradeID: id3.String(),
		},
		"delete a completed trade with failure": {
			tradeID: id3.String(),
		},
	}
	fmt.Println(cases)

}
