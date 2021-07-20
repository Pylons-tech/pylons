package handlers

import (
	"context"
	"encoding/json"
	"errors"

	"github.com/Pylons-tech/pylons/x/pylons/config"
	"github.com/Pylons-tech/pylons/x/pylons/keeper"
	"github.com/Pylons-tech/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	"github.com/stripe/stripe-go"
	"github.com/stripe/stripe-go/paymentintent"
)

// SafeExecute execute a msg and returns result
func SafeExecute(ctx sdk.Context, keeper keeper.Keeper, exec types.Execution, msg types.MsgCheckExecution) ([]byte, error) {
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

// ExecuteRecipe is used to execute a recipe
func (k msgServer) ExecuteRecipe(ctx context.Context, msg *types.MsgExecuteRecipe) (*types.MsgExecuteRecipeResponse, error) {
	err := msg.ValidateBasic()
	if err != nil {
		return nil, errInternal(err)
	}

	sdkCtx := sdk.UnwrapSDKContext(ctx)
	sender, _ := sdk.AccAddressFromBech32(msg.Sender)

	recipe, err := k.GetRecipe(sdkCtx, msg.RecipeID)
	if err != nil {
		return nil, errInternal(err)
	}

	p := ExecProcess{ctx: sdkCtx, keeper: k.Keeper, recipe: recipe}
	var cl sdk.Coins
	var isStripePayment = false
	for _, inp := range recipe.CoinInputs {

		if inp.Coin == config.Config.StripeConfig.Currency {

			stripeSecKeyBytes := string(config.Config.StripeConfig.StripeSecretKey)
			stripe.Key = stripeSecKeyBytes

			if msg.PaymentId == "" {
				return nil, sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, "no paymentId error!")
			}
			payIntentResult, _ := paymentintent.Get(
				msg.PaymentId,
				nil,
			)
			if payIntentResult.Status != "succeeded" {
				return nil, sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, "Stripe for Payment succeeded error!")
			}

			if inp.Count != payIntentResult.Amount/100 {
				return nil, sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, "Stripe for Payment error!")
			}
			if k.HasPaymentForStripe(sdkCtx, msg.PaymentId) {
				return nil, sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, "payment id for Stripe is already being used")
			}

			// Register paymentId for Stripe before giving coins
			err = k.RegisterPaymentForStripe(sdkCtx, msg.PaymentId)

			if err != nil {
				return nil, sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, "error registering payment id for Stripe")
			}
			isStripePayment = true
			cl = append(cl, sdk.NewCoin(inp.Coin, sdk.NewInt(inp.Count)))
		} else {
			cl = append(cl, sdk.NewCoin(inp.Coin, sdk.NewInt(inp.Count)))
		}
	}

	err = p.SetMatchedItemsFromExecMsg(sdkCtx, msg)
	if err != nil {
		return nil, errInternal(err)
	}

	// we set the inputs and outputs for storing the execution
	if recipe.BlockInterval > 0 {
		// set matchedItem's owner recipe
		var rcpOwnMatchedItems []types.Item
		for _, item := range p.matchedItems {
			item.OwnerRecipeID = recipe.ID
			if err := k.SetItem(sdkCtx, item); err != nil {
				return nil, errInternal(errors.New("error updating item's owner recipe"))
			}
			rcpOwnMatchedItems = append(rcpOwnMatchedItems, item)
		}

		if isStripePayment == false {
			err = k.LockCoin(sdkCtx, types.NewLockedCoin(sender, types.CoinInputList(recipe.CoinInputs).ToCoins()))
			if err != nil {
				return nil, errInternal(err)
			}
		}

		// store the execution as the interval
		exec := types.NewExecution(recipe.ID, recipe.CookbookID, cl, rcpOwnMatchedItems,
			sdkCtx.BlockHeight()+recipe.BlockInterval, sender, false)
		err := k.SetExecution(sdkCtx, exec)

		if err != nil {
			return nil, errInternal(err)
		}
		outputSTR, err := json.Marshal(types.ExecuteRecipeScheduleOutput{
			ExecID: exec.ID,
		})
		if err != nil {
			return nil, errInternal(err)
		}
		return &types.MsgExecuteRecipeResponse{
			Message: "scheduled the recipe",
			Status:  "Success",
			Output:  outputSTR,
		}, nil
	}

	if isStripePayment == false {
		if !keeper.HasCoins(k.Keeper, sdkCtx, sender, cl) {
			return nil, errInternal(errors.New("insufficient coin balance"))
		}

		err = ProcessCoinInputs(sdkCtx, k.Keeper, sender, recipe.CookbookID, cl)
		if err != nil {
			return nil, errInternal(err)
		}
	}

	outputSTR, err := p.Run(sender)
	if err != nil {
		return nil, errInternal(err)
	}

	return &types.MsgExecuteRecipeResponse{
		Message: "successfully executed the recipe",
		Status:  "Success",
		Output:  outputSTR,
	}, nil
}

