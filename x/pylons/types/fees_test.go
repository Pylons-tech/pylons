package types

import (
	"github.com/stretchr/testify/require"
	"testing"
)

// TODO add test

func TestCalculateTxSizeFeeCookbook(t *testing.T) {
	for _, tc := range []struct {
		desc   string
		cookbook Cookbook
		fee int
	}{
		{desc: "1",
			cookbook: Cookbook{
				Creator:      "oaiwjeoaiwhfoiwaifj",
				ID:           "awefioajwefaoiwefjawoifj",
				NodeVersion:  0,
				Name:         "asfawoifawjefawifoawefjiawe",
				Description:  "awefoijawfoiajwfoijawoeif",
				Developer:    "aawoiefjawoijfawiof",
				Version:      "v0.2.1",
				SupportEmail: "asfasf@oaisjfaosif.mail",
				Enabled:      false,
			},
			fee: 0},
		{desc: "2",
			cookbook: Cookbook{
				Creator:      "oaiwjeoaiwhfoiwaifj",
				ID:           "awefioajwefaoiwefjawoifj",
				NodeVersion:  0,
				Name:         "asfawoifawjefawifoawefjiawe",
				Description:  "awefoijawfoiajwfoijawoeif",
				Developer:    "aawoiefjawoijfawiof",
				Version:      "v0.2.1",
				SupportEmail: "asfasf@oaisjfaosif.mail",
				Enabled:      false,
			},
			fee: 0},
			{desc: "zero",
				cookbook: Cookbook{
					Creator:      "oaiwjeoaiwhfoiwaifj",
					ID:           "awefioajwefaoiwefjawoifj",
					NodeVersion:  0,
					Name:         "asfawoifawjefawifoawefjiawe",
					Description:  "awefoijawfoiajwfoijawoeif",
					Developer:    "aawoiefjawoijfawiof",
					Version:      "v0.2.1",
					SupportEmail: "asfasf@oaisjfaosif.mail",
					Enabled:      false,
				},
				fee: 0},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			b :=
			if tc.desc == "Invalid" {
				recover() // recover from decoding 0 in Invalid case
			} else {
				require.Equal(t, decoded, tc.uintID)
			}
		})
	}
}
