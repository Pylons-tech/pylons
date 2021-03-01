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
	tci.PlnH = NewMsgServerImpl(tci.PlnK)
	sender, sender2, _, _ := keep.SetupTestAccounts(t, tci, types.NewPylon(100000), nil, nil, nil)

	err := tci.Bk.AddCoins(tci.Ctx, sender2, types.NewPylon(100000))
	require.True(t, err == nil)

	id := uuid.New()
	id2 := uuid.New()
	id3 := uuid.New()
	id4 := uuid.New()

	cookbookMsg := msgs.NewMsgCreateCookbook(
		"cookbook-0001",
		"cookbook-id-0001",
		"this has to meet character limits",
		"SketchyCo",
		&types.SemVer{"1.0.0"},
		&types.Email{"example@example.com"},
		&types.Level{1},
		msgs.DefaultCostPerBlock,
		sender,
	)
	cookbookResult, _ := tci.PlnH.HandlerMsgCreateCookbook(sdk.WrapSDKContext(tci.Ctx), &cookbookMsg)
	require.True(t, len(cookbookResult.CookbookID) > 0)

	item := keep.GenItem(cookbookResult.CookbookID, sender, "Raichu")
	item.OwnerTradeID = id.String()
	err = tci.PlnK.SetItem(tci.Ctx, *item)
	require.True(t, err == nil)

	// add trades for tests, one open trade by each sender and one closed trade
	err = tci.PlnK.SetTrade(tci.Ctx, types.Trade{
		ID:          id.String(),
		ItemInputs:  types.GenTradeItemInputList("LOUD-CB-001", []string{"Pikachu"}),
		ItemOutputs: types.ItemList{List: []*types.Item{item}},
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

	err = tci.PlnK.SetTrade(tci.Ctx, types.Trade{
		ID:          id4.String(),
		ItemInputs:  types.GenTradeItemInputList("LOUD-CB-001", []string{"Pikachu"}),
		ItemOutputs: types.ItemList{List: []*types.Item{item}},
		CoinOutputs: types.NewPylon(10000),
		Sender:      sender2,
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
			_, err := tci.PlnH.HandlerMsgDisableTrade(sdk.WrapSDKContext(tci.Ctx), &delTrdMsg)
			if tc.showError == false {
				trd, _ := tci.PlnK.GetTrade(tci.Ctx, tc.tradeID)
				require.True(t, trd.Disabled)
				if trd.ItemOutputs.List != nil && len(trd.ItemOutputs.List) > 0 {
					require.True(t, trd.ItemOutputs.List[0].OwnerTradeID == "")
				}
			} else {
				require.True(t, err != nil)
				require.True(t, strings.Contains(err.Error(), tc.desiredError), err.Error())
			}
		})
	}

}
