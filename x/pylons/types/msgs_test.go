package types

import (
	"bytes"
	"encoding/base64"
	"encoding/json"
	"strings"
	"testing"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"
)

func TestMsgCreateCookbookValidateBasic(t *testing.T) {
	sender, _ := sdk.AccAddressFromBech32("cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337")

	cases := map[string]struct {
		cbID         string
		name         string
		desc         string
		devel        string
		version      string
		sEmail       string
		level        int64
		sender       sdk.AccAddress
		desiredError string
		showError    bool
	}{
		"cookbook name length check": {
			name:         "id001",
			desc:         "this has to meet character limits",
			devel:        "SketchyCo",
			version:      "1.0.0",
			sEmail:       "example@example.com",
			level:        0,
			sender:       sender,
			desiredError: "the name of the cookbook should have more than 8 characters",
			showError:    true,
		},
		"invalid address check": {
			name:         "id0000001",
			desc:         "this has to meet character limits",
			devel:        "SketchyCo",
			version:      "1.0.0",
			sEmail:       "example@example.com",
			level:        0,
			sender:       nil,
			desiredError: "invalid address",
			showError:    true,
		},
		"description length check": {
			name:         "id0000001",
			desc:         "",
			devel:        "SketchyCo",
			version:      "1.0.0",
			sEmail:       "example@example.com",
			level:        0,
			sender:       sender,
			desiredError: "the description should have more than 20 characters",
			showError:    true,
		},
		"email validation check": {
			name:         "id0000001",
			desc:         "this has to meet character limits",
			devel:        "SketchyCo",
			version:      "1.0.0",
			sEmail:       "wrong email type",
			level:        0,
			sender:       sender,
			desiredError: "invalid email address",
			showError:    true,
		},
		"level validation check": {
			name:         "id0000001",
			desc:         "this has to meet character limits",
			devel:        "SketchyCo",
			version:      "1.0.0",
			sEmail:       "example@example.com",
			level:        3,
			sender:       sender,
			desiredError: "Invalid cookbook plan",
			showError:    true,
		},
		"version validation check": {
			name:         "id0000001",
			desc:         "this has to meet character limits",
			devel:        "SketchyCo",
			version:      "version1 :)",
			sEmail:       "example@example.com",
			level:        0,
			sender:       sender,
			desiredError: "invalid semVer",
			showError:    true,
		},
		"successful check": {
			name:         "id0000001",
			desc:         "this has to meet character limits",
			devel:        "SketchyCo",
			version:      "1.0.0",
			sEmail:       "example@example.com",
			level:        0,
			sender:       sender,
			desiredError: "",
			showError:    false,
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			msg := NewMsgCreateCookbook(tc.name, tc.cbID, tc.desc, tc.devel, tc.version, tc.sEmail, tc.level, DefaultCostPerBlock, tc.sender.String())
			validation := msg.ValidateBasic()
			if !tc.showError {
				require.True(t, validation == nil)
			} else {
				require.True(t, validation != nil)
				require.True(t, strings.Contains(validation.Error(), tc.desiredError))
			}
		})
	}
}

