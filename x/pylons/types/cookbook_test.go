package types

import (
	"testing"

	"github.com/stretchr/testify/require"
)

func TestValidateTier(t *testing.T) {
	for _, tc := range []struct {
		desc string
		tier int64
		err  error
	}{
		{desc: "BasicTier", tier: Basic},
		{desc: "PremiumTier", tier: Premium},
		{desc: "InvalidTier", tier: 2, err: ErrInvalidRequestField},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			err := ValidateTier(tc.tier)
			if tc.err != nil {
				require.ErrorIs(t, err, tc.err)
			} else {
				require.NoError(t, err)
			}
		})
	}
}
