package keep

import (
	"strings"
	"testing"

	"github.com/Pylons-tech/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"
)

// GenExecution generate execution
func GenExecution(sender sdk.AccAddress, tci TestCoinInput) types.Execution {
	cbData := GenCookbook(sender, "cookbook-0001", "this has to meet character limits")
	rcpData := GenRecipe(sender, cbData.ID, "new recipe", "this has to meet character limits; lol")

	var cl sdk.Coins
	for _, inp := range rcpData.CoinInputs {
		cl = append(cl, sdk.NewCoin(inp.Coin, sdk.NewInt(inp.Count)))
	}

	var inputItems []types.Item

	inputItems = append(inputItems, *GenItem(cbData.ID, sender, "Raichu"))
	inputItems = append(inputItems, *GenItem(cbData.ID, sender, "Raichu"))

	exec := types.NewExecution(
		rcpData.ID,
		cbData.ID,
		cl,
		inputItems,
		tci.Ctx.BlockHeight()+rcpData.BlockInterval,
		sender,
		false,
	)

	return exec
}

func TestKeeperSetExecution(t *testing.T) {
	tci := SetupTestCoinInput()
	sender, _, _ := SetupTestAccounts(t, tci, nil, nil, nil)

	cases := map[string]struct {
		sender       sdk.AccAddress
		desiredError string
		showError    bool
	}{
		"empty sender test": {
			sender:       nil,
			desiredError: "SetExecution: the sender cannot be empty",
			showError:    true,
		},
		"successful set execution test": {
			sender:       sender,
			desiredError: "",
			showError:    false,
		},
	}

	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			exec := GenExecution(tc.sender, tci)
			err := tci.PlnK.SetExecution(tci.Ctx, exec)

			if tc.showError {
				// t.Errorf("execution_test err LOG:: %+v", err)
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			} else {
				require.True(t, err == nil)
			}
		})
	}
}

func TestKeeperGetExecution(t *testing.T) {
	tci := SetupTestCoinInput()
	sender, _, _ := SetupTestAccounts(t, tci, nil, nil, nil)

	exec := GenExecution(sender, tci)
	err := tci.PlnK.SetExecution(tci.Ctx, exec)
	require.True(t, err == nil)

	cases := map[string]struct {
		execID       string
		desiredError string
		showError    bool
	}{
		"wrong exec id test": {
			execID:       "invalidExecID",
			desiredError: "The execution doesn't exist",
			showError:    true,
		},
		"successful get execution test": {
			execID:       exec.ID,
			desiredError: "",
			showError:    false,
		},
	}

	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			execution, err := tci.PlnK.GetExecution(tci.Ctx, tc.execID)

			if tc.showError {
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			} else {
				// t.Errorf("execution_test err LOG:: %+v", err)
				require.True(t, err == nil)
				require.True(t, execution.RecipeID == exec.RecipeID)
				require.True(t, execution.Sender.String() == exec.Sender.String())
				require.True(t, execution.Completed == exec.Completed)
			}
		})
	}
}

func TestKeeperUpdateExecution(t *testing.T) {
	tci := SetupTestCoinInput()
	sender, _, _ := SetupTestAccounts(t, tci, nil, nil, nil)

	exec := GenExecution(sender, tci)
	err := tci.PlnK.SetExecution(tci.Ctx, exec)
	require.True(t, err == nil)

	newExec := GenExecution(sender, tci)
	newExec.Completed = true

	cases := map[string]struct {
		execID       string
		desiredError string
		showError    bool
	}{
		"wrong exec id test": {
			execID:       "invalidExecID",
			desiredError: "The execution with gid invalidExecID does not exist",
			showError:    true,
		},
		"successful update execution test": {
			execID:       exec.ID,
			desiredError: "",
			showError:    false,
		},
	}

	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			err := tci.PlnK.UpdateExecution(tci.Ctx, tc.execID, newExec)

			if tc.showError {
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			} else {
				// t.Errorf("execution_test err LOG:: %+v", err)
				require.True(t, err == nil)
				uExec, err := tci.PlnK.GetExecution(tci.Ctx, tc.execID)
				require.True(t, err == nil)
				require.True(t, uExec.Completed == true)
			}
		})
	}
}

func TestKeeperGetExecutionsBySender(t *testing.T) {
	tci := SetupTestCoinInput()
	sender, sender2, _ := SetupTestAccounts(t, tci, nil, nil, nil)

	for i := 0; i < 5; i++ {
		exec := GenExecution(sender, tci)
		err := tci.PlnK.SetExecution(tci.Ctx, exec)
		require.True(t, err == nil)
	}

	for i := 0; i < 2; i++ {
		exec := GenExecution(sender2, tci)
		err := tci.PlnK.SetExecution(tci.Ctx, exec)
		require.True(t, err == nil)
	}

	exec2 := GenExecution(sender2, tci)
	err := tci.PlnK.SetExecution(tci.Ctx, exec2)
	require.True(t, err == nil)
	executions, err := tci.PlnK.GetExecutionsBySender(tci.Ctx, sender)
	require.Nil(t, err, "Error while getting executions")
	require.True(t, len(executions) == 5)
}
