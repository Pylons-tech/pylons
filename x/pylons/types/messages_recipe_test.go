package types

import (
	"testing"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	"github.com/stretchr/testify/require"
)

func TestMsgRecipeValidateBasic(t *testing.T) {
	correctCreatorAddr := "cosmos1n67vdlaejpj3uzswr9qapeg76zlkusj5k875ma"
	invalidAddr := "pylo1xn72u3jxlpqx8tfgmjf0xg970q36xensjngsme"

	valDoubles1, _ := sdk.NewDecFromStr("3.01")
	valDoubles2, _ := sdk.NewDecFromStr("1.99")
	valDoubles3, _ := sdk.NewDecFromStr("-1.99")
	for _, tc := range []struct {
		desc       string
		create_req *MsgCreateRecipe
		update_req *MsgUpdateRecipe
		create_err error
		update_err error
	}{
		{
			desc: "Valid",
			create_req: &MsgCreateRecipe{
				Creator:       correctCreatorAddr,
				CookbookId:    "CookbookId",
				Id:            "CookbookId",
				Name:          "testRecipeName",
				Description:   "decdescdescdescdescdescdescdesc",
				Version:       "v0.0.1",
				CoinInputs:    nil,
				ItemInputs:    nil,
				Entries:       EntriesList{},
				Outputs:       nil,
				BlockInterval: 0,
				CostPerBlock:  sdk.Coin{Denom: "test", Amount: sdk.ZeroInt()},
				Enabled:       false,
				ExtraInfo:     "",
			},
			create_err: nil,
			update_err: nil,
		},
		{
			desc: "Invalid creator address 1",
			create_req: &MsgCreateRecipe{
				Creator: "",
			},
			create_err: sdkerrors.ErrInvalidAddress,
			update_err: sdkerrors.ErrInvalidAddress,
		},
		{
			desc: "Invalid creator address 2",
			create_req: &MsgCreateRecipe{
				Creator: invalidAddr,
			},
			create_err: sdkerrors.ErrInvalidAddress,
			update_err: sdkerrors.ErrInvalidAddress,
		},
		{
			desc: "Invalid creator address 3",
			create_req: &MsgCreateRecipe{
				Creator: "test",
			},
			create_err: sdkerrors.ErrInvalidAddress,
			update_err: sdkerrors.ErrInvalidAddress,
		},
		{
			desc: "Invalid name",
			create_req: &MsgCreateRecipe{
				Creator: correctCreatorAddr,
				Name:    "",
			},
			create_err: sdkerrors.ErrInvalidRequest,
			update_err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "Invalid description",
			create_req: &MsgCreateRecipe{
				Creator:     correctCreatorAddr,
				Name:        "testRecipeName",
				Description: "",
			},
			create_err: sdkerrors.ErrInvalidRequest,
			update_err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "Invalid cookbookId",
			create_req: &MsgCreateRecipe{
				Creator:     correctCreatorAddr,
				CookbookId:  "test $%^",
				Name:        "testRecipeName",
				Description: "decdescdescdescdescdescdescdesc",
			},
			create_err: sdkerrors.ErrInvalidRequest,
			update_err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "Invalid ID",
			create_req: &MsgCreateRecipe{
				Creator:     correctCreatorAddr,
				CookbookId:  "CookbookId",
				Id:          "test $%^",
				Name:        "testRecipeName",
				Description: "decdescdescdescdescdescdescdesc",
			},
			create_err: sdkerrors.ErrInvalidRequest,
			update_err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "Invalid Version",
			create_req: &MsgCreateRecipe{
				Creator:     correctCreatorAddr,
				CookbookId:  "CookbookId",
				Id:          "CookbookId",
				Name:        "testRecipeName",
				Description: "decdescdescdescdescdescdescdesc",
				Version:     "100",
			},
			create_err: sdkerrors.ErrInvalidRequest,
			update_err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "Invalid CostPerBlock",
			create_req: &MsgCreateRecipe{
				Creator:      correctCreatorAddr,
				CookbookId:   "CookbookId",
				Id:           "CookbookId",
				Name:         "testRecipeName",
				Description:  "decdescdescdescdescdescdescdesc",
				Version:      "v0.0.1",
				CostPerBlock: sdk.Coin{},
			},
			create_err: sdkerrors.ErrInvalidCoins,
			update_err: sdkerrors.ErrInvalidCoins,
		},
		{
			desc: "Invalid BlockInterval",
			create_req: &MsgCreateRecipe{
				Creator:       correctCreatorAddr,
				CookbookId:    "CookbookId",
				Id:            "CookbookId",
				Name:          "testRecipeName",
				Description:   "decdescdescdescdescdescdescdesc",
				Version:       "v0.0.1",
				CostPerBlock:  sdk.Coin{Denom: "test", Amount: sdk.ZeroInt()},
				BlockInterval: int64(-1),
			},
			create_err: sdkerrors.ErrInvalidRequest,
			update_err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "Invalid CoinInputs 1",
			create_req: &MsgCreateRecipe{
				Creator:       correctCreatorAddr,
				CookbookId:    "CookbookId",
				Id:            "CookbookId",
				Name:          "testRecipeName",
				Description:   "decdescdescdescdescdescdescdesc",
				Version:       "v0.0.1",
				CostPerBlock:  sdk.Coin{Denom: "test", Amount: sdk.ZeroInt()},
				BlockInterval: 100,
				CoinInputs: []CoinInput{{
					Coins: sdk.Coins{
						sdk.Coin{Denom: "test", Amount: sdk.ZeroInt()},
					},
				}},
			},
			create_err: sdkerrors.ErrInvalidCoins,
			update_err: sdkerrors.ErrInvalidCoins,
		},
		{
			desc: "Invalid CoinInputs 2",
			create_req: &MsgCreateRecipe{
				Creator:       correctCreatorAddr,
				CookbookId:    "CookbookId",
				Id:            "CookbookId",
				Name:          "testRecipeName",
				Description:   "decdescdescdescdescdescdescdesc",
				Version:       "v0.0.1",
				CostPerBlock:  sdk.Coin{Denom: "test", Amount: sdk.ZeroInt()},
				BlockInterval: 100,
				CoinInputs: []CoinInput{{
					Coins: sdk.Coins{
						sdk.Coin{Denom: "test", Amount: sdk.NewInt(-1)},
					},
				}},
			},
			create_err: sdkerrors.ErrInvalidCoins,
			update_err: sdkerrors.ErrInvalidCoins,
		},
		{
			desc: "Invalid CoinInputs 3",
			create_req: &MsgCreateRecipe{
				Creator:       correctCreatorAddr,
				CookbookId:    "CookbookId",
				Id:            "CookbookId",
				Name:          "testRecipeName",
				Description:   "decdescdescdescdescdescdescdesc",
				Version:       "v0.0.1",
				CostPerBlock:  sdk.Coin{Denom: "test", Amount: sdk.ZeroInt()},
				BlockInterval: 100,
				CoinInputs: []CoinInput{{
					Coins: sdk.Coins{
						sdk.Coin{Denom: "test !@#", Amount: sdk.NewInt(0)},
					},
				}},
			},
			create_err: sdkerrors.ErrInvalidCoins,
			update_err: sdkerrors.ErrInvalidCoins,
		},
		{
			desc: "Invalid CoinInputs 4",
			create_req: &MsgCreateRecipe{
				Creator:       correctCreatorAddr,
				CookbookId:    "CookbookId",
				Id:            "CookbookId",
				Name:          "testRecipeName",
				Description:   "decdescdescdescdescdescdescdesc",
				Version:       "v0.0.1",
				CostPerBlock:  sdk.Coin{Denom: "test", Amount: sdk.ZeroInt()},
				BlockInterval: 100,
				CoinInputs: []CoinInput{{
					Coins: sdk.Coins{
						sdk.Coin{Denom: "test", Amount: sdk.NewInt(0)},
						sdk.Coin{Denom: "test", Amount: sdk.NewInt(0)},
					},
				}},
			},
			create_err: sdkerrors.ErrInvalidCoins,
			update_err: sdkerrors.ErrInvalidCoins,
		},
		{
			desc: "Invalid CoinInputs 5",
			create_req: &MsgCreateRecipe{
				Creator:       correctCreatorAddr,
				CookbookId:    "CookbookId",
				Id:            "CookbookId",
				Name:          "testRecipeName",
				Description:   "decdescdescdescdescdescdescdesc",
				Version:       "v0.0.1",
				CostPerBlock:  sdk.Coin{Denom: "test", Amount: sdk.ZeroInt()},
				BlockInterval: 100,
				CoinInputs: []CoinInput{{
					Coins: sdk.Coins{
						sdk.Coin{Denom: "cookbookID/denom1", Amount: sdk.OneInt()},
					},
				}},
			},
			create_err: sdkerrors.ErrInvalidCoins,
			update_err: sdkerrors.ErrInvalidCoins,
		},
		{
			desc: "Invalid CoinInputs 6",
			create_req: &MsgCreateRecipe{
				Creator:       correctCreatorAddr,
				CookbookId:    "CookbookId",
				Id:            "CookbookId",
				Name:          "testRecipeName",
				Description:   "decdescdescdescdescdescdescdesc",
				Version:       "v0.0.1",
				CostPerBlock:  sdk.Coin{Denom: "test", Amount: sdk.OneInt()},
				BlockInterval: 100,
				CoinInputs: []CoinInput{{
					Coins: sdk.Coins{
						sdk.Coin{Denom: "ibc/529ba5e3e86ba7796d7caab4fc02728935fbc75c0f7b25a9e611c49dd7d68a35", Amount: sdk.OneInt()},
					},
				}},
			},
			create_err: sdkerrors.ErrInvalidCoins,
			update_err: sdkerrors.ErrInvalidCoins,
		},
		{
			desc: "Invalid ItemInputs 1",
			create_req: &MsgCreateRecipe{
				Creator:       correctCreatorAddr,
				CookbookId:    "CookbookId",
				Id:            "CookbookId",
				Name:          "testRecipeName",
				Description:   "decdescdescdescdescdescdescdesc",
				Version:       "v0.0.1",
				CostPerBlock:  sdk.Coin{Denom: "test", Amount: sdk.OneInt()},
				BlockInterval: 100,
				ItemInputs: []ItemInput{{
					Id: "!@#",
				}},
			},
			create_err: sdkerrors.ErrInvalidRequest,
			update_err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "Invalid ItemInputs 2",
			create_req: &MsgCreateRecipe{
				Creator:       correctCreatorAddr,
				CookbookId:    "CookbookId",
				Id:            "CookbookId",
				Name:          "testRecipeName",
				Description:   "decdescdescdescdescdescdescdesc",
				Version:       "v0.0.1",
				CostPerBlock:  sdk.Coin{Denom: "test", Amount: sdk.OneInt()},
				BlockInterval: 100,
				ItemInputs: []ItemInput{{
					Id: "test",
					Doubles: []DoubleInputParam{{
						Key:      "test",
						MinValue: valDoubles1,
						MaxValue: valDoubles2,
					}},
				}},
			},
			create_err: sdkerrors.ErrInvalidRequest,
			update_err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "Invalid ItemInputs 3",
			create_req: &MsgCreateRecipe{
				Creator:       correctCreatorAddr,
				CookbookId:    "CookbookId",
				Id:            "CookbookId",
				Name:          "testRecipeName",
				Description:   "decdescdescdescdescdescdescdesc",
				Version:       "v0.0.1",
				CostPerBlock:  sdk.Coin{Denom: "test", Amount: sdk.OneInt()},
				BlockInterval: 100,
				ItemInputs: []ItemInput{{
					Id: "test",
					Doubles: []DoubleInputParam{{
						Key:      "test",
						MinValue: valDoubles3,
						MaxValue: valDoubles1,
					}},
				}},
			},
			create_err: sdkerrors.ErrInvalidRequest,
			update_err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "Invalid ItemInputs 4",
			create_req: &MsgCreateRecipe{
				Creator:       correctCreatorAddr,
				CookbookId:    "CookbookId",
				Id:            "CookbookId",
				Name:          "testRecipeName",
				Description:   "decdescdescdescdescdescdescdesc",
				Version:       "v0.0.1",
				CostPerBlock:  sdk.Coin{Denom: "test", Amount: sdk.OneInt()},
				BlockInterval: 100,
				ItemInputs: []ItemInput{{
					Id: "test",
					Doubles: []DoubleInputParam{
						{Key: "test", MinValue: sdk.OneDec(), MaxValue: valDoubles1},
						{Key: "test", MinValue: sdk.OneDec(), MaxValue: valDoubles1},
					},
				}},
			},
			create_err: sdkerrors.ErrInvalidRequest,
			update_err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "Invalid ItemInputs 5",
			create_req: &MsgCreateRecipe{
				Creator:       correctCreatorAddr,
				CookbookId:    "CookbookId",
				Id:            "CookbookId",
				Name:          "testRecipeName",
				Description:   "decdescdescdescdescdescdescdesc",
				Version:       "v0.0.1",
				CostPerBlock:  sdk.Coin{Denom: "test", Amount: sdk.OneInt()},
				BlockInterval: 100,
				ItemInputs: []ItemInput{{
					Id: "test",
					Doubles: []DoubleInputParam{
						{Key: "test", MinValue: sdk.OneDec(), MaxValue: valDoubles1},
					},
					Longs: []LongInputParam{{
						MinValue: int64(4),
						MaxValue: int64(1),
					}},
				}},
			},
			create_err: sdkerrors.ErrInvalidRequest,
			update_err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "Invalid ItemInputs 6",
			create_req: &MsgCreateRecipe{
				Creator:       correctCreatorAddr,
				CookbookId:    "CookbookId",
				Id:            "CookbookId",
				Name:          "testRecipeName",
				Description:   "decdescdescdescdescdescdescdesc",
				Version:       "v0.0.1",
				CostPerBlock:  sdk.Coin{Denom: "test", Amount: sdk.OneInt()},
				BlockInterval: 100,
				ItemInputs: []ItemInput{{
					Id: "test",
					Doubles: []DoubleInputParam{
						{Key: "test", MinValue: sdk.OneDec(), MaxValue: valDoubles1},
					},
					Longs: []LongInputParam{{
						MinValue: int64(-1),
					}},
				}},
			},
			create_err: sdkerrors.ErrInvalidRequest,
			update_err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "Invalid ItemInputs 7",
			create_req: &MsgCreateRecipe{
				Creator:       correctCreatorAddr,
				CookbookId:    "CookbookId",
				Id:            "CookbookId",
				Name:          "testRecipeName",
				Description:   "decdescdescdescdescdescdescdesc",
				Version:       "v0.0.1",
				CostPerBlock:  sdk.Coin{Denom: "test", Amount: sdk.OneInt()},
				BlockInterval: 100,
				ItemInputs: []ItemInput{{
					Id: "test",
					Doubles: []DoubleInputParam{
						{Key: "test", MinValue: sdk.OneDec(), MaxValue: valDoubles1},
					},
					Longs: []LongInputParam{
						{Key: "test"},
						{Key: "test"},
					},
				}},
			},
			create_err: sdkerrors.ErrInvalidRequest,
			update_err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "Invalid ItemInputs 8",
			create_req: &MsgCreateRecipe{
				Creator:       correctCreatorAddr,
				CookbookId:    "CookbookId",
				Id:            "CookbookId",
				Name:          "testRecipeName",
				Description:   "decdescdescdescdescdescdescdesc",
				Version:       "v0.0.1",
				CostPerBlock:  sdk.Coin{Denom: "test", Amount: sdk.OneInt()},
				BlockInterval: 100,
				ItemInputs: []ItemInput{{
					Id: "test",
					Doubles: []DoubleInputParam{
						{Key: "test", MinValue: sdk.OneDec(), MaxValue: valDoubles1},
					},
					Longs: []LongInputParam{
						{Key: "test", MinValue: int64(1), MaxValue: int64(2)},
					},
					Strings: []StringInputParam{
						{Key: "test"},
						{Key: "test"},
					},
				}},
			},
			create_err: sdkerrors.ErrInvalidRequest,
			update_err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "Invalid Entries 1",
			create_req: &MsgCreateRecipe{
				Creator:       correctCreatorAddr,
				CookbookId:    "CookbookId",
				Id:            "CookbookId",
				Name:          "testRecipeName",
				Description:   "decdescdescdescdescdescdescdesc",
				Version:       "v0.0.1",
				CostPerBlock:  sdk.Coin{Denom: "test", Amount: sdk.OneInt()},
				BlockInterval: 100,
				ItemInputs: []ItemInput{{
					Id: "test",
					Doubles: []DoubleInputParam{
						{Key: "test", MinValue: sdk.OneDec(), MaxValue: valDoubles1},
					},
					Longs: []LongInputParam{
						{Key: "test", MinValue: int64(1), MaxValue: int64(2)},
					},
					Strings: []StringInputParam{
						{Key: "test", Value: ""},
					},
				}},
				Entries: EntriesList{
					CoinOutputs: []CoinOutput{{
						Id:   "!@#",
						Coin: sdk.Coin{Denom: "test", Amount: sdk.OneInt()},
					}},
				},
			},
			create_err: sdkerrors.ErrInvalidRequest,
			update_err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "Invalid Entries 2",
			create_req: &MsgCreateRecipe{
				Creator:       correctCreatorAddr,
				CookbookId:    "CookbookId",
				Id:            "CookbookId",
				Name:          "testRecipeName",
				Description:   "decdescdescdescdescdescdescdesc",
				Version:       "v0.0.1",
				CostPerBlock:  sdk.Coin{Denom: "test", Amount: sdk.OneInt()},
				BlockInterval: 100,
				ItemInputs: []ItemInput{{
					Id: "test",
					Doubles: []DoubleInputParam{
						{Key: "test", MinValue: sdk.OneDec(), MaxValue: valDoubles1},
					},
					Longs: []LongInputParam{
						{Key: "test", MinValue: int64(1), MaxValue: int64(2)},
					},
					Strings: []StringInputParam{
						{Key: "test", Value: ""},
					},
				}},
				Entries: EntriesList{
					CoinOutputs: []CoinOutput{
						{Id: "test", Coin: sdk.Coin{Denom: "test", Amount: sdk.NewInt(1)}},
						{Id: "test", Coin: sdk.Coin{Denom: "test", Amount: sdk.NewInt(1)}},
					},
				},
			},
			create_err: sdkerrors.ErrInvalidRequest,
			update_err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "Invalid Entries 3",
			create_req: &MsgCreateRecipe{
				Creator:       correctCreatorAddr,
				CookbookId:    "CookbookId",
				Id:            "CookbookId",
				Name:          "testRecipeName",
				Description:   "decdescdescdescdescdescdescdesc",
				Version:       "v0.0.1",
				CostPerBlock:  sdk.Coin{Denom: "test", Amount: sdk.OneInt()},
				BlockInterval: 100,
				ItemInputs: []ItemInput{{
					Id: "test",
					Doubles: []DoubleInputParam{
						{Key: "test", MinValue: sdk.OneDec(), MaxValue: valDoubles1},
					},
					Longs: []LongInputParam{
						{Key: "test", MinValue: int64(1), MaxValue: int64(2)},
					},
					Strings: []StringInputParam{
						{Key: "test", Value: ""},
					},
				}},
				Entries: EntriesList{
					CoinOutputs: []CoinOutput{{
						Id:   "test",
						Coin: sdk.Coin{Denom: "test", Amount: sdk.NewInt(-1)},
					}},
				},
			},
			create_err: sdkerrors.ErrInvalidRequest,
			update_err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "Invalid Entries 4",
			create_req: &MsgCreateRecipe{
				Creator:       correctCreatorAddr,
				CookbookId:    "CookbookId",
				Id:            "CookbookId",
				Name:          "testRecipeName",
				Description:   "decdescdescdescdescdescdescdesc",
				Version:       "v0.0.1",
				CostPerBlock:  sdk.Coin{Denom: "test", Amount: sdk.OneInt()},
				BlockInterval: 100,
				ItemInputs: []ItemInput{{
					Id: "test",
					Doubles: []DoubleInputParam{
						{Key: "test", MinValue: sdk.OneDec(), MaxValue: valDoubles1},
					},
					Longs: []LongInputParam{
						{Key: "test", MinValue: int64(1), MaxValue: int64(2)},
					},
					Strings: []StringInputParam{
						{Key: "test", Value: ""},
					},
				}},
				Entries: EntriesList{
					CoinOutputs: []CoinOutput{{
						Id:   "test",
						Coin: sdk.Coin{},
					}},
				},
			},
			create_err: sdkerrors.ErrInvalidRequest,
			update_err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "Invalid Entries 5",
			create_req: &MsgCreateRecipe{
				Creator:       correctCreatorAddr,
				CookbookId:    "CookbookId",
				Id:            "CookbookId",
				Name:          "testRecipeName",
				Description:   "decdescdescdescdescdescdescdesc",
				Version:       "v0.0.1",
				CostPerBlock:  sdk.Coin{Denom: "test", Amount: sdk.OneInt()},
				BlockInterval: 100,
				ItemInputs: []ItemInput{{
					Id: "test",
					Doubles: []DoubleInputParam{
						{Key: "test", MinValue: sdk.OneDec(), MaxValue: valDoubles1},
					},
					Longs: []LongInputParam{
						{Key: "test", MinValue: int64(1), MaxValue: int64(2)},
					},
					Strings: []StringInputParam{
						{Key: "test", Value: ""},
					},
				}},
				Entries: EntriesList{
					CoinOutputs: []CoinOutput{{
						Id:   "test",
						Coin: sdk.Coin{Denom: "ibc/529ba5e3e86ba7796d7caab4fc02728935fbc75c0f7b25a9e611c49dd7d68a35", Amount: sdk.NewInt(1)},
					}},
				},
			},
			create_err: sdkerrors.ErrInvalidRequest,
			update_err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "Invalid Entries 6",
			create_req: &MsgCreateRecipe{
				Creator:       correctCreatorAddr,
				CookbookId:    "CookbookId",
				Id:            "CookbookId",
				Name:          "testRecipeName",
				Description:   "decdescdescdescdescdescdescdesc",
				Version:       "v0.0.1",
				CostPerBlock:  sdk.Coin{Denom: "test", Amount: sdk.OneInt()},
				BlockInterval: 100,
				ItemInputs: []ItemInput{{
					Id: "test",
					Doubles: []DoubleInputParam{
						{Key: "test", MinValue: sdk.OneDec(), MaxValue: valDoubles1},
					},
					Longs: []LongInputParam{
						{Key: "test", MinValue: int64(1), MaxValue: int64(2)},
					},
					Strings: []StringInputParam{
						{Key: "test", Value: ""},
					},
				}},
				Entries: EntriesList{
					CoinOutputs: []CoinOutput{{
						Id:   "test",
						Coin: sdk.Coin{Denom: "test", Amount: sdk.NewInt(1)},
					}},
					ItemOutputs: []ItemOutput{{
						Id: "!@#",
					}},
				},
			},
			create_err: sdkerrors.ErrInvalidRequest,
			update_err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "Invalid Entries 7",
			create_req: &MsgCreateRecipe{
				Creator:       correctCreatorAddr,
				CookbookId:    "CookbookId",
				Id:            "CookbookId",
				Name:          "testRecipeName",
				Description:   "decdescdescdescdescdescdescdesc",
				Version:       "v0.0.1",
				CostPerBlock:  sdk.Coin{Denom: "test", Amount: sdk.OneInt()},
				BlockInterval: 100,
				ItemInputs: []ItemInput{{
					Id: "test",
					Doubles: []DoubleInputParam{
						{Key: "test", MinValue: sdk.OneDec(), MaxValue: valDoubles1},
					},
					Longs: []LongInputParam{
						{Key: "test", MinValue: int64(1), MaxValue: int64(2)},
					},
					Strings: []StringInputParam{
						{Key: "test", Value: ""},
					},
				}},
				Entries: EntriesList{
					CoinOutputs: []CoinOutput{{
						Id:   "test",
						Coin: sdk.Coin{Denom: "test", Amount: sdk.NewInt(1)},
					}},
					ItemOutputs: []ItemOutput{
						{Id: "test"},
						{Id: "test"},
					},
				},
			},
			create_err: sdkerrors.ErrInvalidRequest,
			update_err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "Invalid Entries 8",
			create_req: &MsgCreateRecipe{
				Creator:       correctCreatorAddr,
				CookbookId:    "CookbookId",
				Id:            "CookbookId",
				Name:          "testRecipeName",
				Description:   "decdescdescdescdescdescdescdesc",
				Version:       "v0.0.1",
				CostPerBlock:  sdk.Coin{Denom: "test", Amount: sdk.OneInt()},
				BlockInterval: 100,
				ItemInputs: []ItemInput{{
					Id: "test",
					Doubles: []DoubleInputParam{
						{Key: "test", MinValue: sdk.OneDec(), MaxValue: valDoubles1},
					},
					Longs: []LongInputParam{
						{Key: "test", MinValue: int64(1), MaxValue: int64(2)},
					},
					Strings: []StringInputParam{
						{Key: "test", Value: ""},
					},
				}},
				Entries: EntriesList{
					CoinOutputs: []CoinOutput{{
						Id:   "test",
						Coin: sdk.Coin{Denom: "test", Amount: sdk.NewInt(1)},
					}},
					ItemOutputs: []ItemOutput{{
						Id: "test1",
						Doubles: []DoubleParam{{
							Key: "!@#",
						}},
					}},
				},
			},
			create_err: sdkerrors.ErrInvalidRequest,
			update_err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "Invalid Entries 9",
			create_req: &MsgCreateRecipe{
				Creator:       correctCreatorAddr,
				CookbookId:    "CookbookId",
				Id:            "CookbookId",
				Name:          "testRecipeName",
				Description:   "decdescdescdescdescdescdescdesc",
				Version:       "v0.0.1",
				CostPerBlock:  sdk.Coin{Denom: "test", Amount: sdk.OneInt()},
				BlockInterval: 100,
				ItemInputs: []ItemInput{{
					Id: "test",
					Doubles: []DoubleInputParam{
						{Key: "test", MinValue: sdk.OneDec(), MaxValue: valDoubles1},
					},
					Longs: []LongInputParam{
						{Key: "test", MinValue: int64(1), MaxValue: int64(2)},
					},
					Strings: []StringInputParam{
						{Key: "test", Value: ""},
					},
				}},
				Entries: EntriesList{
					CoinOutputs: []CoinOutput{{
						Id:   "test",
						Coin: sdk.Coin{Denom: "test", Amount: sdk.NewInt(1)},
					}},
					ItemOutputs: []ItemOutput{{
						Id: "test1",
						Doubles: []DoubleParam{
							{Key: "test"},
							{Key: "test"},
						},
					}},
				},
			},
			create_err: sdkerrors.ErrInvalidRequest,
			update_err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "Invalid Entries 10",
			create_req: &MsgCreateRecipe{
				Creator:       correctCreatorAddr,
				CookbookId:    "CookbookId",
				Id:            "CookbookId",
				Name:          "testRecipeName",
				Description:   "decdescdescdescdescdescdescdesc",
				Version:       "v0.0.1",
				CostPerBlock:  sdk.Coin{Denom: "test", Amount: sdk.OneInt()},
				BlockInterval: 100,
				ItemInputs: []ItemInput{{
					Id: "test",
					Doubles: []DoubleInputParam{
						{Key: "test", MinValue: sdk.OneDec(), MaxValue: valDoubles1},
					},
					Longs: []LongInputParam{
						{Key: "test", MinValue: int64(1), MaxValue: int64(2)},
					},
					Strings: []StringInputParam{
						{Key: "test", Value: ""},
					},
				}},
				Entries: EntriesList{
					CoinOutputs: []CoinOutput{{
						Id:   "test",
						Coin: sdk.Coin{Denom: "test", Amount: sdk.NewInt(1)},
					}},
					ItemOutputs: []ItemOutput{{
						Id: "test2",
						Doubles: []DoubleParam{{
							Key: "test",
							WeightRanges: []DoubleWeightRange{{
								Upper: valDoubles2,
								Lower: valDoubles1,
							}},
						}},
					}},
				},
			},
			create_err: sdkerrors.ErrInvalidRequest,
			update_err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "Invalid Entries 11",
			create_req: &MsgCreateRecipe{
				Creator:       correctCreatorAddr,
				CookbookId:    "CookbookId",
				Id:            "CookbookId",
				Name:          "testRecipeName",
				Description:   "decdescdescdescdescdescdescdesc",
				Version:       "v0.0.1",
				CostPerBlock:  sdk.Coin{Denom: "test", Amount: sdk.OneInt()},
				BlockInterval: 100,
				ItemInputs: []ItemInput{{
					Id: "test",
					Doubles: []DoubleInputParam{
						{Key: "test", MinValue: sdk.OneDec(), MaxValue: valDoubles1},
					},
					Longs: []LongInputParam{
						{Key: "test", MinValue: int64(1), MaxValue: int64(2)},
					},
					Strings: []StringInputParam{
						{Key: "test", Value: ""},
					},
				}},
				Entries: EntriesList{
					CoinOutputs: []CoinOutput{{
						Id:   "test",
						Coin: sdk.Coin{Denom: "test", Amount: sdk.NewInt(1)},
					}},
					ItemOutputs: []ItemOutput{{
						Id: "test3",
						Doubles: []DoubleParam{{
							Key: "test",
							WeightRanges: []DoubleWeightRange{{
								Upper: valDoubles1,
								Lower: valDoubles3,
							}},
						}},
					}},
				},
			},
			create_err: sdkerrors.ErrInvalidRequest,
			update_err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "Invalid Entries 12",
			create_req: &MsgCreateRecipe{
				Creator:       correctCreatorAddr,
				CookbookId:    "CookbookId",
				Id:            "CookbookId",
				Name:          "testRecipeName",
				Description:   "decdescdescdescdescdescdescdesc",
				Version:       "v0.0.1",
				CostPerBlock:  sdk.Coin{Denom: "test", Amount: sdk.OneInt()},
				BlockInterval: 100,
				ItemInputs: []ItemInput{{
					Id: "test",
					Doubles: []DoubleInputParam{
						{Key: "test", MinValue: sdk.OneDec(), MaxValue: valDoubles1},
					},
					Longs: []LongInputParam{
						{Key: "test", MinValue: int64(1), MaxValue: int64(2)},
					},
					Strings: []StringInputParam{
						{Key: "test", Value: ""},
					},
				}},
				Entries: EntriesList{
					CoinOutputs: []CoinOutput{{
						Id:   "test",
						Coin: sdk.Coin{Denom: "test", Amount: sdk.NewInt(1)},
					}},
					ItemOutputs: []ItemOutput{{
						Id: "test4",
						Doubles: []DoubleParam{{
							Key: "test",
							WeightRanges: []DoubleWeightRange{{
								Upper: valDoubles1,
								Lower: valDoubles2,
							}},
						}},
						Longs: []LongParam{{
							Key: "!@#",
						}},
					}},
				},
			},
			create_err: sdkerrors.ErrInvalidRequest,
			update_err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "Invalid Entries 13",
			create_req: &MsgCreateRecipe{
				Creator:       correctCreatorAddr,
				CookbookId:    "CookbookId",
				Id:            "CookbookId",
				Name:          "testRecipeName",
				Description:   "decdescdescdescdescdescdescdesc",
				Version:       "v0.0.1",
				CostPerBlock:  sdk.Coin{Denom: "test", Amount: sdk.OneInt()},
				BlockInterval: 100,
				ItemInputs: []ItemInput{{
					Id: "test",
					Doubles: []DoubleInputParam{
						{Key: "test", MinValue: sdk.OneDec(), MaxValue: valDoubles1},
					},
					Longs: []LongInputParam{
						{Key: "test", MinValue: int64(1), MaxValue: int64(2)},
					},
					Strings: []StringInputParam{
						{Key: "test", Value: ""},
					},
				}},
				Entries: EntriesList{
					CoinOutputs: []CoinOutput{{
						Id:   "test",
						Coin: sdk.Coin{Denom: "test", Amount: sdk.NewInt(1)},
					}},
					ItemOutputs: []ItemOutput{{
						Id: "test4",
						Doubles: []DoubleParam{{
							Key: "test",
							WeightRanges: []DoubleWeightRange{{
								Upper: valDoubles1,
								Lower: valDoubles2,
							}},
						}},
						Longs: []LongParam{
							{Key: "test"},
							{Key: "test"},
						},
					}},
				},
			},
			create_err: sdkerrors.ErrInvalidRequest,
			update_err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "Invalid Entries 14",
			create_req: &MsgCreateRecipe{
				Creator:       correctCreatorAddr,
				CookbookId:    "CookbookId",
				Id:            "CookbookId",
				Name:          "testRecipeName",
				Description:   "decdescdescdescdescdescdescdesc",
				Version:       "v0.0.1",
				CostPerBlock:  sdk.Coin{Denom: "test", Amount: sdk.OneInt()},
				BlockInterval: 100,
				ItemInputs: []ItemInput{{
					Id: "test",
					Doubles: []DoubleInputParam{
						{Key: "test", MinValue: sdk.OneDec(), MaxValue: valDoubles1},
					},
					Longs: []LongInputParam{
						{Key: "test", MinValue: int64(1), MaxValue: int64(2)},
					},
					Strings: []StringInputParam{
						{Key: "test", Value: ""},
					},
				}},
				Entries: EntriesList{
					CoinOutputs: []CoinOutput{{
						Id:   "test",
						Coin: sdk.Coin{Denom: "test", Amount: sdk.NewInt(1)},
					}},
					ItemOutputs: []ItemOutput{{
						Id: "test4",
						Doubles: []DoubleParam{{
							Key: "test",
							WeightRanges: []DoubleWeightRange{{
								Upper: valDoubles1,
								Lower: valDoubles2,
							}},
						}},
						Longs: []LongParam{{
							Key: "test",
							WeightRanges: []IntWeightRange{{
								Lower: int64(4),
								Upper: int64(1),
							}},
						}},
					}},
				},
			},
			create_err: sdkerrors.ErrInvalidRequest,
			update_err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "Invalid Entries 15",
			create_req: &MsgCreateRecipe{
				Creator:       correctCreatorAddr,
				CookbookId:    "CookbookId",
				Id:            "CookbookId",
				Name:          "testRecipeName",
				Description:   "decdescdescdescdescdescdescdesc",
				Version:       "v0.0.1",
				CostPerBlock:  sdk.Coin{Denom: "test", Amount: sdk.OneInt()},
				BlockInterval: 100,
				ItemInputs: []ItemInput{{
					Id: "test",
					Doubles: []DoubleInputParam{
						{Key: "test", MinValue: sdk.OneDec(), MaxValue: valDoubles1},
					},
					Longs: []LongInputParam{
						{Key: "test", MinValue: int64(1), MaxValue: int64(2)},
					},
					Strings: []StringInputParam{
						{Key: "test", Value: ""},
					},
				}},
				Entries: EntriesList{
					CoinOutputs: []CoinOutput{{
						Id:   "test",
						Coin: sdk.Coin{Denom: "test", Amount: sdk.NewInt(1)},
					}},
					ItemOutputs: []ItemOutput{{
						Id: "test4",
						Doubles: []DoubleParam{{
							Key: "test",
							WeightRanges: []DoubleWeightRange{{
								Upper: valDoubles1,
								Lower: valDoubles2,
							}},
						}},
						Longs: []LongParam{{
							Key: "test",
							WeightRanges: []IntWeightRange{{
								Lower: int64(-1),
								Upper: int64(1),
							}},
						}},
					}},
				},
			},
			create_err: sdkerrors.ErrInvalidRequest,
			update_err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "Invalid Entries 16",
			create_req: &MsgCreateRecipe{
				Creator:       correctCreatorAddr,
				CookbookId:    "CookbookId",
				Id:            "CookbookId",
				Name:          "testRecipeName",
				Description:   "decdescdescdescdescdescdescdesc",
				Version:       "v0.0.1",
				CostPerBlock:  sdk.Coin{Denom: "test", Amount: sdk.OneInt()},
				BlockInterval: 100,
				ItemInputs: []ItemInput{{
					Id: "test",
					Doubles: []DoubleInputParam{
						{Key: "test", MinValue: sdk.OneDec(), MaxValue: valDoubles1},
					},
					Longs: []LongInputParam{
						{Key: "test", MinValue: int64(1), MaxValue: int64(2)},
					},
					Strings: []StringInputParam{
						{Key: "test", Value: ""},
					},
				}},
				Entries: EntriesList{
					CoinOutputs: []CoinOutput{{
						Id:   "test",
						Coin: sdk.Coin{Denom: "test", Amount: sdk.NewInt(1)},
					}},
					ItemOutputs: []ItemOutput{{
						Id: "test4",
						Doubles: []DoubleParam{{
							Key: "test",
							WeightRanges: []DoubleWeightRange{{
								Upper: valDoubles1,
								Lower: valDoubles2,
							}},
						}},
						Longs: []LongParam{{
							Key: "test",
							WeightRanges: []IntWeightRange{{
								Lower: int64(1),
								Upper: int64(4),
							}},
						}},
						Strings: []StringParam{{
							Key: "!@#",
						}},
					}},
				},
			},
			create_err: sdkerrors.ErrInvalidRequest,
			update_err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "Invalid Entries 17",
			create_req: &MsgCreateRecipe{
				Creator:       correctCreatorAddr,
				CookbookId:    "CookbookId",
				Id:            "CookbookId",
				Name:          "testRecipeName",
				Description:   "decdescdescdescdescdescdescdesc",
				Version:       "v0.0.1",
				CostPerBlock:  sdk.Coin{Denom: "test", Amount: sdk.OneInt()},
				BlockInterval: 100,
				ItemInputs: []ItemInput{{
					Id: "test",
					Doubles: []DoubleInputParam{
						{Key: "test", MinValue: sdk.OneDec(), MaxValue: valDoubles1},
					},
					Longs: []LongInputParam{
						{Key: "test", MinValue: int64(1), MaxValue: int64(2)},
					},
					Strings: []StringInputParam{
						{Key: "test", Value: ""},
					},
				}},
				Entries: EntriesList{
					CoinOutputs: []CoinOutput{{
						Id:   "test",
						Coin: sdk.Coin{Denom: "test", Amount: sdk.NewInt(1)},
					}},
					ItemOutputs: []ItemOutput{{
						Id: "test4",
						Doubles: []DoubleParam{{
							Key: "test",
							WeightRanges: []DoubleWeightRange{{
								Upper: valDoubles1,
								Lower: valDoubles2,
							}},
						}},
						Longs: []LongParam{{
							Key: "test",
							WeightRanges: []IntWeightRange{{
								Lower: int64(1),
								Upper: int64(4),
							}},
						}},
						Strings: []StringParam{
							{Key: "test"},
							{Key: "test"},
						},
					}},
				},
			},
			create_err: sdkerrors.ErrInvalidRequest,
			update_err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "Invalid Entries 18",
			create_req: &MsgCreateRecipe{
				Creator:       correctCreatorAddr,
				CookbookId:    "CookbookId",
				Id:            "CookbookId",
				Name:          "testRecipeName",
				Description:   "decdescdescdescdescdescdescdesc",
				Version:       "v0.0.1",
				CostPerBlock:  sdk.Coin{Denom: "test", Amount: sdk.OneInt()},
				BlockInterval: 100,
				ItemInputs: []ItemInput{{
					Id: "test",
					Doubles: []DoubleInputParam{
						{Key: "test", MinValue: sdk.OneDec(), MaxValue: valDoubles1},
					},
					Longs: []LongInputParam{
						{Key: "test", MinValue: int64(1), MaxValue: int64(2)},
					},
					Strings: []StringInputParam{
						{Key: "test", Value: ""},
					},
				}},
				Entries: EntriesList{
					CoinOutputs: []CoinOutput{{
						Id:   "test",
						Coin: sdk.Coin{Denom: "test", Amount: sdk.NewInt(1)},
					}},
					ItemOutputs: []ItemOutput{{
						Id: "test4",
						Doubles: []DoubleParam{{
							Key: "test",
							WeightRanges: []DoubleWeightRange{{
								Upper: valDoubles1,
								Lower: valDoubles2,
							}},
						}},
						Longs: []LongParam{{
							Key: "test",
							WeightRanges: []IntWeightRange{{
								Lower: int64(1),
								Upper: int64(4),
							}},
						}},
						Strings: []StringParam{{
							Key: "test",
						}},
						MutableStrings: []StringKeyValue{{
							Key: "!@#",
						}},
					}},
				},
			},
			create_err: sdkerrors.ErrInvalidRequest,
			update_err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "Invalid Entries 19",
			create_req: &MsgCreateRecipe{
				Creator:       correctCreatorAddr,
				CookbookId:    "CookbookId",
				Id:            "CookbookId",
				Name:          "testRecipeName",
				Description:   "decdescdescdescdescdescdescdesc",
				Version:       "v0.0.1",
				CostPerBlock:  sdk.Coin{Denom: "test", Amount: sdk.OneInt()},
				BlockInterval: 100,
				ItemInputs: []ItemInput{{
					Id: "test",
					Doubles: []DoubleInputParam{
						{Key: "test", MinValue: sdk.OneDec(), MaxValue: valDoubles1},
					},
					Longs: []LongInputParam{
						{Key: "test", MinValue: int64(1), MaxValue: int64(2)},
					},
					Strings: []StringInputParam{
						{Key: "test", Value: ""},
					},
				}},
				Entries: EntriesList{
					CoinOutputs: []CoinOutput{{
						Id:   "test",
						Coin: sdk.Coin{Denom: "test", Amount: sdk.NewInt(1)},
					}},
					ItemOutputs: []ItemOutput{{
						Id: "test4",
						Doubles: []DoubleParam{{
							Key: "test",
							WeightRanges: []DoubleWeightRange{{
								Upper: valDoubles1,
								Lower: valDoubles2,
							}},
						}},
						Longs: []LongParam{{
							Key: "test",
							WeightRanges: []IntWeightRange{{
								Lower: int64(1),
								Upper: int64(4),
							}},
						}},
						Strings: []StringParam{{
							Key: "test",
						}},
						MutableStrings: []StringKeyValue{
							{Key: "test"},
							{Key: "test"},
						},
					}},
				},
			},
			create_err: sdkerrors.ErrInvalidRequest,
			update_err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "Invalid Entries 20",
			create_req: &MsgCreateRecipe{
				Creator:       correctCreatorAddr,
				CookbookId:    "CookbookId",
				Id:            "CookbookId",
				Name:          "testRecipeName",
				Description:   "decdescdescdescdescdescdescdesc",
				Version:       "v0.0.1",
				CostPerBlock:  sdk.Coin{Denom: "test", Amount: sdk.OneInt()},
				BlockInterval: 100,
				ItemInputs: []ItemInput{{
					Id: "test",
					Doubles: []DoubleInputParam{
						{Key: "test", MinValue: sdk.OneDec(), MaxValue: valDoubles1},
					},
					Longs: []LongInputParam{
						{Key: "test", MinValue: int64(1), MaxValue: int64(2)},
					},
					Strings: []StringInputParam{
						{Key: "test", Value: ""},
					},
				}},
				Entries: EntriesList{
					CoinOutputs: []CoinOutput{{
						Id:   "test",
						Coin: sdk.Coin{Denom: "test", Amount: sdk.NewInt(1)},
					}},
					ItemOutputs: []ItemOutput{{
						Id: "test4",
						Doubles: []DoubleParam{{
							Key: "test",
							WeightRanges: []DoubleWeightRange{{
								Upper: valDoubles1,
								Lower: valDoubles2,
							}},
						}},
						Longs: []LongParam{{
							Key: "test",
							WeightRanges: []IntWeightRange{{
								Lower: int64(1),
								Upper: int64(4),
							}},
						}},
						Strings: []StringParam{{
							Key: "test",
						}},
						MutableStrings: []StringKeyValue{{
							Key: "test",
						}},
						TradePercentage: valDoubles3,
					}},
				},
			},
			create_err: sdkerrors.ErrInvalidRequest,
			update_err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "Invalid Entries 21",
			create_req: &MsgCreateRecipe{
				Creator:       correctCreatorAddr,
				CookbookId:    "CookbookId",
				Id:            "CookbookId",
				Name:          "testRecipeName",
				Description:   "decdescdescdescdescdescdescdesc",
				Version:       "v0.0.1",
				CostPerBlock:  sdk.Coin{Denom: "test", Amount: sdk.OneInt()},
				BlockInterval: 100,
				ItemInputs: []ItemInput{{
					Id: "test",
					Doubles: []DoubleInputParam{
						{Key: "test", MinValue: sdk.OneDec(), MaxValue: valDoubles1},
					},
					Longs: []LongInputParam{
						{Key: "test", MinValue: int64(1), MaxValue: int64(2)},
					},
					Strings: []StringInputParam{
						{Key: "test", Value: ""},
					},
				}},
				Entries: EntriesList{
					CoinOutputs: []CoinOutput{{
						Id:   "test",
						Coin: sdk.Coin{Denom: "test", Amount: sdk.NewInt(1)},
					}},
					ItemOutputs: []ItemOutput{{
						Id: "test4",
						Doubles: []DoubleParam{{
							Key: "test",
							WeightRanges: []DoubleWeightRange{{
								Upper: valDoubles1,
								Lower: valDoubles2,
							}},
						}},
						Longs: []LongParam{{
							Key: "test",
							WeightRanges: []IntWeightRange{{
								Lower: int64(1),
								Upper: int64(4),
							}},
						}},
						Strings: []StringParam{{
							Key: "test",
						}},
						MutableStrings: []StringKeyValue{{
							Key: "test",
						}},
						TradePercentage: sdk.ZeroDec(),
						TransferFee: []sdk.Coin{{
							Denom: "!@#",
						}},
					}},
				},
			},
			create_err: sdkerrors.ErrInvalidRequest,
			update_err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "Invalid Entries 22",
			create_req: &MsgCreateRecipe{
				Creator:       correctCreatorAddr,
				CookbookId:    "CookbookId",
				Id:            "CookbookId",
				Name:          "testRecipeName",
				Description:   "decdescdescdescdescdescdescdesc",
				Version:       "v0.0.1",
				CostPerBlock:  sdk.Coin{Denom: "test", Amount: sdk.OneInt()},
				BlockInterval: 100,
				ItemInputs: []ItemInput{{
					Id: "test",
					Doubles: []DoubleInputParam{
						{Key: "test", MinValue: sdk.OneDec(), MaxValue: valDoubles1},
					},
					Longs: []LongInputParam{
						{Key: "test", MinValue: int64(1), MaxValue: int64(2)},
					},
					Strings: []StringInputParam{
						{Key: "test", Value: ""},
					},
				}},
				Entries: EntriesList{
					CoinOutputs: []CoinOutput{{
						Id:   "test",
						Coin: sdk.Coin{Denom: "test", Amount: sdk.NewInt(1)},
					}},
					ItemOutputs: []ItemOutput{{
						Id: "test4",
						Doubles: []DoubleParam{{
							Key: "test",
							WeightRanges: []DoubleWeightRange{{
								Upper: valDoubles1,
								Lower: valDoubles2,
							}},
						}},
						Longs: []LongParam{{
							Key: "test",
							WeightRanges: []IntWeightRange{{
								Lower: int64(1),
								Upper: int64(4),
							}},
						}},
						Strings: []StringParam{{
							Key: "test",
						}},
						MutableStrings: []StringKeyValue{{
							Key: "test",
						}},
						TradePercentage: sdk.ZeroDec(),
						TransferFee: []sdk.Coin{{
							Denom:  "test",
							Amount: sdk.NewInt(-1),
						}},
					}},
				},
			},
			create_err: sdkerrors.ErrInvalidRequest,
			update_err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "Invalid Outputs",
			create_req: &MsgCreateRecipe{
				Creator:       correctCreatorAddr,
				CookbookId:    "CookbookId",
				Id:            "CookbookId",
				Name:          "testRecipeName",
				Description:   "decdescdescdescdescdescdescdesc",
				Version:       "v0.0.1",
				CostPerBlock:  sdk.Coin{Denom: "test", Amount: sdk.OneInt()},
				BlockInterval: 100,
				ItemInputs: []ItemInput{{
					Id: "test",
					Doubles: []DoubleInputParam{
						{Key: "test", MinValue: sdk.OneDec(), MaxValue: valDoubles1},
					},
					Longs: []LongInputParam{
						{Key: "test", MinValue: int64(1), MaxValue: int64(2)},
					},
					Strings: []StringInputParam{
						{Key: "test", Value: ""},
					},
				}},
				Entries: EntriesList{
					CoinOutputs: []CoinOutput{{
						Id:   "test",
						Coin: sdk.Coin{Denom: "test", Amount: sdk.NewInt(1)},
					}},
					ItemOutputs: []ItemOutput{{
						Id: "test4",
						Doubles: []DoubleParam{{
							Key: "test",
							WeightRanges: []DoubleWeightRange{{
								Upper: valDoubles1,
								Lower: valDoubles2,
							}},
						}},
						Longs: []LongParam{{
							Key: "test",
							WeightRanges: []IntWeightRange{{
								Lower: int64(1),
								Upper: int64(4),
							}},
						}},
						Strings: []StringParam{{
							Key: "test",
						}},
						MutableStrings: []StringKeyValue{{
							Key: "test",
						}},
						TradePercentage: sdk.ZeroDec(),
						TransferFee: []sdk.Coin{{
							Denom:  "test",
							Amount: sdk.NewInt(1),
						}},
					}},
				},
				Outputs: []WeightedOutputs{{
					EntryIds: []string{"test", "test1"},
					Weight:   0,
				}},
			},
			create_err: sdkerrors.ErrInvalidRequest,
			update_err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "Invalid EntriesLen and Weight",
			create_req: &MsgCreateRecipe{
				Creator:       correctCreatorAddr,
				CookbookId:    "CookbookId",
				Id:            "CookbookId",
				Name:          "testRecipeName",
				Description:   "decdescdescdescdescdescdescdesc",
				Version:       "v0.0.1",
				CostPerBlock:  sdk.Coin{Denom: "test", Amount: sdk.OneInt()},
				BlockInterval: 100,
				ItemInputs: []ItemInput{{
					Id: "test",
					Doubles: []DoubleInputParam{
						{Key: "test", MinValue: sdk.OneDec(), MaxValue: valDoubles1},
					},
					Longs: []LongInputParam{
						{Key: "test", MinValue: int64(1), MaxValue: int64(2)},
					},
					Strings: []StringInputParam{
						{Key: "test", Value: ""},
					},
				}},
				Entries: EntriesList{
					CoinOutputs: []CoinOutput{{
						Id:   "test",
						Coin: sdk.Coin{Denom: "test", Amount: sdk.NewInt(1)},
					}},
					ItemOutputs: []ItemOutput{{
						Id: "test4",
						Doubles: []DoubleParam{{
							Key: "test",
							WeightRanges: []DoubleWeightRange{{
								Upper: valDoubles1,
								Lower: valDoubles2,
							}},
						}},
						Longs: []LongParam{{
							Key: "test",
							WeightRanges: []IntWeightRange{{
								Lower: int64(1),
								Upper: int64(4),
							}},
						}},
						Strings: []StringParam{{
							Key: "test",
						}},
						MutableStrings: []StringKeyValue{{
							Key: "test",
						}},
						TradePercentage: sdk.ZeroDec(),
						TransferFee: []sdk.Coin{{
							Denom:  "test",
							Amount: sdk.NewInt(1),
						}},
					}},
				},
				Outputs: []WeightedOutputs{{
					EntryIds: []string{"test4"},
					Weight:   0,
				}},
			},
			create_err: sdkerrors.ErrInvalidRequest,
			update_err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "Invalid CoinOutputs list 1",
			create_req: &MsgCreateRecipe{
				Creator:       correctCreatorAddr,
				CookbookId:    "invalid",
				Id:            "CookbookId",
				Name:          "testRecipeName",
				Description:   "decdescdescdescdescdescdescdesc",
				Version:       "v0.0.1",
				CostPerBlock:  sdk.Coin{Denom: "test", Amount: sdk.OneInt()},
				BlockInterval: 100,
				ItemInputs: []ItemInput{{
					Id: "test",
					Doubles: []DoubleInputParam{
						{Key: "test", MinValue: sdk.OneDec(), MaxValue: valDoubles1},
					},
					Longs: []LongInputParam{
						{Key: "test", MinValue: int64(1), MaxValue: int64(2)},
					},
					Strings: []StringInputParam{
						{Key: "test", Value: ""},
					},
				}},
				Entries: EntriesList{
					CoinOutputs: []CoinOutput{{
						Id:      "test1",
						Coin:    sdk.Coin{Denom: "cookbookID/denom1", Amount: sdk.OneInt()},
						Program: "",
					}},
					ItemOutputs: []ItemOutput{{
						Id: "test4",
						Doubles: []DoubleParam{{
							Key: "test",
							WeightRanges: []DoubleWeightRange{{
								Upper: valDoubles1,
								Lower: valDoubles2,
							}},
						}},
						Longs: []LongParam{{
							Key: "test",
							WeightRanges: []IntWeightRange{{
								Lower: int64(1),
								Upper: int64(4),
							}},
						}},
						Strings: []StringParam{{
							Key: "test",
						}},
						MutableStrings: []StringKeyValue{{
							Key: "test",
						}},
						TradePercentage: sdk.ZeroDec(),
						TransferFee: []sdk.Coin{{
							Denom:  "test",
							Amount: sdk.NewInt(1),
						}},
					}},
				},
				Outputs: []WeightedOutputs{{
					EntryIds: []string{"test4"},
					Weight:   1,
				}},
			},
			create_err: sdkerrors.ErrInvalidRequest,
			update_err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "Invalid CoinOutputs list 2",
			create_req: &MsgCreateRecipe{
				Creator:       correctCreatorAddr,
				CookbookId:    "invalid",
				Id:            "CookbookId",
				Name:          "testRecipeName",
				Description:   "decdescdescdescdescdescdescdesc",
				Version:       "v0.0.1",
				CostPerBlock:  sdk.Coin{Denom: "test", Amount: sdk.OneInt()},
				BlockInterval: 100,
				ItemInputs: []ItemInput{{
					Id: "test",
					Doubles: []DoubleInputParam{
						{Key: "test", MinValue: sdk.OneDec(), MaxValue: valDoubles1},
					},
					Longs: []LongInputParam{
						{Key: "test", MinValue: int64(1), MaxValue: int64(2)},
					},
					Strings: []StringInputParam{
						{Key: "test", Value: ""},
					},
				}},
				Entries: EntriesList{
					CoinOutputs: []CoinOutput{{
						Id:      "test1",
						Coin:    sdk.Coin{Denom: "cookbookID/", Amount: sdk.OneInt()},
						Program: "",
					}},
					ItemOutputs: []ItemOutput{{
						Id: "test4",
						Doubles: []DoubleParam{{
							Key: "test",
							WeightRanges: []DoubleWeightRange{{
								Upper: valDoubles1,
								Lower: valDoubles2,
							}},
						}},
						Longs: []LongParam{{
							Key: "test",
							WeightRanges: []IntWeightRange{{
								Lower: int64(1),
								Upper: int64(4),
							}},
						}},
						Strings: []StringParam{{
							Key: "test",
						}},
						MutableStrings: []StringKeyValue{{
							Key: "test",
						}},
						TradePercentage: sdk.ZeroDec(),
						TransferFee: []sdk.Coin{{
							Denom:  "test",
							Amount: sdk.NewInt(1),
						}},
					}},
				},
				Outputs: []WeightedOutputs{{
					EntryIds: []string{"test4"},
					Weight:   1,
				}},
			},
			create_err: sdkerrors.ErrInvalidRequest,
			update_err: sdkerrors.ErrInvalidRequest,
		},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			tc.update_req = (*MsgUpdateRecipe)(tc.create_req)
			create_err := tc.create_req.ValidateBasic()
			if tc.desc == "Invalid CoinOutputs list 1" {
				tc.update_req.Entries.CoinOutputs = append(tc.update_req.Entries.CoinOutputs, CoinOutput{Id: "test1", Coin: sdk.Coin{Denom: "cookbookID/denom2", Amount: sdk.OneInt()}})
			}
			if tc.desc == "Invalid CoinOutputs list 2" {
				tc.update_req.Entries.CoinOutputs = append(tc.update_req.Entries.CoinOutputs, CoinOutput{Id: "test1", Coin: sdk.Coin{Denom: "cookbookID2/", Amount: sdk.OneInt()}})
			}
			update_err := tc.update_req.ValidateBasic()
			if create_err != nil {
				require.ErrorIs(t, create_err, tc.create_err)
			} else {
				require.NoError(t, tc.create_err)
			}
			if update_err != nil {
				require.ErrorIs(t, update_err, tc.update_err)
			} else {
				require.NoError(t, tc.update_err)
			}
		})
	}
}
