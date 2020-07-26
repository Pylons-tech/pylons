package handlers

import (
	"github.com/Pylons-tech/pylons/x/pylons/config"
	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// CheckExecutionResponse is the response for checkExecution
type CheckExecutionResponse struct {
	Message string
	Status  string
	Output  []byte
}

// ProcessCoinInputs process coin input distribution for recipe
func ProcessCoinInputs(ctx sdk.Context, keeper keep.Keeper, msgSender sdk.AccAddress, cbID string, coinInputs sdk.Coins) error {

	cookbook, err := keeper.GetCookbook(ctx, cbID)
	if err != nil {
		return err
	}

	// send coins to cookbook owner
	err = keep.SendCoins(keeper, ctx, msgSender, cookbook.Sender, coinInputs)
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
		return keep.SendCoins(keeper, ctx, cookbook.Sender, pylonsLLCAddress, types.NewPylon(pylonsLLCAmount))
	}
	return nil
}

// SafeExecute execute a msg and returns result
func SafeExecute(ctx sdk.Context, keeper keep.Keeper, exec types.Execution, msg msgs.MsgCheckExecution) ([]byte, error) {
	var outputSTR []byte

	recipe, err := keeper.GetRecipe(ctx, exec.RecipeID)
	if err != nil {
		return nil, err
	}

	err = keeper.UnlockCoin(ctx, types.NewLockedCoin(msg.Sender, exec.CoinInputs))
	if err != nil {
		return nil, err
	}

	err = ProcessCoinInputs(ctx, keeper, msg.Sender, recipe.CookbookID, exec.CoinInputs)
	if err != nil {
		return nil, err
	}

	p := ExecProcess{ctx: ctx, keeper: keeper, recipe: recipe, matchedItems: exec.ItemInputs}
	outputSTR, err = p.Run(msg.Sender)

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
func HandlerMsgCheckExecution(ctx sdk.Context, keeper keep.Keeper, msg msgs.MsgCheckExecution) (*sdk.Result, error) {

	err := msg.ValidateBasic()
	if err != nil {
		return nil, errInternal(err)
	}

	exec, err := keeper.GetExecution(ctx, msg.ExecID)
	if err != nil {
		return nil, errInternal(err)
	}

	if !msg.Sender.Equals(exec.Sender) {
		return nil, sdkerrors.Wrap(sdkerrors.ErrUnauthorized, "The current sender is different from the executor")
	}

	if exec.Completed {
		return marshalJSON(CheckExecutionResponse{
			Message: "execution already completed",
			Status:  "Completed",
		})
	}

	if ctx.BlockHeight() >= exec.BlockHeight {
		outputSTR, err := SafeExecute(ctx, keeper, exec, msg)
		if err != nil {
			return nil, errInternal(err)
		}

		return marshalJSON(CheckExecutionResponse{
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

		if keep.HasCoins(keeper, ctx, msg.Sender, pylonsToCharge) {
			_, err := keeper.CoinKeeper.SubtractCoins(ctx, msg.Sender, pylonsToCharge)
			if err != nil {
				return nil, errInternal(err)
			}

			outputSTR, err := SafeExecute(ctx, keeper, exec, msg)
			if err != nil {
				return nil, errInternal(err)
			}

			return marshalJSON(CheckExecutionResponse{
				Message: "successfully paid to complete the execution",
				Status:  "Success",
				Output:  outputSTR,
			})
		}
		return marshalJSON(CheckExecutionResponse{
			Message: "insufficient balance to complete the execution",
			Status:  "Failure",
		})

	}
	return marshalJSON(CheckExecutionResponse{
		Message: "execution pending",
		Status:  "Pending",
	})
}
