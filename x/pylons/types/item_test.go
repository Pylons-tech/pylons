package types

import (
	"errors"
	"fmt"
	"math"
	"testing"

	sdkerrors "cosmossdk.io/errors"

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
		{Id: "item0", CookbookId: "cb0", TransferFee: sdk.Coins{sdk.NewCoin("coin0", sdk.NewInt(10)), sdk.NewCoin("coin1", sdk.NewInt(10)), sdk.NewCoin("coin2", sdk.NewInt(10))}},
		{Id: "item1", CookbookId: "cb1", TransferFee: sdk.Coins{sdk.NewCoin("coin2", sdk.NewInt(4)), sdk.NewCoin("coin3", sdk.NewInt(5)), sdk.NewCoin("coin4", sdk.NewInt(6))}},
		{Id: "item2", CookbookId: "cb2", TransferFee: sdk.Coins{sdk.NewCoin("coin0", sdk.NewInt(4)), sdk.NewCoin("coin4", sdk.NewInt(5)), sdk.NewCoin("coin5", sdk.NewInt(6)), sdk.NewCoin("coin6", sdk.NewInt(7))}},
	}

	for _, tc := range []struct {
		desc    string
		balance sdk.Coins
		noitems bool
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
			desc:    "Invalid item",
			balance: sdk.Coins{sdk.NewCoin("coin0", sdk.NewInt(10)), sdk.NewCoin("coin1", sdk.NewInt(10)), sdk.NewCoin("coin4", sdk.NewInt(10))},
			noitems: true,
			err:     errors.New("invalid set of Items provided"),
		},
		{
			desc: "Invalid1",
			// {"coin0", 10}
			balance: sdk.Coins{sdk.NewCoin("coin0", sdk.NewInt(10))},
			err:     fmt.Errorf("insufficient balance to transfer item with ID %v in cookbook with ID %v", items[1].Id, items[1].CookbookId),
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
			var res []int
			var err error
			if tc.noitems {
				res, err = FindValidPaymentsPermutation(nil, tc.balance)
			} else {
				res, err = FindValidPaymentsPermutation(items, tc.balance)
			}
			if tc.err != nil {
				require.Equal(t, err, tc.err)
			} else {
				require.NoError(t, err)
				require.Equal(t, tc.res, res)
			}
		})
	}
}

func TestFindDouble(t *testing.T) {
	for _, tc := range []struct {
		desc         string
		testedItem   Item
		testedValue  string
		expectedDec  sdk.Dec
		expectedBool bool
	}{
		{
			desc: "Found",
			testedItem: Item{
				Doubles: []DoubleKeyValue{
					{
						Key:   "one",
						Value: sdk.OneDec(),
					},
					{
						Key:   "two",
						Value: sdk.OneDec(),
					},
				},
			},
			testedValue:  "one",
			expectedBool: true,
			expectedDec:  sdk.OneDec(),
		},
		{
			desc: "Not Found",
			testedItem: Item{
				Doubles: []DoubleKeyValue{
					{
						Key:   "one",
						Value: sdk.OneDec(),
					},
					{
						Key:   "two",
						Value: sdk.OneDec(),
					},
				},
			},
			testedValue:  "three",
			expectedBool: false,
			expectedDec:  sdk.ZeroDec(),
		},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			returnedDec, returnedBool := tc.testedItem.FindDouble(tc.testedValue)
			require.Equal(t, returnedDec, tc.expectedDec)
			require.Equal(t, returnedBool, tc.expectedBool)
		})
	}
}

