package handlers

import (
	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// CheckExecutionResp is the response for checkExecution
type CheckExecutionResp struct {
	Message string
	Status  string
	Output  []byte
}

// SafeExecute execute a msg and returns result
func SafeExecute(ctx sdk.Context, keeper keep.Keeper, exec types.Execution, msg msgs.MsgCheckExecution) ([]byte, error) {
	// TODO: send the coins to a master address instead of burning them
	// think about making this adding and subtracting atomic using inputoutputcoins method
	var outputSTR []byte
	_, err := keeper.CoinKeeper.SubtractCoins(ctx, msg.Sender, exec.CoinInputs)
	if err != nil {
		return nil, err
	}

	recipe, err2 := keeper.GetRecipe(ctx, exec.RecipeID)
	if err2 != nil {
		return nil, err2
	}

	p := ExecProcess{ctx: ctx, keeper: keeper, recipe: recipe, matchedItems: exec.ItemInputs}
	outputSTR, err2 = p.Run(msg.Sender)

	if err2 != nil {
		return nil, err2
	}
	// confirm that the execution was completed
	exec.Completed = true

	err2 = keeper.UpdateExecution(ctx, exec.ID, exec)
	if err2 != nil {
		return nil, err2
	}
	return outputSTR, nil
}

// HandlerMsgCheckExecution is used to check the status of an execution
func HandlerMsgCheckExecution(ctx sdk.Context, keeper keep.Keeper, msg msgs.MsgCheckExecution) (*sdk.Result, error) {

	err := msg.ValidateBasic()
	if err != nil {
		return nil, errInternal(err)
	}

	exec, err2 := keeper.GetExecution(ctx, msg.ExecID)
	if err2 != nil {
		return nil, errInternal(err2)
	}

	if !msg.Sender.Equals(exec.Sender) {
		return nil, sdkerrors.Wrap(sdkerrors.ErrUnauthorized, "The current sender is different from the executor")
	}

	if exec.Completed {
		return marshalJSON(CheckExecutionResp{
			Message: "execution already completed",
			Status:  "Completed",
		})
	}

	if ctx.BlockHeight() >= exec.BlockHeight {
		outputSTR, err := SafeExecute(ctx, keeper, exec, msg)
		if err != nil {
			return nil, errInternal(err2)
		}

		return marshalJSON(CheckExecutionResp{
			Message: "successfully completed the execution",
			Status:  "Success",
			Output:  outputSTR,
		})
	} else if msg.PayToComplete {
		recipe, err := keeper.GetRecipe(ctx, exec.RecipeID)
		if err != nil {
			return nil, errInternal(err)
		}
		cookbook, err := keeper.GetCookbook(ctx, recipe.CookbookID)
		if err != nil {
			return nil, errInternal(err)
		}
		blockDiff := exec.BlockHeight - ctx.BlockHeight()
		if blockDiff < 0 { // check if already waited for block interval
			blockDiff = 0
		}
		pylonsToCharge := types.NewPylon(blockDiff * int64(cookbook.CostPerBlock))

		if keeper.CoinKeeper.HasCoins(ctx, msg.Sender, pylonsToCharge) {
			_, err := keeper.CoinKeeper.SubtractCoins(ctx, msg.Sender, pylonsToCharge)
			if err != nil {
				return nil, errInternal(err2)
			}

			outputSTR, err2 := SafeExecute(ctx, keeper, exec, msg)
			if err2 != nil {
				return nil, errInternal(err2)
			}

			return marshalJSON(CheckExecutionResp{
				Message: "successfully paid to complete the execution",
				Status:  "Success",
				Output:  outputSTR,
			})
		}
		return marshalJSON(CheckExecutionResp{
			Message: "insufficient balance to complete the execution",
			Status:  "Failure",
		})

	}
	return marshalJSON(CheckExecutionResp{
		Message: "execution pending",
		Status:  "Pending",
	})
}
