package keeper

// tx.EndBlocker
// foreach pe in PendingExecutions
//    retrieve matching recipe
//    if pe.blocHeight + recipe.BlockInterval is equal to current blockHeight
//       append from list of PendingExecutions to complete
// complete PendingExecutions

// func CompletePendingExecution
//    Unlock coins
//    "Run"
//			GenerateCelEnvVarFromInputItems()
//          Actualize values for both ItemOutput and ItemModifyOutput
//          Mint Items or Modify existing with the computed value
//	  send coins owed

// we should add a message CompleteExecutionEarly that can be called on pendingExecutions
//     compute the cost to pay as remaining blocks*cookbook.costPerBlock
//     distribute payments
// 	   change pendingExecution.blockHeight so that when summed to recipe.BlockInterval it gives the current block

// 2 moduleAccounts "PylonsFeeAccount", "LockedCoinsAccount"