func TestFindDoubleKey(t *testing.T) {
	for _, tc := range []struct {
		desc         string
		testedItem   Item
		testedValue  string
		expectedInt  int
		expectedBool bool
	}{
		{
			desc: "Found, position 0",
			testedItem: Item{
				Doubles: []DoubleKeyValue{
					{
						Key:   "one",
						Value: sdk.NewDec(1),
					},
					{
						Key:   "two",
						Value: sdk.NewDec(1),
					},
				},
			},
			testedValue:  "one",
			expectedBool: true,
			expectedInt:  0,
		},
		{
			desc: "Found, position non zero",
			testedItem: Item{
				Doubles: []DoubleKeyValue{
					{
						Key:   "one",
						Value: sdk.NewDec(1),
					},
					{
						Key:   "two",
						Value: sdk.NewDec(1),
					},
				},
			},
			testedValue:  "two",
			expectedBool: true,
			expectedInt:  1,
		},
		{
			desc: "Not Found",
			testedItem: Item{
				Doubles: []DoubleKeyValue{
					{
						Key:   "one",
						Value: sdk.NewDec(1),
					},
					{
						Key:   "two",
						Value: sdk.NewDec(1),
					},
				},
			},
			testedValue:  "three",
			expectedBool: false,
			expectedInt:  0,
		},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			returnedInt, returnedBool := tc.testedItem.FindDoubleKey(tc.testedValue)
			require.Equal(t, returnedInt, tc.expectedInt)
			require.Equal(t, returnedBool, tc.expectedBool)
		})
	}
}

func TestFindLong(t *testing.T) {
	for _, tc := range []struct {
		desc         string
		testedItem   Item
		testedValue  string
		expectedInt  int
		expectedBool bool
	}{
		{
			desc: "Found",
			testedItem: Item{
				Longs: []LongKeyValue{
					{
						Key:   "one",
						Value: 1,
					},
					{
						Key:   "two",
						Value: 2,
					},
				},
			},
			testedValue:  "two",
			expectedBool: true,
			expectedInt:  2,
		},
		{
			desc: "Not Found",
			testedItem: Item{
				Longs: []LongKeyValue{
					{
						Key:   "one",
						Value: 1,
					},
					{
						Key:   "two",
						Value: 2,
					},
				},
			},
			testedValue:  "three",
			expectedBool: false,
			expectedInt:  0,
		},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			returnedInt, returnedBool := tc.testedItem.FindLong(tc.testedValue)
			require.Equal(t, returnedInt, tc.expectedInt)
			require.Equal(t, returnedBool, tc.expectedBool)
		})
	}
}

func TestFindLongKey(t *testing.T) {
	for _, tc := range []struct {
		desc         string
		testedItem   Item
		testedValue  string
		expectedInt  int
		expectedBool bool
	}{
		{
			desc: "Found in position different from zero",
			testedItem: Item{
				Longs: []LongKeyValue{
					{
						Key:   "one",
						Value: 1,
					},
					{
						Key:   "zero",
						Value: 0,
					},
				},
			},
			testedValue:  "zero",
			expectedBool: true,
			expectedInt:  1,
		},
		{
			desc: "Found in position zero",
			testedItem: Item{
				Longs: []LongKeyValue{
					{
						Key:   "zero",
						Value: 0,
					},
					{
						Key:   "one",
						Value: 1,
					},
				},
			},
			testedValue:  "zero",
			expectedBool: true,
			expectedInt:  0,
		},
		{
			desc: "Not Found",
			testedItem: Item{
				Longs: []LongKeyValue{
					{
						Key:   "one",
						Value: 1,
					},
					{
						Key:   "two",
						Value: 2,
					},
				},
			},
			testedValue:  "three",
			expectedBool: false,
			expectedInt:  0,
		},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			returnedInt, returnedBool := tc.testedItem.FindLongKey(tc.testedValue)
			require.Equal(t, returnedInt, tc.expectedInt)
			require.Equal(t, returnedBool, tc.expectedBool)
		})
	}
}

func TestFindString(t *testing.T) {
	for _, tc := range []struct {
		desc           string
		testedItem     Item
		testedValue    string
		expectedString string
		expectedBool   bool
	}{
		{
			desc: "Found",
			testedItem: Item{
				Strings: []StringKeyValue{
					{
						Key:   "firstOne",
						Value: "lorem",
					},
					{
						Key:   "secondOne",
						Value: "ipsum",
					},
				},
			},
			testedValue:    "secondOne",
			expectedBool:   true,
			expectedString: "ipsum",
		},
		{
			desc: "Empty string found",
			testedItem: Item{
				Strings: []StringKeyValue{
					{
						Key:   "firstOne",
						Value: "lorem",
					},
					{
						Key:   "secondOne",
						Value: "",
					},
				},
			},
			testedValue:    "secondOne",
			expectedBool:   true,
			expectedString: "",
		},
		{
			desc: "Not Found",
			testedItem: Item{
				Strings: []StringKeyValue{
					{
						Key:   "firstOne",
						Value: "lorem",
					},
					{
						Key:   "secondOne",
						Value: "ipsum",
					},
				},
			},
			testedValue:    "thirdOne",
			expectedBool:   false,
			expectedString: "",
		},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			returnedInt, returnedBool := tc.testedItem.FindString(tc.testedValue)
			require.Equal(t, returnedInt, tc.expectedString)
			require.Equal(t, returnedBool, tc.expectedBool)
		})
	}
}

