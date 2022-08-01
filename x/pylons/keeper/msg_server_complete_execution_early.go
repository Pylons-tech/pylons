package keeper

import (
	"context"
	"strconv"
	"strings"

	"github.com/Pylons-tech/pylons/x/pylons/types/v1beta1"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

func (k msgServer) CompleteExecutionEarly(goCtx context.Context, msg *v1beta1.MsgCompleteExecutionEarly) (*v1beta1.MsgCompleteExecutionEarlyResponse, error) {
	ctx := sdk.UnwrapSDKContext(goCtx)

	if !k.HasPendingExecution(ctx, msg.Id) {
		return nil, sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, "Cannot find a pending execution with ID %v", msg.Id)
	}

	pendingExecution := k.GetPendingExecution(ctx, msg.Id)
	cookbook, _ := k.GetCookbook(ctx, pendingExecution.CookbookId)
	recipe, _ := k.GetRecipe(ctx, pendingExecution.CookbookId, pendingExecution.RecipeId)
	executionIDSplit := strings.Split(pendingExecution.Id, "-")
	targetBlockHeight, _ := strconv.ParseInt(executionIDSplit[0], 10, 64)
	completeEarlyAmt := recipe.CostPerBlock.Amount.Mul(sdk.NewInt(targetBlockHeight - ctx.BlockHeight()))
	completeEarlyCoin := sdk.NewCoin(recipe.CostPerBlock.Denom, completeEarlyAmt)

	addr, _ := sdk.AccAddressFromBech32(msg.Creator)
	err := k.LockCoinsForExecution(ctx, addr, sdk.NewCoins(completeEarlyCoin))
	if err != nil {
		return nil, err
	}

	pendingExecution.CoinInputs = pendingExecution.CoinInputs.Add(completeEarlyCoin)
	id := k.UpdatePendingExecutionWithTargetBlockHeight(ctx, pendingExecution, ctx.BlockHeight())

	err = ctx.EventManager().EmitTypedEvent(&v1beta1.EventCompleteExecutionEarly{
		Creator: cookbook.Creator,
		Id:      cookbook.Id,
	})

	return &v1beta1.MsgCompleteExecutionEarlyResponse{Id: id}, err
}
