package types

import (
	"testing"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	"github.com/stretchr/testify/require"
)

func TestMsgExecuteRecipeValidateBasic(t *testing.T) {
	correctAddr := "cosmos1n67vdlaejpj3uzswr9qapeg76zlkusj5k875ma"
	invalidAddr := "pylo1xn72u3jxlpqx8tfgmjf0xg970q36xensjngsme"
	for _, tc := range []struct {
		desc string
		req  *MsgExecuteRecipe
		err  error
	}{
		{
			desc: "Valid",
			req: &MsgExecuteRecipe{
				Creator:         correctAddr,
				CookbookId:      "testCookbookID",
				RecipeId:        "testRecipeID",
				CoinInputsIndex: 0,
				ItemIds:         nil,
				PaymentInfos: []PaymentInfo{{
					PurchaseId:    "test",
					ProcessorName: "test",
					PayerAddr:     GenTestBech32FromString("test"),
					Amount:        sdk.OneInt(),
					ProductId:     "test",
					Signature:     "test",
				}},
			},
			err: nil,
		},
		{
			desc: "Invalid creator address 1",
			req: &MsgExecuteRecipe{
				Creator: "",
			},
			err: sdkerrors.ErrInvalidAddress,
		},
		{
			desc: "Invalid creator address 2",
			req: &MsgExecuteRecipe{
				Creator: invalidAddr,
			},
			err: sdkerrors.ErrInvalidAddress,
		},
		{
			desc: "Invalid creator address 3",
			req: &MsgExecuteRecipe{
				Creator: "test",
			},
			err: sdkerrors.ErrInvalidAddress,
		},
		{
			desc: "Invalid CookbookId",
			req: &MsgExecuteRecipe{
				Creator:         correctAddr,
				CookbookId:      " test $%",
				RecipeId:        "testRecipeID",
				CoinInputsIndex: 0,
				ItemIds:         nil,
			},
			err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "Invalid RecipeId",
			req: &MsgExecuteRecipe{
				Creator:         correctAddr,
				CookbookId:      "testCookbookID",
				RecipeId:        " test $%",
				CoinInputsIndex: 0,
				ItemIds:         nil,
			},
			err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "Invalid ItemIds",
			req: &MsgExecuteRecipe{
				Creator:         correctAddr,
				CookbookId:      "testCookbookID",
				RecipeId:        "testRecipeID",
				CoinInputsIndex: 0,
				ItemIds:         []string{"111111111"},
			},
			err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "Invalid PaymentInfos 1",
			req: &MsgExecuteRecipe{
				Creator:         correctAddr,
				CookbookId:      "testCookbookID",
				RecipeId:        "testRecipeID",
				CoinInputsIndex: 0,
				ItemIds:         nil,
				PaymentInfos: []PaymentInfo{{
					PurchaseId:    "",
					ProcessorName: "test",
					PayerAddr:     GenTestBech32FromString("test"),
					Amount:        sdk.OneInt(),
					ProductId:     "test",
					Signature:     "test",
				}},
			},
			err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "Invalid PaymentInfos 2",
			req: &MsgExecuteRecipe{
				Creator:         correctAddr,
				CookbookId:      "testCookbookID",
				RecipeId:        "testRecipeID",
				CoinInputsIndex: 0,
				ItemIds:         nil,
				PaymentInfos: []PaymentInfo{{
					PurchaseId:    "test",
					ProcessorName: "test",
					PayerAddr:     GenTestBech32FromString("test"),
					Amount:        sdk.OneInt(),
					ProductId:     "",
					Signature:     "test",
				}},
			},
			err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "Invalid PaymentInfos 3",
			req: &MsgExecuteRecipe{
				Creator:         correctAddr,
				CookbookId:      "testCookbookID",
				RecipeId:        "testRecipeID",
				CoinInputsIndex: 0,
				ItemIds:         nil,
				PaymentInfos: []PaymentInfo{{
					PurchaseId:    "test",
					ProcessorName: "test",
					PayerAddr:     GenTestBech32FromString("test"),
					Amount:        sdk.OneInt(),
					ProductId:     "test",
					Signature:     "",
				}},
			},
			err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "Invalid PaymentInfos 4",
			req: &MsgExecuteRecipe{
				Creator:         correctAddr,
				CookbookId:      "testCookbookID",
				RecipeId:        "testRecipeID",
				CoinInputsIndex: 0,
				ItemIds:         nil,
				PaymentInfos: []PaymentInfo{{
					PurchaseId:    "test",
					ProcessorName: "test",
					PayerAddr:     GenTestBech32FromString("test"),
					Amount:        sdk.ZeroInt(),
					ProductId:     "test",
					Signature:     "test",
				}},
			},
			err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "Invalid PaymentInfos 5",
			req: &MsgExecuteRecipe{
				Creator:         correctAddr,
				CookbookId:      "testCookbookID",
				RecipeId:        "testRecipeID",
				CoinInputsIndex: 0,
				ItemIds:         nil,
				PaymentInfos: []PaymentInfo{{
					PurchaseId:    "test",
					ProcessorName: "test",
					PayerAddr:     "test",
					Amount:        sdk.OneInt(),
					ProductId:     "test",
					Signature:     "test",
				}},
			},
			err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "Invalid PaymentInfos 6",
			req: &MsgExecuteRecipe{
				Creator:         correctAddr,
				CookbookId:      "testCookbookID",
				RecipeId:        "testRecipeID",
				CoinInputsIndex: 0,
				ItemIds:         nil,
				PaymentInfos: []PaymentInfo{{
					PurchaseId:    "test",
					ProcessorName: "",
					PayerAddr:     GenTestBech32FromString("test"),
					Amount:        sdk.OneInt(),
					ProductId:     "test",
					Signature:     "test",
				}},
			},
			err: sdkerrors.ErrInvalidRequest,
		},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			err := tc.req.ValidateBasic()
			if err != nil {
				require.ErrorIs(t, err, tc.err)
			} else {
				require.NoError(t, tc.err)
			}
		})
	}
}
