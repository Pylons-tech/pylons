package handlers

import (
	"encoding/json"

	"github.com/MikeSofaer/pylons/x/pylons/keep"
	"github.com/MikeSofaer/pylons/x/pylons/msgs"
	"github.com/MikeSofaer/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// CheckExecutionResp is the response for checkExecution
type CheckExecutionResp struct {
	Message string
	Status  string
	Output  []byte
}

func SafeExecute(ctx sdk.Context, keeper keep.Keeper, exec types.Execution, msg msgs.MsgCheckExecution) ([]byte, error) {
	// TODO: send the coins to a master address instead of burning them
	// think about making this adding and subtracting atomic using inputoutputcoins method
	var outputSTR []byte
	_, _, err := keeper.CoinKeeper.SubtractCoins(ctx, msg.Sender, exec.CoinInputs)
	if err != nil {
		return nil, err
	}

	recipe, err2 := keeper.GetRecipe(ctx, exec.RecipeID)
	if err2 != nil {
		return nil, err2
	}

	if recipe.RType == types.GENERATION {
		outputSTR, err2 = GenerateItemFromRecipe(ctx, keeper, msg.Sender, exec.CookbookID, exec.ItemInputs, recipe.Entries)

		if err2 != nil {
			return nil, err2
		}
	} else {
		if len(exec.ItemInputs) != 1 {
			return nil, sdk.ErrInternal("item inputs shouldn't be 0 or more than one for upgrade recipe")
		}

		targetItem := exec.ItemInputs[0]
		targetItem, err := UpdateItemFromUpgradeParams(targetItem, recipe.ToUpgrade)

		if err != nil {
			return nil, err
		}

		if err := keeper.SetItem(ctx, targetItem); err != nil {
			return nil, err
		}
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
func HandlerMsgCheckExecution(ctx sdk.Context, keeper keep.Keeper, msg msgs.MsgCheckExecution) sdk.Result {
	err := msg.ValidateBasic()
	if err != nil {
		return err.Result()
	}

	exec, err2 := keeper.GetExecution(ctx, msg.ExecID)
	if err2 != nil {
		return errInternal(err2)
	}

	if !msg.Sender.Equals(exec.Sender) {
		return sdk.ErrUnauthorized("The current sender is different from the executor").Result()
	}

	if exec.Completed {
		resp, err2 := json.Marshal(CheckExecutionResp{
			Message: "execution already completed",
			Status:  "Completed",
		})

		if err2 != nil {
			return errInternal(err2)
		}
		return sdk.Result{Data: resp}
	}

	if ctx.BlockHeight() >= exec.BlockHeight {
		outputSTR, err := SafeExecute(ctx, keeper, exec, msg)
		if err != nil {
			return errInternal(err2)
		}

		resp, err3 := json.Marshal(CheckExecutionResp{
			Message: "successfully completed the execution",
			Status:  "Success",
			Output:  outputSTR,
		})
		if err3 != nil {
			return errInternal(err2)
		}

		return sdk.Result{Data: resp}

	} else if msg.PayToComplete {
		recipe, err := keeper.GetRecipe(ctx, exec.RecipeID)
		if err != nil {
			return errInternal(err)
		}
		cookbook, err := keeper.GetCookbook(ctx, recipe.CookbookID)
		if err != nil {
			return errInternal(err)
		}
		blockDiff := exec.BlockHeight - ctx.BlockHeight()
		if blockDiff < 0 { // check if already waited for block interval
			blockDiff = 0
		}
		pylonsToCharge := types.NewPylon(blockDiff * int64(cookbook.CostPerBlock))

		if keeper.CoinKeeper.HasCoins(ctx, msg.Sender, pylonsToCharge) {
			_, _, err := keeper.CoinKeeper.SubtractCoins(ctx, msg.Sender, pylonsToCharge)
			if err != nil {
				return errInternal(err2)
			}

			outputSTR, err2 := SafeExecute(ctx, keeper, exec, msg)
			if err2 != nil {
				return errInternal(err2)
			}

			resp, err2 := json.Marshal(CheckExecutionResp{
				Message: "successfully paid to complete the execution",
				Status:  "Success",
				Output:  outputSTR,
			})
			if err2 != nil {
				return errInternal(err2)
			}

			return sdk.Result{Data: resp}
		}
		resp, err := json.Marshal(CheckExecutionResp{
			Message: "insufficient balance to complete the execution",
			Status:  "Failure",
		})

		if err != nil {
			return errInternal(err2)
		}
		return sdk.Result{Data: resp}

	}
	resp, err2 := json.Marshal(CheckExecutionResp{
		Message: "execution pending",
		Status:  "Pending",
	})

	if err2 != nil {
		return errInternal(err2)
	}
	return sdk.Result{Data: resp}

}
