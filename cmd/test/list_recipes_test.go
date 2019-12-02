package intTest

import (
	originTesting "testing"

	testing "github.com/MikeSofaer/pylons/cmd/fixtures_test/evtesting"
)

func TestListRecipeViaCLI(originT *originTesting.T) {
	t := testing.NewT(originT)
	t.Parallel()

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

			t.MustTrue(err == nil)
			t.MustTrue(len(recipes) > 0)

			WaitForNextBlock()
			_, ok := FindRecipeFromArrayByName(recipes, tc.rcpName)
			if !ok {
				t.Fatalf("error getting recipe with name %+v", tc.rcpName)
			}
		})
	}
}
