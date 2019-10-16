package main

import (
	"testing"

	"github.com/stretchr/testify/require"
)

func TestListRecipeViaCLI(t *testing.T) {
	// TODO if we find a way to sign using sequence number between same blocks, this wait can be removed
	WaitForNextBlock()

	err := MockCookbook(t)
	if err != nil {
		t.Errorf("error mocking cookbook %+v", err)
		t.Fatal(err)
	}

	tests := []struct {
		name    string
		rcpName string
	}{
		{
			"basic flow test",
			"TESTRCP_TestListRecipe__001",
		},
	}

	for _, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			err = MockRecipeWithName(tc.rcpName, t)
			if err != nil {
				t.Errorf("error mocking recipe %+v", err)
				t.Fatal(err)
			}

			recipes, err := TestQueryListRecipe(t)
			if err != nil {
				t.Errorf("error listing recipes %+v", err)
				t.Fatal(err)
			}

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
