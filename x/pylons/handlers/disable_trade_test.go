package handlers

import (
	"encoding/json"
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
	require.NoError(t, err)

	id := uuid.New()
	id2 := uuid.New()
	id3 := uuid.New()
	id4 := uuid.New()

	cbData := CreateCookbookResponse{}

	cookbookMsg := msgs.NewMsgCreateCookbook("cookbook-0001", "cookbook-id-0001", "this has to meet character limits", "SketchyCo", "1.0.0", "example@example.com", 1, msgs.DefaultCostPerBlock, sender)
	cookbookResult, _ := HandlerMsgCreateCookbook(tci.Ctx, tci.PlnK, cookbookMsg)
	err = json.Unmarshal(cookbookResult.Data, &cbData)
	require.NoError(t, err)
	require.True(t, len(cbData.CookbookID) > 0)

	item := keep.GenItem(cbData.CookbookID, sender, "Raichu")
	item.OwnerTradeID = id.String()
	err = tci.PlnK.SetItem(tci.Ctx, *item)
	require.NoError(t, err)

	// add trades for tests, one open trade by each sender and one closed trade
	err = tci.PlnK.SetTrade(tci.Ctx, types.Trade{
		ID:          id.String(),
		ItemInputs:  types.GenTradeItemInputList("LOUD-CB-001", []string{"Pikachu"}),
		ItemOutputs: types.ItemList{*item},
		CoinOutputs: types.NewPylon(10000),
		Sender:      sender,
	})
	require.NoError(t, err)

	err = tci.PlnK.SetTrade(tci.Ctx, types.Trade{
		ID:          id2.String(),
		ItemInputs:  types.GenTradeItemInputList("LOUD-CB-001", []string{"Richu"}),
		CoinOutputs: types.NewPylon(10000),
		Sender:      sender2,
	})
	require.NoError(t, err)

	err = tci.PlnK.SetTrade(tci.Ctx, types.Trade{
		ID:          id3.String(),
		ItemInputs:  types.GenTradeItemInputList("LOUD-CB-001", []string{"Pichu"}),
		CoinOutputs: types.NewPylon(1000),
		Sender:      sender2,
		FulFiller:   sender,
		Completed:   true,
	})
	require.NoError(t, err)

	err = tci.PlnK.SetTrade(tci.Ctx, types.Trade{
		ID:          id4.String(),
		ItemInputs:  types.GenTradeItemInputList("LOUD-CB-001", []string{"Pikachu"}),
		ItemOutputs: types.ItemList{*item},
		CoinOutputs: types.NewPylon(10000),
		Sender:      sender2,
	})
	require.NoError(t, err)

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
		"disable wrong item id owner trade with failure": {
			tradeID:      id4.String(),
			showError:    true,
			sender:       sender2,
			desiredError: "is not owned by the trade creator",
		},
	}

	for name, tc := range cases {
		t.Run(name, func(t *testing.T) {

			delTrdMsg := msgs.NewMsgDisableTrade(tc.tradeID, tc.sender)
			_, err := HandlerMsgDisableTrade(tci.Ctx, tci.PlnK, delTrdMsg)
			if tc.showError == false {
				trd, _ := tci.PlnK.GetTrade(tci.Ctx, tc.tradeID)
				require.True(t, trd.Disabled)
				if trd.ItemOutputs != nil && len(trd.ItemOutputs) > 0 {
					require.True(t, trd.ItemOutputs[0].OwnerTradeID == "")
				}
			} else {
				require.True(t, err != nil)
				require.True(t, strings.Contains(err.Error(), tc.desiredError), err.Error())
			}
		})
	}

}
