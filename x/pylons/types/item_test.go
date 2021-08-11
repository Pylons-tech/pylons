package types

import (
	"github.com/stretchr/testify/require"
	"math"
	"testing"
)

func TestEncodeItemID(t *testing.T) {
	for _, tc := range []struct {
		desc string
		uintID  uint64
	}{
		{desc: "Valid1", uintID: 12031028235},
		{desc: "Valid2", uintID: 2341},
		{desc: "Valid3", uintID: 1},
		{desc: "Valid4", uintID: math.MaxUint64},
		{desc: "Invalid", uintID: 0}, // we will never have an ID of 0 since the first item ID will be 1
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			encoded := EncodeItemID(tc.uintID)
			decoded := DecodeItemID(encoded)
			if tc.desc == "Invalid" {
				recover()  // recover from decoding 0 in Invalid case
			} else {
				require.Equal(t, decoded, tc.uintID)
			}
		})
	}
}


