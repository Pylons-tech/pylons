package handlers

import (
	"encoding/json"

	"github.com/MikeSofaer/pylons/x/pylons/keep"
	"github.com/MikeSofaer/pylons/x/pylons/msgs"
	"github.com/MikeSofaer/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// CheckExecutionResp is the response for executeRecipe
type CheckExecutionResp struct {
	Message string
	Status  string
}

// HandlerMsgCheckExecution is used to create cookbook by a developer
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

	if exec.BlockHeight == ctx.BlockHeight() {
		// TODO: send the coins to a master address instead of burning them
		// think about making this adding and subtracting atomic using inputoutputcoins method
		_, _, err = keeper.CoinKeeper.SubtractCoins(ctx, msg.Sender, exec.CoinInputs)
		if err != nil {
			return err.Result()
		}
		_, _, err = keeper.CoinKeeper.AddCoins(ctx, msg.Sender, exec.CoinOutputs)
		if err != nil {
			return err.Result()
		}

		// we delete all the matched items as those get converted to output items
		for _, item := range exec.ItemInputs {
			keeper.DeleteItem(ctx, item.ID)
		}

		for _, item := range exec.ItemOutputs {
			if err := keeper.SetItem(ctx, item); err != nil {
				return sdk.ErrInternal(err.Error()).Result()
			}
		}

		resp, err2 := json.Marshal(CheckExecutionResp{
			Message: "successfully completed the execution",
			Status:  "Success",
		})

		if err2 != nil {
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
