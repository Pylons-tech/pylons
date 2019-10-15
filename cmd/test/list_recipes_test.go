package main

import (
	"testing"

	"github.com/stretchr/testify/require"
)

func TestListRecipeViaCLI(t *testing.T) {

	if testing.Short() {
		t.Skip("Skipping integration test")
	}

	err := MockCookbook(t)
	if err != nil {
		t.Errorf("error mocking cookbook %+v", err)
		t.Fatal(err)
	}
	err = MockRecipe(t)
	if err != nil {
		t.Errorf("error mocking recipe %+v", err)
		t.Fatal(err)
	}

	tests := []struct {
		name string
	}{
		{
			"basic flow test",
		},
	}

	for _, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			recipes, err := TestQueryListRecipe(t)
			if err != nil {
				t.Errorf("error listing recipes %+v", err)
				t.Fatal(err)
			}
			require.True(t, err == nil)
			require.True(t, len(recipes) > 0)
		})
	}
}
