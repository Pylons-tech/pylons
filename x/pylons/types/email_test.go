package types

import (
	"testing"

	"github.com/stretchr/testify/require"
)

func TestEmailValidate(t *testing.T) {

	cases := map[string]struct {
		email string
		ok    bool
	}{
		"case1": {"junkai@quiver.network", true},
		"case2": {"stalepresh121@outlook.com", true},
		"case3": {"stale presh121@outlook.com", false},
		"case4": {"stale$presh121@outlook.com", false},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			validation := Email{tc.email}.Validate()
			require.True(t, (validation == nil) == tc.ok)
		})
	}
}
