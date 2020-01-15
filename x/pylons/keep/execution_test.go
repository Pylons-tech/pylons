package keep

import (
	"strings"
	"testing"

	"github.com/Pylons-tech/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"
)

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
	mockedCoinInput := SetupTestCoinInput()

	sender, _ := sdk.AccAddressFromBech32("cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337")

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
			exec := GenExecution(tc.sender, mockedCoinInput)
			err := mockedCoinInput.PlnK.SetExecution(mockedCoinInput.Ctx, exec)

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
	mockedCoinInput := SetupTestCoinInput()

	sender, _ := sdk.AccAddressFromBech32("cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337")
	exec := GenExecution(sender, mockedCoinInput)
	mockedCoinInput.PlnK.SetExecution(mockedCoinInput.Ctx, exec)

	cases := map[string]struct {
		execId       string
		desiredError string
		showError    bool
	}{
		"wrong exec id test": {
			execId:       "invalidExecID",
			desiredError: "The execution doesn't exist",
			showError:    true,
		},
		"successful get execution test": {
			execId:       exec.ID,
			desiredError: "",
			showError:    false,
		},
	}

	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			execution, err := mockedCoinInput.PlnK.GetExecution(mockedCoinInput.Ctx, tc.execId)

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
	mockedCoinInput := SetupTestCoinInput()

	sender, _ := sdk.AccAddressFromBech32("cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337")
	exec := GenExecution(sender, mockedCoinInput)
	mockedCoinInput.PlnK.SetExecution(mockedCoinInput.Ctx, exec)
	newExec := GenExecution(sender, mockedCoinInput)
	newExec.Completed = true

	cases := map[string]struct {
		execId       string
		desiredError string
		showError    bool
	}{
		"wrong exec id test": {
			execId:       "invalidExecID",
			desiredError: "The execution with gid invalidExecID does not exist",
			showError:    true,
		},
		"successful update execution test": {
			execId:       exec.ID,
			desiredError: "",
			showError:    false,
		},
	}

	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			err := mockedCoinInput.PlnK.UpdateExecution(mockedCoinInput.Ctx, tc.execId, newExec)

			if tc.showError {
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			} else {
				// t.Errorf("execution_test err LOG:: %+v", err)
				require.True(t, err == nil)
				uExec, err2 := mockedCoinInput.PlnK.GetExecution(mockedCoinInput.Ctx, tc.execId)
				require.True(t, err2 == nil)
				require.True(t, uExec.Completed == true)
			}
		})
	}
}

func TestKeeperGetExecutionsBySender(t *testing.T) {
	mockedCoinInput := SetupTestCoinInput()
	sender, _ := sdk.AccAddressFromBech32("cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337")
	for i := 0; i < 5; i++ {
		exec := GenExecution(sender, mockedCoinInput)
		mockedCoinInput.PlnK.SetExecution(mockedCoinInput.Ctx, exec)
	}

	sender2, _ := sdk.AccAddressFromBech32("cosmos1alp8y6rmywahtmjsd9gxrfcz304s0mppujl2q6")
	for i := 0; i < 2; i++ {
		exec := GenExecution(sender2, mockedCoinInput)
		mockedCoinInput.PlnK.SetExecution(mockedCoinInput.Ctx, exec)
	}

	exec2 := GenExecution(sender2, mockedCoinInput)
	mockedCoinInput.PlnK.SetExecution(mockedCoinInput.Ctx, exec2)
	executions, err := mockedCoinInput.PlnK.GetExecutionsBySender(mockedCoinInput.Ctx, sender)
	require.Nil(t, err, "Error while getting executions")
	require.True(t, len(executions) == 5)

}