func TestCreateRecipeValidateBasic(t *testing.T) {
	sender, _ := sdk.AccAddressFromBech32("cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337")

	cases := map[string]struct {
		itemInputs   ItemInputList
		entries      EntriesList
		outputs      WeightedOutputsList
		sender       sdk.AccAddress
		shortDesc    bool
		showError    bool
		desiredError string
	}{
		"item input ID validation error": { // item input ID validation error
			itemInputs:   ItemInputList{{ID: "123"}},
			entries:      EntriesList{},
			outputs:      WeightedOutputsList{},
			sender:       sender,
			showError:    true,
			desiredError: "ID is not empty nor fit the regular expression ^[a-zA-Z_][a-zA-Z_0-9]*$: id=123",
		},
		"item input ID validation": { // item input ID validation
			itemInputs:   ItemInputList{{ID: "heli_knife_lv1"}},
			entries:      EntriesList{},
			outputs:      WeightedOutputsList{},
			sender:       sender,
			showError:    false,
			desiredError: "",
		},
		"same item input ID check error": { // same item input ID check error
			itemInputs:   ItemInputList{{ID: "a123"}, {ID: "a123"}},
			entries:      EntriesList{},
			outputs:      WeightedOutputsList{},
			sender:       sender,
			showError:    true,
			desiredError: "item input with same ID available: ID=a123",
		},
		"entry ID validation error": { // entry ID validation error
			itemInputs:   ItemInputList{},
			entries:      EntriesList{CoinOutputs: []CoinOutput{{ID: "123"}}},
			outputs:      WeightedOutputsList{},
			sender:       sender,
			showError:    true,
			desiredError: "entryID does not fit the regular expression ^[a-zA-Z_][a-zA-Z_0-9]*$: id=123",
		},
		"length of program code shouldn't be 0": { // length of program code shouldn't be 0
			itemInputs:   ItemInputList{},
			entries:      EntriesList{CoinOutputs: []CoinOutput{{ID: "a123"}}},
			outputs:      WeightedOutputsList{},
			sender:       sender,
			showError:    true,
			desiredError: "length of program code shouldn't be 0",
		},
		"invalid item input ref": { // invalid item input ref
			itemInputs: ItemInputList{},
			entries: EntriesList{
				ItemModifyOutputs: []ItemModifyOutput{{ID: "a123", ItemInputRef: "aaabbb"}},
			},
			outputs:      WeightedOutputsList{},
			sender:       sender,
			showError:    true,
			desiredError: "Invalid item input ref found that does not exist in item inputs",
		},
		"entry same ID available error": { // entry same ID available error
			itemInputs: ItemInputList{},
			entries: EntriesList{
				CoinOutputs: []CoinOutput{
					{ID: "a123", Coin: "abc", Count: "1"},
					{ID: "a123", Coin: "abc", Count: "2"},
				},
			},
			outputs:      WeightedOutputsList{},
			sender:       sender,
			showError:    true,
			desiredError: "entry with same ID available: ID=a123",
		},
		"coin output denom validation error": { // coin output denom validation error
			itemInputs: ItemInputList{},
			entries: EntriesList{
				CoinOutputs: []CoinOutput{{ID: "a123", Coin: "123$", Count: "1"}},
			},
			outputs:      WeightedOutputsList{},
			sender:       sender,
			showError:    true,
			desiredError: "invalid denom: 123$",
		},
		"does not exist entry ID use on outputs": { // does not exist entry ID use on outputs
			itemInputs: ItemInputList{},
			entries:    EntriesList{},
			outputs: WeightedOutputsList{{
				EntryIDs: []string{"aaabbb"},
				Weight:   "1",
			}},
			sender:       sender,
			showError:    true,
			desiredError: "no entry with the ID aaabbb available",
		},
		"double use of entries within single output": { // double use of entries within single output
			itemInputs: ItemInputList{},
			entries: EntriesList{
				CoinOutputs: []CoinOutput{{ID: "a123", Coin: "aaa", Count: "1"}},
			},
			outputs: WeightedOutputsList{{
				EntryIDs: []string{"a123", "a123"},
				Weight:   "1",
			}},
			sender:       sender,
			showError:    true,
			desiredError: "double use of entries within single output",
		},
		"double use of item input within single output result": { // double use of item input within single output result
			itemInputs: ItemInputList{{ID: "input1"}},
			entries: EntriesList{
				ItemModifyOutputs: []ItemModifyOutput{
					{ID: "a1", ItemInputRef: "input1"},
					{ID: "a2", ItemInputRef: "input1"},
				}},
			outputs: WeightedOutputsList{{
				EntryIDs: []string{"a1", "a2"},
				Weight:   "1",
			}},
			sender:       sender,
			showError:    true,
			desiredError: "double use of item input within single output result: invalid request",
		},
		"empty sender validation1": { // empty sender validation1
			itemInputs:   ItemInputList{},
			entries:      EntriesList{},
			outputs:      WeightedOutputsList{},
			sender:       nil,
			showError:    true,
			desiredError: "invalid address",
		},
		"empty sender validation2": { // empty sender validation2
			itemInputs:   ItemInputList{},
			entries:      EntriesList{},
			outputs:      WeightedOutputsList{},
			sender:       sdk.AccAddress{},
			showError:    true,
			desiredError: "invalid address",
		},
		"the description should have more than 20 character": { // the description should have more than 20 character
			shortDesc:    true,
			sender:       sender,
			showError:    true,
			desiredError: "the description should have more than 20 characters: invalid request",
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			desc := "this has to meet character limits"
			if tc.shortDesc {
				desc = ""
			}
			msg := NewMsgCreateRecipe("existing recipe", "CookbookID", "", desc,
				GenCoinInputList("wood", 5),
				tc.itemInputs,
				tc.entries,
				tc.outputs,
				0,
				tc.sender.String(),
			)

			err := msg.ValidateBasic()
			if !tc.showError {
				require.True(t, err == nil, err)
			} else {
				require.True(t, err != nil)
				require.True(t, strings.Contains(err.Error(), tc.desiredError), err.Error())
			}
		})
	}
}

