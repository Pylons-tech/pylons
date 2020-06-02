package intTest

import (
	originT "testing"

	testing "github.com/Pylons-tech/pylons_sdk/cmd/fixtures_test/evtesting"
	intTestSDK "github.com/Pylons-tech/pylons_sdk/cmd/test"
)

func TestListRecipeViaCLI(originT *originT.T) {
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
			_, err := MockNoDelayItemGenRecipeGUID(tc.rcpName, tc.outputItemName, t)
			intTestSDK.ErrValidation(t, "error mocking recipe %+v", err)

			recipes, err := intTestSDK.TestQueryListRecipe(t)
			intTestSDK.ErrValidation(t, "error listing recipes %+v", err)

			t.MustNil(err)
			t.MustTrue(len(recipes) > 0)

			intTestSDK.WaitForNextBlock()
			_, ok := intTestSDK.FindRecipeFromArrayByName(recipes, tc.rcpName)
			if !ok {
				t.Fatalf("error getting recipe with name %+v", tc.rcpName)
			}
		})
	}
}
