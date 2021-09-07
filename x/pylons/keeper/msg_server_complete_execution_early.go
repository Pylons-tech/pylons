package keeper

import (
	"context"
	"strconv"
	"strings"

	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"

	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (k msgServer) CompleteExecutionEarly(goCtx context.Context, msg *types.MsgCompleteExecutionEarly) (*types.MsgCompleteExecutionEarlyResponse, error) {
	ctx := sdk.UnwrapSDKContext(goCtx)

	if !k.HasPendingExecution(ctx, msg.ID) {
		return nil, sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, "Cannot find a pending execution with ID %v", msg.ID)
	}

	pendingExecution := k.GetPendingExecution(ctx, msg.ID)
	cookbook, _ := k.GetCookbook(ctx, pendingExecution.CookbookID)
	executionIDSplit := strings.Split(pendingExecution.ID, "-")
	targetBlockHeight, _ := strconv.ParseInt(executionIDSplit[0], 10, 64)
	completeEarlyAmt := cookbook.CostPerBlock.Amount.Mul(sdk.NewInt(targetBlockHeight - ctx.BlockHeight()))
	completeEarlyCoin := sdk.NewCoin(cookbook.CostPerBlock.Denom, completeEarlyAmt)

	addr, _ := sdk.AccAddressFromBech32(msg.Creator)
	err := k.LockCoinsForExecution(ctx, addr, sdk.NewCoins(completeEarlyCoin))
	if err != nil {
		return nil, err
	}

	pendingExecution.CoinInputs = pendingExecution.CoinInputs.Add(completeEarlyCoin)
	id := k.UpdatePendingExecutionWithTargetBlockHeight(ctx, pendingExecution, ctx.BlockHeight())

	err = ctx.EventManager().EmitTypedEvent(&types.EventCompleteExecutionEarly{
		Creator: cookbook.Creator,
		ID:      cookbook.ID,
	})

	return &types.MsgCompleteExecutionEarlyResponse{ID: id}, err
}