func TestUpdateRecipeValidateBasic(t *testing.T) {
	sender, _ := sdk.AccAddressFromBech32("cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337")

	cases := map[string]struct {
		recipeID     string
		itemInputs   ItemInputList
		entries      EntriesList
		outputs      WeightedOutputsList
		sender       sdk.AccAddress
		shortDesc    bool
		showError    bool
		desiredError string
	}{
		"successful update recipe": {
			recipeID:   "recipeID",
			itemInputs: GenItemInputList("Raichu"),
			entries:    GenEntries("chair", "Raichu"),
			outputs:    GenOneOutput("chair", "Raichu"),
			sender:     sender,
			showError:  false,
		},
		"recipe ID validation error": {
			recipeID:     "",
			itemInputs:   ItemInputList{},
			entries:      EntriesList{},
			outputs:      WeightedOutputsList{},
			sender:       sender,
			showError:    true,
			desiredError: "recipe id is required for this message type",
		},
		"item input ID validation error": { // item input ID validation error
			recipeID:     "recipeID",
			itemInputs:   ItemInputList{{ID: "123"}},
			entries:      EntriesList{},
			outputs:      WeightedOutputsList{},
			sender:       sender,
			showError:    true,
			desiredError: "ID is not empty nor fit the regular expression ^[a-zA-Z_][a-zA-Z_0-9]*$: id=123",
		},
		"item input ID validation": { // item input ID validation
			recipeID:     "recipeID",
			itemInputs:   ItemInputList{{ID: "heli_knife_lv1"}},
			entries:      EntriesList{},
			outputs:      WeightedOutputsList{},
			sender:       sender,
			showError:    false,
			desiredError: "",
		},
		"same item input ID check error": { // same item input ID check error
			recipeID:     "recipeID",
			itemInputs:   ItemInputList{{ID: "a123"}, {ID: "a123"}},
			entries:      EntriesList{},
			outputs:      WeightedOutputsList{},
			sender:       sender,
			showError:    true,
			desiredError: "item input with same ID available: ID=a123",
		},
		"entry ID validation error": { // entry ID validation error
			recipeID:     "recipeID",
			itemInputs:   ItemInputList{},
			entries:      EntriesList{CoinOutputs: []CoinOutput{{ID: "123"}}},
			outputs:      WeightedOutputsList{},
			sender:       sender,
			showError:    true,
			desiredError: "entryID does not fit the regular expression ^[a-zA-Z_][a-zA-Z_0-9]*$: id=123",
		},
		"length of program code shouldn't be 0": { // length of program code shouldn't be 0
			recipeID:     "recipeID",
			itemInputs:   ItemInputList{},
			entries:      EntriesList{CoinOutputs: []CoinOutput{{ID: "a123"}}},
			outputs:      WeightedOutputsList{},
			sender:       sender,
			showError:    true,
			desiredError: "length of program code shouldn't be 0",
		},
		"invalid item input ref": { // invalid item input ref
			recipeID:   "recipeID",
			itemInputs: ItemInputList{},
			entries: EntriesList{
				ItemModifyOutputs: []ItemModifyOutput{{ID: "a123", ItemInputRef: "aaabbb"}},
			},
			outputs:      WeightedOutputsList{},
			sender:       sender,
			showError:    true,
			desiredError: "Invalid item input ref found that does not exist in item inputs",
		},
		"entry same ID available error": { // entry same ID available error
			recipeID:   "recipeID",
			itemInputs: ItemInputList{},
			entries: EntriesList{
				CoinOutputs: []CoinOutput{
					{ID: "a123", Coin: "abc", Count: "1"},
					{ID: "a123", Coin: "abc", Count: "2"},
				}},
			outputs:      WeightedOutputsList{},
			sender:       sender,
			showError:    true,
			desiredError: "entry with same ID available: ID=a123",
		},
		"coin output denom validation error": { // coin output denom validation error
			recipeID:   "recipeID",
			itemInputs: ItemInputList{},
			entries: EntriesList{
				CoinOutputs: []CoinOutput{{ID: "a123", Coin: "123$", Count: "1"}},
			},
			outputs:      WeightedOutputsList{},
			sender:       sender,
			showError:    true,
			desiredError: "invalid denom: 123$",
		},
		"does not exist entry ID use on outputs": { // does not exist entry ID use on outputs
			recipeID:   "recipeID",
			itemInputs: ItemInputList{},
			entries:    EntriesList{},
			outputs: WeightedOutputsList{{
				EntryIDs: []string{"aaabbb"},
				Weight:   "1",
			}},
			sender:       sender,
			showError:    true,
			desiredError: "no entry with the ID aaabbb available",
		},
		"double use of entries within single output": { // double use of entries within single output
			recipeID:   "recipeID",
			itemInputs: ItemInputList{},
			entries: EntriesList{
				CoinOutputs: []CoinOutput{{ID: "a123", Coin: "aaa", Count: "1"}},
			},
			outputs: WeightedOutputsList{{
				EntryIDs: []string{"a123", "a123"},
				Weight:   "1",
			}},
			sender:       sender,
			showError:    true,
			desiredError: "double use of entries within single output",
		},
		"double use of item input within single output result": { // double use of item input within single output result
			recipeID:   "recipeID",
			itemInputs: ItemInputList{{ID: "input1"}},
			entries: EntriesList{
				ItemModifyOutputs: []ItemModifyOutput{
					{ID: "a1", ItemInputRef: "input1"},
					{ID: "a2", ItemInputRef: "input1"},
				}},
			outputs: WeightedOutputsList{{
				EntryIDs: []string{"a1", "a2"},
				Weight:   "1",
			}},
			sender:       sender,
			showError:    true,
			desiredError: "double use of item input within single output result: invalid request",
		},
		"empty sender validation1": { // empty sender validation1
			recipeID:     "recipeID",
			itemInputs:   ItemInputList{},
			entries:      EntriesList{},
			outputs:      WeightedOutputsList{},
			sender:       nil,
			showError:    true,
			desiredError: "invalid address",
		},
		"empty sender validation2": { // empty sender validation2
			recipeID:     "recipeID",
			itemInputs:   ItemInputList{},
			entries:      EntriesList{},
			outputs:      WeightedOutputsList{},
			sender:       sdk.AccAddress{},
			showError:    true,
			desiredError: "invalid address",
		},
		"the description should have more than 20 character": { // the description should have more than 20 character
			recipeID:     "recipeID",
			shortDesc:    true,
			sender:       sender,
			showError:    true,
			desiredError: "the description should have more than 20 characters: invalid request",
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			desc := "this has to meet character limits"
			if tc.shortDesc {
				desc = ""
			}
			msg := NewMsgUpdateRecipe(
				tc.recipeID,
				"existing recipe",
				"CookbookID",
				desc,
				GenCoinInputList("wood", 5),
				tc.itemInputs,
				tc.entries,
				tc.outputs,
				0,
				tc.sender.String(),
			)

			err := msg.ValidateBasic()
			if !tc.showError {
				require.True(t, err == nil, err)
			} else {
				require.True(t, err != nil)
				require.True(t, strings.Contains(err.Error(), tc.desiredError), err.Error())
			}
		})
	}
}

