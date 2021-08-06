package keeper

import (
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// func CompletePendingExecution
//    Unlock coins
//    "Run"
//			GenerateCelEnvVarFromInputItems()
//          Actualize values for both ItemOutput and ItemModifyOutput
//          Mint Items or Modify existing with the computed value
//	  send coins owed

// CompletePendingExecution
func (k Keeper) CompletePendingExecution(ctx sdk.Context, pendingExecution types.Execution, recipe types.Recipe) error {


	// TODO unlock the locked coins and perform payment


	return nil
}

// we should add a message CompleteExecutionEarly that can be called on pendingExecutions
//     compute the cost to pay as remaining blocks*cookbook.costPerBlock
//     distribute payments
// 	   change pendingExecution.blockHeight so that when summed to recipe.BlockInterval it gives the current block

// 2 moduleAccounts "PylonsFeeAccount", "LockedCoinsAccount"
