package inttest

import (
	originT "testing"

	testing "github.com/Pylons-tech/pylons_sdk/cmd/evtesting"
	inttestSDK "github.com/Pylons-tech/pylons_sdk/cmd/test_utils"
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
			if err != nil {
				t.WithFields(testing.Fields{
					"error": err,
				}).Fatal("error mocking recipe")
			}

			recipes, err := inttestSDK.ListRecipesViaCLI("")
			t.MustNil(err, "error listing recipes")
			t.MustTrue(len(recipes) > 0, "there should be at least 1 recipe")

			WaitOneBlockWithErrorCheck(t)

			_, ok := inttestSDK.FindRecipeFromArrayByName(recipes, tc.rcpName)
			if !ok {
				t.WithFields(testing.Fields{
					"recipe_name": tc.rcpName,
				}).Fatal("error getting recipe from name")
			}
		})
	}
}