func TestGetPylonsValidateBasic(t *testing.T) {
	sender, _ := sdk.AccAddressFromBech32("cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337")

	cases := map[string]struct {
		amount       sdk.Coins
		requester    sdk.AccAddress
		showError    bool
		desiredError string
	}{
		"successful check": {
			amount:       NewPylon(500),
			requester:    sender,
			showError:    false,
			desiredError: "",
		},
		"nil balance check": {
			amount:       nil,
			requester:    sender,
			showError:    true,
			desiredError: "Amount cannot be less than 0/negative: unknown request",
		},
		"zero balance check": {
			amount:       sdk.Coins{},
			requester:    sender,
			showError:    true,
			desiredError: "Amount cannot be less than 0/negative: unknown request",
		},
		"empty address check": {
			amount:       NewPylon(500),
			requester:    sdk.AccAddress{},
			showError:    true,
			desiredError: "invalid address",
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			msg := NewMsgGetPylons(tc.amount, tc.requester.String())
			err := msg.ValidateBasic()
			if !tc.showError {
				require.True(t, err == nil, err)
			} else {
				require.True(t, err != nil)
				require.True(t, strings.Contains(err.Error(), tc.desiredError), err.Error())
			}
		})
	}
}

func TestGoogleIAPSignatureVerification(t *testing.T) {
	sender, _ := sdk.AccAddressFromBech32("cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337")

	cases := map[string]struct {
		productID     string
		purchaseToken string
		receiptData   string
		signature     string
		sender        sdk.AccAddress
		desiredError  string
		showError     bool
	}{
		"successful check": {
			productID:     "pylons_1000",
			purchaseToken: "hafokgmjfkcpdnbffanijckj.AO-J1OxXkrKdM8q14T49Qo5a723VG_8h_4MCY_M2Tqn91L0e7FjiVXsZ2Qxc1SnvoFzHN9jBCJpjZqD4ErYIquMG6Li_jUfcuKuXti_wsa7r48eWNA1Oh0o",
			receiptData:   `{"productId":"pylons_1000","purchaseToken":"hafokgmjfkcpdnbffanijckj.AO-J1OxXkrKdM8q14T49Qo5a723VG_8h_4MCY_M2Tqn91L0e7FjiVXsZ2Qxc1SnvoFzHN9jBCJpjZqD4ErYIquMG6Li_jUfcuKuXti_wsa7r48eWNA1Oh0o","purchaseTime":1595031050407,"developerPayload":null}`,
			// Correct signature
			signature:    "HEo0RYQeH0+8nmYa6ETKP9f3S/W/cUuQTBme7VSh3Lzm+1+1GwJIl1pdF1dh32YGhd3BtyMoLVGzr9ZajfHhhznIvbowS/XIlyJJCE6dI+zg68mKo5rDt0wB2BY8azk0+WCkc5XT5y8biRNXe5RyvmuqYKPXmEsgHaYKo6x3mHs6oXrECckKv/c9T9MHCvdAqVFrml9W7K41sRHbpOdFmYnO33bkNITCCaf/C1PDGMVOItxvq7uXi+F0DpjXwXko9AU6L3pK6zDICcD38HblbzumOg6LGsuWCjOw8QwNobYOUNtrdj01fEXqkKhfYzFZcwxM6xsphN38gnO0ksDdyw==",
			sender:       sender,
			showError:    false,
			desiredError: "",
		},
		"invalid signature check": {
			productID:     "pylons_1000",
			purchaseToken: "hafokgmjfkcpdnbffanijckj.AO-J1OxXkrKdM8q14T49Qo5a723VG_8h_4MCY_M2Tqn91L0e7FjiVXsZ2Qxc1SnvoFzHN9jBCJpjZqD4ErYIquMG6Li_jUfcuKuXti_wsa7r48eWNA1Oh0o",
			receiptData:   `{"productId":"pylons_1000","purchaseToken":"hafokgmjfkcpdnbffanijckj.AO-J1OxXkrKdM8q14T49Qo5a723VG_8h_4MCY_M2Tqn91L0e7FjiVXsZ2Qxc1SnvoFzHN9jBCJpjZqD4ErYIquMG6Li_jUfcuKuXti_wsa7r48eWNA1Oh0o","purchaseTime":1595031050407,"developerPayload":null}`,
			// Incorrect signature
			signature:    "FakeToken0833XweaU==",
			sender:       sender,
			desiredError: "crypto/rsa: verification error",
			showError:    true,
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			receiptDataBase64 := base64.StdEncoding.EncodeToString([]byte(tc.receiptData))
			msg := NewMsgGoogleIAPGetPylons(tc.productID, tc.purchaseToken, receiptDataBase64, tc.signature, tc.sender.String())
			err := msg.ValidateGoogleIAPSignature()
			if !tc.showError {
				require.True(t, err == nil, err)
			} else {
				require.True(t, err != nil)
				require.True(t, strings.Contains(err.Error(), tc.desiredError), err.Error())
			}
		})
	}
}

