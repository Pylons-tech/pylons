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

// HandlerMsgCheckExecution is used to check the status of an execution
func HandlerMsgCheckExecution(ctx sdk.Context, keeper keep.Keeper, msg msgs.MsgCheckExecution) sdk.Result {
	var exec types.Execution
	err := msg.ValidateBasic()
	if err != nil {
		return err.Result()
	}

	exec, err2 := keeper.GetExecution(ctx, msg.ExecID)
	if err2 != nil {
		return sdk.ErrInternal(err2.Error()).Result()
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
			return sdk.ErrInternal(err2.Error()).Result()

		}
		return sdk.Result{Data: resp}
	}

	if ctx.BlockHeight() >= exec.BlockHeight {
		// TODO: send the coins to a master address instead of burning them
		// think about making this adding and subtracting atomic using inputoutputcoins method
		_, _, err = keeper.CoinKeeper.SubtractCoins(ctx, msg.Sender, exec.CoinInputs)
		if err != nil {
			return err.Result()
		}

		// we delete all the matched items as those get converted to output items
		for _, item := range exec.ItemInputs {
			keeper.DeleteItem(ctx, item.ID)
		}

		output := exec.Entries.Actualize()
		err = AddExecutedResult(ctx, keeper, output, msg.Sender, exec.CookbookID)

		if err != nil {
			return err.Result()
		}

		outputSTR, err2 := json.Marshal(output)

		if err2 != nil {
			return sdk.ErrInternal(err2.Error()).Result()
		}

		resp, err3 := json.Marshal(CheckExecutionResp{
			Message: "successfully completed the execution",
			Status:  "Success",
			Output:  outputSTR,
		})

		if err3 != nil {
			return sdk.ErrInternal(err2.Error()).Result()
		}

		// confirm that the execution was completed
		exec.Completed = true

		err2 = keeper.UpdateExecution(ctx, exec.ID, exec)
		if err2 != nil {
			return sdk.ErrInternal(err2.Error()).Result()
		}
		return sdk.Result{Data: resp}

	} else if msg.PayToComplete {
		recipe, err := keeper.GetRecipe(ctx, exec.RecipeID)
		if err != nil {
			return sdk.ErrInternal(err.Error()).Result()
		}
		cookbook, err := keeper.GetCookbook(ctx, recipe.CookbookId)
		if err != nil {
			return sdk.ErrInternal(err.Error()).Result()
		}
		blockDiff := exec.BlockHeight - ctx.BlockHeight()
		pylonsToCharge := types.NewPylon(blockDiff * int64(cookbook.CostPerBlock))

		if keeper.CoinKeeper.HasCoins(ctx, msg.Sender, pylonsToCharge) {
			_, _, err := keeper.CoinKeeper.SubtractCoins(ctx, msg.Sender, pylonsToCharge)

			if err != nil {
				return sdk.ErrInternal(err2.Error()).Result()
			}

			// confirm that the execution was completed
			exec.Completed = true

			err2 := keeper.UpdateExecution(ctx, exec.ID, exec)
			if err2 != nil {
				return sdk.ErrInternal(err2.Error()).Result()

			}

			resp, err2 := json.Marshal(CheckExecutionResp{
				Message: "successfully paid to complete the execution",
				Status:  "Success",
			})

			if err2 != nil {
				return sdk.ErrInternal(err2.Error()).Result()

			}

			return sdk.Result{Data: resp}

		}
		resp, err := json.Marshal(CheckExecutionResp{
			Message: "insufficient balance to complete the execution",
			Status:  "Failure",
		})

		if err != nil {
			return sdk.ErrInternal(err2.Error()).Result()
		}
		return sdk.Result{Data: resp}

	}
	resp, err2 := json.Marshal(CheckExecutionResp{
		Message: "execution pending",
		Status:  "Pending",
	})

	if err2 != nil {
		return sdk.ErrInternal(err2.Error()).Result()

	}
	return sdk.Result{Data: resp}

}