func TestFindStringKey(t *testing.T) {
	for _, tc := range []struct {
		desc         string
		testedItem   Item
		testedValue  string
		expectedInt  int
		expectedBool bool
	}{
		{
			desc: "Found",
			testedItem: Item{
				Strings: []StringKeyValue{
					{
						Key:   "firstOne",
						Value: "lorem",
					},
					{
						Key:   "secondOne",
						Value: "ipsum",
					},
				},
			},
			testedValue:  "secondOne",
			expectedBool: true,
			expectedInt:  1,
		},
		{
			desc: "Not Found",
			testedItem: Item{
				Strings: []StringKeyValue{
					{
						Key:   "firstOne",
						Value: "lorem",
					},
					{
						Key:   "secondOne",
						Value: "ipsum",
					},
				},
			},
			testedValue:  "thirdOne",
			expectedBool: false,
			expectedInt:  0,
		},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			returnedInt, returnedBool := tc.testedItem.FindStringKey(tc.testedValue)
			require.Equal(t, returnedInt, tc.expectedInt)
			require.Equal(t, returnedBool, tc.expectedBool)
		})
	}
}

func TestMatchItem(t *testing.T) {
	for _, tc := range []struct {
		desc             string
		itemInputToMatch ItemInput
		itemToMatch      Item
		expectedError    error
	}{
		{
			desc: "Match Successful",
			itemInputToMatch: ItemInput{
				Id: "test1",
				Doubles: []DoubleInputParam{
					{
						Key:      "doubleone",
						MinValue: sdk.OneDec(),
						MaxValue: sdk.OneDec(),
					},
					{
						Key:      "doubletwo",
						MinValue: sdk.NewDec(2),
						MaxValue: sdk.NewDec(2),
					},
				},
				Longs: []LongInputParam{
					{
						Key:      "longone",
						MinValue: 1,
						MaxValue: 1,
					},
					{
						Key:      "longtwo",
						MinValue: 2,
						MaxValue: 2,
					},
				},
				Strings: []StringInputParam{
					{
						Key:   "stringone",
						Value: "1",
					},
					{
						Key:   "stringtwo",
						Value: "2",
					},
				},
			},
			itemToMatch: Item{
				Doubles: []DoubleKeyValue{
					{
						Key:   "doubleone",
						Value: sdk.NewDec(1),
					}, {
						Key:   "doubletwo",
						Value: sdk.NewDec(2),
					},
				},
				Longs: []LongKeyValue{
					{
						Key:   "longone",
						Value: 1,
					},
					{
						Key:   "longtwo",
						Value: 2,
					},
				},
				Strings: []StringKeyValue{
					{
						Key:   "stringone",
						Value: "1",
					},
					{
						Key:   "stringtwo",
						Value: "2",
					},
				},
			},
			expectedError: nil,
		},
		{
			desc: "Double Key Not Available",
			itemInputToMatch: ItemInput{
				Id: "test1",
				Doubles: []DoubleInputParam{
					{
						Key:      "doubleone",
						MinValue: sdk.OneDec(),
						MaxValue: sdk.OneDec(),
					},
					{
						Key:      "doublethree",
						MinValue: sdk.NewDec(3),
						MaxValue: sdk.NewDec(3),
					},
				},
			},
			itemToMatch: Item{
				Id: "test1",
				Doubles: []DoubleKeyValue{
					{
						Key:   "doubleone",
						Value: sdk.NewDec(1),
					}, {
						Key:   "doubletwo",
						Value: sdk.NewDec(2),
					},
				},
			},
			expectedError: sdkerrors.Wrapf(ErrItemMatch, "%s key is not available on the item: item_id=%s", "doublethree", "test1"),
		},
		{
			desc: "Double key is available but range do not match",
			itemInputToMatch: ItemInput{
				Id: "test1",
				Doubles: []DoubleInputParam{
					{
						Key:      "doubleone",
						MinValue: sdk.OneDec(),
						MaxValue: sdk.OneDec(),
					},
					{
						Key:      "doubletwo",
						MinValue: sdk.NewDec(3),
						MaxValue: sdk.NewDec(4),
					},
				},
			},
			itemToMatch: Item{
				Id: "test1",
				Doubles: []DoubleKeyValue{
					{
						Key:   "doubleone",
						Value: sdk.NewDec(1),
					}, {
						Key:   "doubletwo",
						Value: sdk.NewDec(2),
					},
				},
			},
			expectedError: sdkerrors.Wrapf(ErrItemMatch, "%s key range does not match: item_id=%s", "doubletwo", "test1"),
		},
		{
			desc: "Long Key Not Available",
			itemInputToMatch: ItemInput{
				Id: "test1",
				Longs: []LongInputParam{
					{
						Key:      "longone",
						MinValue: 1,
						MaxValue: 1,
					},
					{
						Key:      "longthree",
						MinValue: 3,
						MaxValue: 3,
					},
				},
			},
			itemToMatch: Item{
				Id: "test1",
				Longs: []LongKeyValue{
					{
						Key:   "longone",
						Value: 1,
					}, {
						Key:   "longtwo",
						Value: 2,
					},
				},
			},
			expectedError: sdkerrors.Wrapf(ErrItemMatch, "%s key is not available on the item: item_id=%s", "longthree", "test1"),
		},
		{
			desc: "Long key is available but range do not match",
			itemInputToMatch: ItemInput{
				Id: "test1",
				Longs: []LongInputParam{
					{
						Key:      "longone",
						MinValue: 1,
						MaxValue: 1,
					},
					{
						Key:      "longtwo",
						MinValue: 2,
						MaxValue: 3,
					},
				},
			},
			itemToMatch: Item{
				Id: "test1",
				Longs: []LongKeyValue{
					{
						Key:   "longone",
						Value: 1,
					}, {
						Key:   "longtwo",
						Value: 4,
					},
				},
			},
			expectedError: sdkerrors.Wrapf(ErrItemMatch, "%s key range does not match: item_id=%s", "longtwo", "test1"),
		},
		{
			desc: "String Key Not Available",
			itemInputToMatch: ItemInput{
				Id: "test1",
				Strings: []StringInputParam{
					{
						Key:   "stringone",
						Value: "1",
					},
					{
						Key:   "stringtwo",
						Value: "1",
					},
				},
			},
			itemToMatch: Item{
				Id: "test1",
				Strings: []StringKeyValue{
					{
						Key:   "longone",
						Value: "1",
					}, {
						Key:   "longtwo",
						Value: "2",
					},
				},
			},
			expectedError: sdkerrors.Wrapf(ErrItemMatch, "%s key is not available on the item: item_id=%s", "stringone", "test1"),
		},
		{
			desc: "String key is available but values do not match",
			itemInputToMatch: ItemInput{
				Id: "test1",
				Strings: []StringInputParam{
					{
						Key:   "stringone",
						Value: "1",
					},
					{
						Key:   "stringtwo",
						Value: "2",
					},
				},
			},
			itemToMatch: Item{
				Id: "test1",
				Strings: []StringKeyValue{
					{
						Key:   "stringone",
						Value: "1",
					}, {
						Key:   "stringtwo",
						Value: "4",
					},
				},
			},
			expectedError: sdkerrors.Wrapf(ErrItemMatch, "%s key value does not match: item_id=%s", "stringtwo", "test1"),
		},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			ec := CelEnvCollection{}
			err := tc.itemInputToMatch.MatchItem(tc.itemToMatch, ec)
			if tc.expectedError != nil {
				require.Equal(t, err.Error(), tc.expectedError.Error())
			} else {
				require.NoError(t, err)
			}
		})
	}
}
