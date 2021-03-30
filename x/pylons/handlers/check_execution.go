package handlers

import (
	"context"
	"github.com/Pylons-tech/pylons/x/pylons/config"
	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// ProcessCoinInputs process coin input distribution for recipe
func ProcessCoinInputs(ctx sdk.Context, keeper keep.Keeper, msgSender sdk.AccAddress, cbID string, coinInputs sdk.Coins) error {

	cookbook, err := keeper.GetCookbook(ctx, cbID)
	if err != nil {
		return err
	}

	cookbookSender, err := sdk.AccAddressFromBech32(cookbook.Sender)
	if err != nil {
		return err
	}

	// send coins to cookbook owner
	err = keep.SendCoins(keeper, ctx, msgSender, cookbookSender, coinInputs)
	if err != nil {
		return err
	}

	// send pylon amount to PylonsLLC, validator
	pylonAmount := coinInputs.AmountOf(types.Pylon).Int64()
	if pylonAmount > 0 {
		rcpPercent := config.Config.Fee.RecipePercent
		pylonsLLCAddress, err := sdk.AccAddressFromBech32(config.Config.Validators.PylonsLLC)
		if err != nil {
			return err
		}
		// when pylon amount is 5 and rcpPercent is 10, cbOwnerAmount = 5 * 90 / 100 = 4
		cbOwnerAmount := pylonAmount * (100 - rcpPercent) / 100
		// when pylon amount is 5 and rcpPercent is 10, pylonsLLCAmount = 5 - 4 = 1
		pylonsLLCAmount := pylonAmount - cbOwnerAmount
		return keep.SendCoins(keeper, ctx, cookbookSender, pylonsLLCAddress, types.NewPylon(pylonsLLCAmount))
	}
	return nil
}

// SafeExecute execute a msg and returns result
func SafeExecute(ctx sdk.Context, keeper keep.Keeper, exec types.Execution, msg msgs.MsgCheckExecution) ([]byte, error) {
	var outputSTR []byte

	sender, _ := sdk.AccAddressFromBech32(msg.Sender)

	recipe, err := keeper.GetRecipe(ctx, exec.RecipeID)
	if err != nil {
		return nil, err
	}

	err = keeper.UnlockCoin(ctx, types.NewLockedCoin(sender, exec.CoinInputs))
	if err != nil {
		return nil, err
	}

	err = ProcessCoinInputs(ctx, keeper, sender, recipe.CookbookID, exec.CoinInputs)
	if err != nil {
		return nil, err
	}

	p := ExecProcess{ctx: ctx, keeper: keeper, recipe: recipe, matchedItems: exec.ItemInputs}
	outputSTR, err = p.Run(sender)

	if err != nil {
		return nil, err
	}
	// confirm that the execution was completed
	exec.Completed = true

	err = keeper.UpdateExecution(ctx, exec.ID, exec)
	if err != nil {
		return nil, err
	}
	return outputSTR, nil
}

// HandlerMsgCheckExecution is used to check the status of an execution
func (k msgServer) CheckExecution(ctx context.Context, msg *msgs.MsgCheckExecution) (*msgs.MsgCheckExecutionResponse, error) {

	err := msg.ValidateBasic()
	if err != nil {
		return nil, errInternal(err)
	}

	sdkCtx := sdk.UnwrapSDKContext(ctx)
	sender, _ := sdk.AccAddressFromBech32(msg.Sender)

	exec, err := k.GetExecution(sdkCtx, msg.ExecID)
	if err != nil {
		return nil, errInternal(err)
	}

	execSender, err := sdk.AccAddressFromBech32(exec.Sender)
	if !sender.Equals(execSender) {
		return nil, sdkerrors.Wrap(sdkerrors.ErrUnauthorized, "The current sender is different from the executor")
	}

	if exec.Completed {
		return &msgs.MsgCheckExecutionResponse{
			Message: "execution already completed",
			Status:  "Completed",
		}, nil
	}

	if sdkCtx.BlockHeight() >= exec.BlockHeight {
		outputSTR, err := SafeExecute(sdkCtx, k.Keeper, exec, *msg)
		if err != nil {
			return nil, errInternal(err)
		}

		return &msgs.MsgCheckExecutionResponse{
			Message: "successfully completed the execution",
			Status:  "Success",
			Output:  outputSTR,
		}, nil

	} else if msg.PayToComplete {
		recipe, err := k.GetRecipe(sdkCtx, exec.RecipeID)
		if err != nil {
			return nil, errInternal(err)
		}
		cookbook, err := k.GetCookbook(sdkCtx, recipe.CookbookID)
		if err != nil {
			return nil, errInternal(err)
		}
		blockDiff := exec.BlockHeight - sdkCtx.BlockHeight()
		if blockDiff < 0 { // check if already waited for block interval
			blockDiff = 0
		}
		pylonsToCharge := types.NewPylon(blockDiff * int64(cookbook.CostPerBlock))

		if keep.HasCoins(k.Keeper, sdkCtx, sender, pylonsToCharge) {
			err := k.CoinKeeper.SubtractCoins(sdkCtx, sender, pylonsToCharge)
			if err != nil {
				return nil, errInternal(err)
			}

			outputSTR, err := SafeExecute(sdkCtx, k.Keeper, exec, *msg)
			if err != nil {
				return nil, errInternal(err)
			}

			return &msgs.MsgCheckExecutionResponse{
				Message: "successfully paid to complete the execution",
				Status:  "Success",
				Output:  outputSTR,
			}, nil
		}
		return &msgs.MsgCheckExecutionResponse{
			Message: "insufficient balance to complete the execution",
			Status:  "Failure",
		}, nil

	}
	return &msgs.MsgCheckExecutionResponse{
		Message: "execution pending",
		Status:  "Pending",
	}, nil
}
