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
		defer telemetry.IncrCounter(1, "new", "account")
		k.accountKeeper.SetAccount(ctx, k.accountKeeper.NewAccountWithAddress(ctx, addr))
	}

	// set the username in the store
	pylonsAccount := types.PylonsAccount{
		Account: msg.Creator,
		Username:    msg.Username,
	}

	_, found := k.GetPylonsAccount(ctx, msg.Username)
	if found {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "username already taken")
	}

	k.SetPylonsAccount(ctx, pylonsAccount)

	err = ctx.EventManager().EmitTypedEvent(&types.EventCreateAccount{
		Address:  addr.String(),
		Username: msg.Username,
	})

	return &types.MsgCreateAccountResponse{}, err
}
