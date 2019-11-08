package intTest

import (
	"testing"

	"github.com/stretchr/testify/require"
)

func TestListRecipeViaCLI(t *testing.T) {
	// TODO if we find a way to sign using sequence number between same blocks, this wait can be removed
	WaitForNextBlock()

	tests := []struct {
		name           string
		rcpName        string
		outputItemName string
	}{
		{
			"basic flow test",
			"TESTRCP_TestListRecipe__002",
			"TESTITEM_TestListRecipe__002",
		},
	}

	for _, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			_, err := MockRecipeWithName(tc.rcpName, tc.outputItemName, t)
			ErrValidation(t, "error mocking recipe %+v", err)

			recipes, err := TestQueryListRecipe(t)
			ErrValidation(t, "error listing recipes %+v", err)

			require.True(t, err == nil)
			require.True(t, len(recipes) > 0)

			WaitForNextBlock()
			_, ok := FindRecipeFromArrayByName(recipes, tc.rcpName)
			if !ok {
				t.Errorf("error getting recipe with name %+v", tc.rcpName)
				t.Fatal()
			}
		})
	}
}
