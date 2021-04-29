package handlers

import (
	"context"
	"errors"
	"fmt"
	"strings"
	"testing"

	"github.com/Pylons-tech/pylons/x/pylons/keeper"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	"github.com/google/uuid"
	"github.com/stretchr/testify/require"
)

// CreateTrade is used to create a trade by a user
func (k msgServer) CreateTrade(ctx context.Context, msg *types.MsgCreateTrade) (*types.MsgCreateTradeResponse, error) {

	err := msg.ValidateBasic()
	if err != nil {
		return nil, errInternal(err)
	}

	sdkCtx := sdk.UnwrapSDKContext(ctx)
	sender, _ := sdk.AccAddressFromBech32(msg.Sender)

	for _, tii := range msg.ItemInputs {
		_, err := k.GetCookbook(sdkCtx, tii.CookbookID)
		if err != nil {
			return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, fmt.Sprintf("You specified a cookbook that does not exist where raw error is %+v", err))
		}
	}

	for _, item := range msg.ItemOutputs {
		itemFromStore, err := k.GetItem(sdkCtx, item.ID)
		if err != nil {
			return nil, errInternal(err)
		}
		if itemFromStore.Sender != msg.Sender {
			return nil, sdkerrors.Wrap(sdkerrors.ErrUnauthorized, fmt.Sprintf("item with %s id is not owned by sender", item.ID))
		}
		if err = itemFromStore.NewTradeError(); err != nil {
			return nil, errInternal(fmt.Errorf("%s item id is not tradable", itemFromStore.ID))
		}
	}

	if !keeper.HasCoins(k.Keeper, sdkCtx, sender, msg.CoinOutputs) {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInsufficientFunds, "sender doesn't have enough coins for the trade")
	}

	err = k.LockCoin(sdkCtx, types.NewLockedCoin(sender, msg.CoinOutputs))

	if err != nil {
		return nil, errInternal(err)
	}

	trade := types.NewTrade(msg.ExtraInfo,
		msg.CoinInputs,
		msg.ItemInputs,
		msg.CoinOutputs,
		msg.ItemOutputs,
		sender)
	if err := k.SetTrade(sdkCtx, trade); err != nil {
		return nil, errInternal(err)
	}

	// set items' owner trade id
	for _, item := range msg.ItemOutputs {
		itemFromStore, err := k.GetItem(sdkCtx, item.ID)
		if err != nil {
			return nil, errInternal(err)
		}
		itemFromStore.OwnerTradeID = trade.ID
		err = k.SetItem(sdkCtx, itemFromStore)
		if err != nil {
			return nil, errInternal(err)
		}
	}

	return &types.MsgCreateTradeResponse{
		TradeID: trade.ID,
		Message: "successfully created a trade",
		Status:  "Success",
	}, nil
}

// EnableTrade is used to enable trade by a developer
func (k msgServer) EnableTrade(ctx context.Context, msg *types.MsgEnableTrade) (*types.MsgEnableTradeResponse, error) {

	err := msg.ValidateBasic()
	if err != nil {
		return nil, errInternal(err)
	}

	sdkCtx := sdk.UnwrapSDKContext(ctx)

	trade, err := k.GetTrade(sdkCtx, msg.TradeID)
	if err != nil {
		return nil, errInternal(err)
	}

	if msg.Sender != trade.Sender {
		return nil, sdkerrors.Wrap(sdkerrors.ErrUnauthorized, "Trade initiator is not the same as sender")
	}

	trade.Disabled = false

	// reset items' owner trade id
	for idx, item := range trade.ItemOutputs {
		itemFromStore, err := k.GetItem(sdkCtx, item.ID)
		if err != nil {
			return nil, errInternal(err)
		}

		if itemFromStore.Sender != trade.Sender {
			return nil, sdkerrors.Wrap(sdkerrors.ErrUnauthorized, fmt.Sprintf("Item with id %s is not owned by the trade creator", itemFromStore.ID))
		}

		if err = itemFromStore.NewTradeError(); err != nil {
			return nil, errInternal(fmt.Errorf("%s item id is not tradable", itemFromStore.ID))
		}
		itemFromStore.OwnerTradeID = trade.ID
		err = k.SetItem(sdkCtx, itemFromStore)
		if err != nil {
			return nil, errInternal(err)
		}
		trade.ItemOutputs[idx] = itemFromStore
	}

	err = k.UpdateTrade(sdkCtx, msg.TradeID, trade)
	if err != nil {
		return nil, errInternal(err)
	}

	sender, err := sdk.AccAddressFromBech32(trade.Sender)
	if err != nil {
		return nil, errInternal(err)
	}

	err = k.LockCoin(sdkCtx, types.NewLockedCoin(sender, trade.CoinOutputs))

	if err != nil {
		return nil, errInternal(err)
	}

	return &types.MsgEnableTradeResponse{
		Message: "successfully enabled the trade",
		Status:  "Success",
	}, nil
}