func TestCreateTradeGetSignBytesItemInput(t *testing.T) {
	sdkAddr, err := sdk.AccAddressFromBech32("cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337")
	require.NoError(t, err)
	msg := NewMsgCreateTrade(
		CoinInputList{},
		GenTradeItemInputList("UTestCreateTrade-CB-001", []string{"Raichu"}),
		NewPylon(10),
		ItemList{},
		"Test CreateTrade GetSignBytes",
		sdkAddr.String())
	err = msg.ValidateBasic()
	require.NoError(t, err)

	expectedSignBytes := `{
      "CoinInputs": [],
      "CoinOutputs": [
        {
          "amount": "10",
          "denom": "pylon"
        }
      ],
      "ExtraInfo": "Test CreateTrade GetSignBytes",
      "ItemInputs": [
        {
          "CookbookID": "UTestCreateTrade-CB-001",
          "ItemInput": {
            "Conditions":{"Doubles":null,"Longs":null,"Strings":null},
            "Doubles": [],
            "ID": "Raichu",
            "Longs": [],
            "Strings": [
              {
                "Key": "Name",
                "Value": "Raichu"
              }
            ],
            "TransferFee": {
              "MaxValue": 10000
            }
          }
        }
      ],
      "ItemOutputs": [],
      "Sender": "cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337"
    }`
	buffer := new(bytes.Buffer)
	err = json.Compact(buffer, []byte(expectedSignBytes))
	require.NoError(t, err)
	require.Equal(t, string(msg.GetSignBytes()), buffer.String())
}

