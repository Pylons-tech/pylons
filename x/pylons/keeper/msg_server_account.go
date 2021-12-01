package keeper

import (
	"context"

	"github.com/cosmos/cosmos-sdk/telemetry"

	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"

	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (k msgServer) CreateAccount(goCtx context.Context, msg *types.MsgCreateAccount) (*types.MsgCreateAccountResponse, error) {
	ctx := sdk.UnwrapSDKContext(goCtx)

	addr, err := sdk.AccAddressFromBech32(msg.Creator)
	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "unable to derive address from bech32 string")
	}
	acc := k.accountKeeper.GetAccount(ctx, addr)
	if acc == nil {
		k.accountKeeper.NewAccountWithAddress(ctx, addr)
		defer telemetry.IncrCounter(1, "new", "account")
	}

	username := types.Username{Value: msg.Username}
	accountAddr := types.AccountAddr{Value: msg.Creator}

	b := k.cdc.MustMarshal(&username)
	fee := types.CalculateTxSizeFee(b, types.DefaultSizeLimitBytes, types.DefaultFeePerBytes)
	if fee > 0 {
		// charge fee
		coins := sdk.NewCoins(sdk.NewCoin(types.PylonsCoinDenom, sdk.NewInt(int64(fee))))
		err := k.bankKeeper.SendCoinsFromAccountToModule(ctx, addr, types.FeeCollectorName, coins)
		if err != nil {
			return nil, sdkerrors.Wrapf(sdkerrors.ErrInsufficientFunds, "unable to pay sizeOver fee of %d%s", fee, types.PylonsCoinDenom)
		}
	}

	found := k.HasUsername(ctx, username) || k.HasAccountAddr(ctx, accountAddr)
	if found {
		return nil, types.ErrDuplicateUsername
	}

	k.SetPylonsAccount(ctx, accountAddr, username)

	err = ctx.EventManager().EmitTypedEvent(&types.EventCreateAccount{
		Address:  msg.Creator,
		Username: msg.Username,
	})

	telemetry.IncrCounter(1, "account", "create")

	return &types.MsgCreateAccountResponse{}, err
}

func (k msgServer) UpdateAccount(goCtx context.Context, msg *types.MsgUpdateAccount) (*types.MsgUpdateAccountResponse, error) {
	ctx := sdk.UnwrapSDKContext(goCtx)

	addr, err := sdk.AccAddressFromBech32(msg.Creator)
	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "unable to derive address from bech32 string")
	}
	acc := k.accountKeeper.GetAccount(ctx, addr)
	if acc == nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "account not created")
	}

	username := types.Username{Value: msg.Username}
	accountAddr := types.AccountAddr{Value: msg.Creator}

	b := k.cdc.MustMarshal(&username)
	fee := types.CalculateTxSizeFee(b, types.DefaultSizeLimitBytes, types.DefaultFeePerBytes)
	if fee > 0 {
		// charge fee
		coins := sdk.NewCoins(sdk.NewCoin(types.PylonsCoinDenom, sdk.NewInt(int64(fee))))
		err := k.bankKeeper.SendCoinsFromAccountToModule(ctx, addr, types.FeeCollectorName, coins)
		if err != nil {
			return nil, sdkerrors.Wrapf(sdkerrors.ErrInsufficientFunds, "unable to pay sizeOver fee of %d%s", fee, types.PylonsCoinDenom)
		}
	}

	found := k.HasUsername(ctx, username)
	if found {
		return nil, types.ErrDuplicateUsername
	}

	k.SetPylonsAccount(ctx, accountAddr, username)

	// perform payment after update
	updateFee := k.Keeper.UpdateUsernameFee(ctx)
	err = k.PayFees(ctx, addr, sdk.NewCoins(updateFee))
	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	err = ctx.EventManager().EmitTypedEvent(&types.EventUpdateAccount{
		Address:  msg.Creator,
		Username: msg.Username,
	})

	telemetry.IncrCounter(1, "account", "update")

	return &types.MsgUpdateAccountResponse{}, err
}