// DisableTrade is used to enable trade by a developer
func (k msgServer) DisableTrade(ctx context.Context, msg *types.MsgDisableTrade) (*types.MsgDisableTradeResponse, error) {

	err := msg.ValidateBasic()
	if err != nil {
		return nil, errInternal(err)
	}

	sdkCtx := sdk.UnwrapSDKContext(ctx)

	trade, err := k.GetTrade(sdkCtx, msg.TradeID)
	if err != nil {
		return nil, errInternal(err)
	}

	if msg.Sender != trade.Sender {
		return nil, sdkerrors.Wrap(sdkerrors.ErrUnauthorized, "Trade initiator is not the same as sender")
	}

	if trade.Completed && (trade.FulFiller != "") {
		return nil, errInternal(errors.New("Cannot disable a completed trade"))
	}

	trade.Disabled = true

	// unset items' owner trade id
	for idx, item := range trade.ItemOutputs {
		itemFromStore, err := k.GetItem(sdkCtx, item.ID)
		if err != nil {
			return nil, errInternal(err)
		}

		if itemFromStore.Sender != trade.Sender {
			return nil, sdkerrors.Wrap(sdkerrors.ErrUnauthorized, fmt.Sprintf("Item with id %s is not owned by the trade creator", itemFromStore.ID))
		}

		itemFromStore.OwnerTradeID = ""
		err = k.SetItem(sdkCtx, itemFromStore)
		if err != nil {
			return nil, errInternal(err)
		}
		trade.ItemOutputs[idx] = itemFromStore
	}

	err = k.UpdateTrade(sdkCtx, msg.TradeID, trade)
	if err != nil {
		return nil, errInternal(err)
	}

	sender, err := sdk.AccAddressFromBech32(trade.Sender)
	if err != nil {
		return nil, errInternal(err)
	}
	err = k.UnlockCoin(sdkCtx, types.NewLockedCoin(sender, trade.CoinOutputs))
	if err != nil {
		return nil, errInternal(err)
	}

	return &types.MsgDisableTradeResponse{
		Message: "successfully disabled the trade",
		Status:  "Success",
	}, nil
}