// ProcessCoinInputs process coin input distribution for recipe
func ProcessCoinInputs(ctx sdk.Context, k keeper.Keeper, msgSender sdk.AccAddress, cbID string, coinInputs sdk.Coins) error {

	cookbook, err := k.GetCookbook(ctx, cbID)
	if err != nil {
		return err
	}

	cookbookSender, err := sdk.AccAddressFromBech32(cookbook.Sender)
	if err != nil {
		return err
	}

	// send coins to cookbook owner
	err = keeper.SendCoins(k, ctx, msgSender, cookbookSender, coinInputs)
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
		return keeper.SendCoins(k, ctx, cookbookSender, pylonsLLCAddress, types.NewPylon(pylonsLLCAmount))
	}
	return nil
}

// HandlerMsgCheckExecution is used to check the status of an execution
func (srv msgServer) CheckExecution(ctx context.Context, msg *types.MsgCheckExecution) (*types.MsgCheckExecutionResponse, error) {

	err := msg.ValidateBasic()
	if err != nil {
		return nil, errInternal(err)
	}

	sdkCtx := sdk.UnwrapSDKContext(ctx)
	sender, _ := sdk.AccAddressFromBech32(msg.Sender)

	exec, err := srv.GetExecution(sdkCtx, msg.ExecID)
	if err != nil {
		return nil, errInternal(err)
	}

	execSender, err := sdk.AccAddressFromBech32(exec.Sender)
	if err != nil {
		return nil, errInternal(err)
	}

	if !sender.Equals(execSender) {
		return nil, sdkerrors.Wrap(sdkerrors.ErrUnauthorized, "The current sender is different from the executor")
	}

	if exec.Completed {
		return &types.MsgCheckExecutionResponse{
			Message: "execution already completed",
			Status:  "Completed",
		}, nil
	}

	if sdkCtx.BlockHeight() >= exec.BlockHeight {
		outputSTR, err := SafeExecute(sdkCtx, srv.Keeper, exec, *msg)
		if err != nil {
			return nil, errInternal(err)
		}

		return &types.MsgCheckExecutionResponse{
			Message: "successfully completed the execution",
			Status:  "Success",
			Output:  outputSTR,
		}, nil

	} else if msg.PayToComplete {
		recipe, err := srv.GetRecipe(sdkCtx, exec.RecipeID)
		if err != nil {
			return nil, errInternal(err)
		}
		cookbook, err := srv.GetCookbook(sdkCtx, recipe.CookbookID)
		if err != nil {
			return nil, errInternal(err)
		}
		blockDiff := exec.BlockHeight - sdkCtx.BlockHeight()
		if blockDiff < 0 { // check if already waited for block interval
			blockDiff = 0
		}
		pylonsToCharge := types.NewPylon(blockDiff * cookbook.CostPerBlock)

		if keeper.HasCoins(srv.Keeper, sdkCtx, sender, pylonsToCharge) {
			err := srv.CoinKeeper.SubtractCoins(sdkCtx, sender, pylonsToCharge)
			if err != nil {
				return nil, errInternal(err)
			}

			outputSTR, err := SafeExecute(sdkCtx, srv.Keeper, exec, *msg)
			if err != nil {
				return nil, errInternal(err)
			}

			return &types.MsgCheckExecutionResponse{
				Message: "successfully paid to complete the execution",
				Status:  "Success",
				Output:  outputSTR,
			}, nil
		}
		return &types.MsgCheckExecutionResponse{
			Message: "insufficient balance to complete the execution",
			Status:  "Failure",
		}, nil

	}
	return &types.MsgCheckExecutionResponse{
		Message: "execution pending",
		Status:  "Pending",
	}, nil
}
