package types

import (
	"errors"
	"fmt"
	"math"
	"testing"

	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/stretchr/testify/require"
)

func TestEncodeItemID(t *testing.T) {
	for _, tc := range []struct {
		desc   string
		uintID uint64
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
				recover() // recover from decoding 0 in Invalid case
			} else {
				require.Equal(t, decoded, tc.uintID)
			}
		})
	}
}

func TestFindValidPaymentsPermutation(t *testing.T) {
	// item0's TransferFees: {"coin0", 10}, {"coin1", 10}, {"coin2", 10}
	// item1's TransferFees: {"coin2", 4}, {"coin3", 5}, {"coin4", 6}
	// item2's TransferFees: {"coin0", 4}, {"coin4", 5}, {"coin5", 6}, {"coin6", 7}
	items := []Item{
		{ID: "item0", CookbookID: "cb0", TransferFee: sdk.Coins{sdk.NewCoin("coin0", sdk.NewInt(10)), sdk.NewCoin("coin1", sdk.NewInt(10)), sdk.NewCoin("coin2", sdk.NewInt(10))}},
		{ID: "item1", CookbookID: "cb1", TransferFee: sdk.Coins{sdk.NewCoin("coin2", sdk.NewInt(4)), sdk.NewCoin("coin3", sdk.NewInt(5)), sdk.NewCoin("coin4", sdk.NewInt(6))}},
		{ID: "item2", CookbookID: "cb2", TransferFee: sdk.Coins{sdk.NewCoin("coin0", sdk.NewInt(4)), sdk.NewCoin("coin4", sdk.NewInt(5)), sdk.NewCoin("coin5", sdk.NewInt(6)), sdk.NewCoin("coin6", sdk.NewInt(7))}},
	}

	for _, tc := range []struct {
		desc    string
		balance sdk.Coins
		res     []int
		err     error
	}{
		{
			desc: "Valid1",
			// {"coin0", 10}, {"coin2", 4}, {"coin4", 5}
			balance: sdk.Coins{sdk.NewCoin("coin0", sdk.NewInt(10)), sdk.NewCoin("coin2", sdk.NewInt(4)), sdk.NewCoin("coin4", sdk.NewInt(5))},
			// expected permutation [0, 0, 1]
			res: []int{0, 0, 1},
		},
		{
			desc: "Valid2",
			// {"coin0", 4}, {"coin1", 10}, {"coin3", 5}
			balance: sdk.Coins{sdk.NewCoin("coin0", sdk.NewInt(4)), sdk.NewCoin("coin1", sdk.NewInt(10)), sdk.NewCoin("coin3", sdk.NewInt(5))},
			// expected permutation [1, 1, 0]
			res: []int{1, 1, 0},
		},
		{
			desc: "Valid3",
			// {"coin0", 14}, {"coin4", 6}
			balance: sdk.Coins{sdk.NewCoin("coin0", sdk.NewInt(14)), sdk.NewCoin("coin4", sdk.NewInt(6))},
			// expected permutation [0, 2, 0]
			res: []int{0, 2, 0},
		},
		{
			desc: "Valid4",
			// {"coin0", 10}, {"coin3", 5}, {"coin6", 7}
			balance: sdk.Coins{sdk.NewCoin("coin0", sdk.NewInt(10)), sdk.NewCoin("coin3", sdk.NewInt(5)), sdk.NewCoin("coin6", sdk.NewInt(7))},
			// expected permutation [0, 1, 3]
			res: []int{0, 1, 3},
		},
		{
			desc: "Valid5",
			// {"coin0", 10}, {"coin1", 10}, {"coin4", 10}
			balance: sdk.Coins{sdk.NewCoin("coin0", sdk.NewInt(10)), sdk.NewCoin("coin1", sdk.NewInt(10)), sdk.NewCoin("coin4", sdk.NewInt(10))},
			// expected permutation [1, 2, 0]
			res: []int{1, 2, 0},
		},
		{
			desc:    "ZeroBalance",
			balance: sdk.NewCoins(),
			err:     errors.New("invalid balance provided"),
		},
		{
			desc:    "InvalidBalance",
			balance: sdk.Coins{{Denom: "coin0", Amount: sdk.NewInt(-1)}},
			err:     errors.New("invalid balance provided"),
		},
		{
			desc: "Invalid1",
			// {"coin0", 10}
			balance: sdk.Coins{sdk.NewCoin("coin0", sdk.NewInt(10))},
			err:     errors.New(fmt.Sprintf("insufficient balance to transfer item wiht ID %v in cookbook with ID %v", items[1].ID, items[1].CookbookID)),
		},
		{
			desc: "Invalid2",
			// {"coin0", 10}, {"coin4", 6}
			balance: sdk.Coins{sdk.NewCoin("coin0", sdk.NewInt(10)), sdk.NewCoin("coin4", sdk.NewInt(6))},
			err:     errors.New("no valid set of items' transferFees exists that can be covered by the provided balance"),
		},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			res, err := FindValidPaymentsPermutation(items, tc.balance)
			if tc.err != nil {
				require.Equal(t, err, tc.err)
			} else {
				require.NoError(t, err)
				require.Equal(t, tc.res, res)
			}
		})
	}
}