func TestCreateTradeGetSignBytesUnorderedCoinInputs(t *testing.T) {
	sdkAddr, err := sdk.AccAddressFromBech32("cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337")
	require.NoError(t, err)
	msg := NewMsgCreateTrade(
		CoinInputList{
			{Coin: "aaaa", Count: 100},
			{Coin: "zzzz", Count: 100},
			{Coin: "cccc", Count: 100},
		},
		TradeItemInputList{},
		NewPylon(10),
		ItemList{},
		"Test CreateTrade GetSignBytes",
		sdkAddr.String())
	err = msg.ValidateBasic()
	require.NoError(t, err)

	expectedSignBytes := `{
      "CoinInputs": [
        {
          "Coin": "aaaa",
          "Count": 100
        },
        {
          "Coin": "zzzz",
          "Count": 100
        },
        {
          "Coin": "cccc",
          "Count": 100
        }
      ],
      "CoinOutputs": [
        {
          "amount": "10",
          "denom": "pylon"
        }
      ],
      "ExtraInfo": "Test CreateTrade GetSignBytes",
      "ItemInputs": [],
      "ItemOutputs": [],
      "Sender": "cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337"
    }`
	buffer := new(bytes.Buffer)
	err = json.Compact(buffer, []byte(expectedSignBytes))
	require.NoError(t, err)
	require.Equal(t, string(msg.GetSignBytes()), buffer.String(), string(msg.GetSignBytes()))
}