func TestHandlerMsgDisableTrade(t *testing.T) {
	tci := keeper.SetupTestCoinInput()
	tci.PlnH = NewMsgServerImpl(tci.PlnK)
	sender, sender2, _, _ := keeper.SetupTestAccounts(t, tci, types.NewPylon(100000), nil, nil, nil)

	err := tci.Bk.AddCoins(tci.Ctx, sender2, types.NewPylon(100000))
	require.NoError(t, err)

	id := uuid.New()
	id2 := uuid.New()
	id3 := uuid.New()
	id4 := uuid.New()

	cookbookMsg := types.NewMsgCreateCookbook(
		"cookbook-0001",
		"cookbook-id-0001",
		"this has to meet character limits",
		"SketchyCo",
		"1.0.0",
		"example@example.com",
		1,
		types.DefaultCostPerBlock,
		sender.String(),
	)
	cookbookResult, _ := tci.PlnH.CreateCookbook(sdk.WrapSDKContext(tci.Ctx), &cookbookMsg)
	require.True(t, len(cookbookResult.CookbookID) > 0)

	item := keeper.GenItem(cookbookResult.CookbookID, sender, "Raichu")
	item.OwnerTradeID = id.String()
	err = tci.PlnK.SetItem(tci.Ctx, item)
	require.NoError(t, err)

	// add trades for tests, one open trade by each sender and one closed trade
	err = tci.PlnK.SetTrade(tci.Ctx, types.Trade{
		ID:          id.String(),
		ItemInputs:  types.GenTradeItemInputList("LOUD-CB-001", []string{"Pikachu"}),
		ItemOutputs: types.ItemList{item},
		CoinOutputs: types.NewPylon(10000),
		Sender:      sender.String(),
	})
	require.NoError(t, err)

	err = tci.PlnK.SetTrade(tci.Ctx, types.Trade{
		ID:          id2.String(),
		ItemInputs:  types.GenTradeItemInputList("LOUD-CB-001", []string{"Richu"}),
		CoinOutputs: types.NewPylon(10000),
		Sender:      sender2.String(),
	})
	require.NoError(t, err)

	err = tci.PlnK.SetTrade(tci.Ctx, types.Trade{
		ID:          id3.String(),
		ItemInputs:  types.GenTradeItemInputList("LOUD-CB-001", []string{"Pichu"}),
		CoinOutputs: types.NewPylon(1000),
		Sender:      sender2.String(),
		FulFiller:   sender.String(),
		Completed:   true,
	})
	require.NoError(t, err)

	err = tci.PlnK.SetTrade(tci.Ctx, types.Trade{
		ID:          id4.String(),
		ItemInputs:  types.GenTradeItemInputList("LOUD-CB-001", []string{"Pikachu"}),
		ItemOutputs: types.ItemList{item},
		CoinOutputs: types.NewPylon(10000),
		Sender:      sender2.String(),
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

			delTrdMsg := types.NewMsgDisableTrade(tc.tradeID, tc.sender.String())
			_, err := tci.PlnH.DisableTrade(sdk.WrapSDKContext(tci.Ctx), &delTrdMsg)
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

func TestHandlerMsgEnableTrade(t *testing.T) {
	tci := keeper.SetupTestCoinInput()
	tci.PlnH = NewMsgServerImpl(tci.PlnK)
	sender, sender2, _, _ := keeper.SetupTestAccounts(t, tci, types.NewPylon(100000), nil, nil, nil)

	err := tci.Bk.AddCoins(tci.Ctx, sender2, types.NewPylon(100000))
	require.NoError(t, err)

	id := uuid.New()
	id2 := uuid.New()
	id3 := uuid.New()

	cookbookMsg := types.NewMsgCreateCookbook(
		"cookbook-0001",
		"cookbook-id-0001",
		"this has to meet character limits",
		"SketchyCo",
		"1.0.0",
		"example@example.com",
		1,
		types.DefaultCostPerBlock,
		sender.String(),
	)

	cookbookResult, _ := tci.PlnH.CreateCookbook(sdk.WrapSDKContext(tci.Ctx), &cookbookMsg)
	require.True(t, len(cookbookResult.CookbookID) > 0)

	item := keeper.GenItem(cookbookResult.CookbookID, sender, "Raichu")
	// item.OwnerTradeID = id.String()
	err = tci.PlnK.SetItem(tci.Ctx, item)
	require.NoError(t, err)

	// add 3 trades. one open trade by each sender and one closed trade
	err = tci.PlnK.SetTrade(tci.Ctx, types.Trade{
		ID:          id.String(),
		ItemInputs:  types.GenTradeItemInputList("LOUD-CB-001", []string{"Pikachu"}),
		ItemOutputs: types.ItemList{item},
		CoinOutputs: types.NewPylon(10000),
		Sender:      sender.String(),
		Disabled:    true, // we disable this trade initially
	})
	require.NoError(t, err)

	err = tci.PlnK.SetTrade(tci.Ctx, types.Trade{
		ID:          id2.String(),
		ItemInputs:  types.GenTradeItemInputList("LOUD-CB-001", []string{"Richu"}),
		CoinOutputs: types.NewPylon(10000),
		Sender:      sender2.String(),
	})
	require.NoError(t, err)

	err = tci.PlnK.SetTrade(tci.Ctx, types.Trade{
		ID:          id3.String(),
		ItemInputs:  types.GenTradeItemInputList("LOUD-CB-001", []string{"Pikachu"}),
		ItemOutputs: types.ItemList{item},
		CoinOutputs: types.NewPylon(10000),
		Sender:      sender2.String(),
		Disabled:    true, // we disable this trade initially
	})
	require.NoError(t, err)

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
		"enable wrong item id owner trade with failure": {
			tradeID:      id3.String(),
			showError:    true,
			sender:       sender2,
			desiredError: "is not owned by the trade creator",
		},
	}

	for name, tc := range cases {
		t.Run(name, func(t *testing.T) {

			delTrdMsg := types.NewMsgEnableTrade(tc.tradeID, tc.sender.String())
			_, err := tci.PlnH.EnableTrade(sdk.WrapSDKContext(tci.Ctx), &delTrdMsg)
			if tc.showError == false {
				trd, _ := tci.PlnK.GetTrade(tci.Ctx, tc.tradeID)
				require.True(t, !trd.Disabled)
				if trd.ItemOutputs != nil && len(trd.ItemOutputs) > 0 {
					require.True(t, trd.ItemOutputs[0].OwnerTradeID != "")
				}
			} else {
				require.True(t, err != nil)
				require.True(t, strings.Contains(err.Error(), tc.desiredError), err.Error())
			}
		})
	}

}
