package types

import (
	"testing"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	"github.com/stretchr/testify/require"
)

func TestMsgFulfillTradeValidateBasic(t *testing.T) {
	correctAddr := "cosmos1n67vdlaejpj3uzswr9qapeg76zlkusj5k875ma"
	invalidAddr := "pylo1xn72u3jxlpqx8tfgmjf0xg970q36xensjngsme"
	for index, tc := range []struct {
		desc string
		req  *MsgFulfillTrade
		err  error
	}{
		{
			desc: "Valid",
			req: &MsgFulfillTrade{
				Creator:         correctAddr,
				CoinInputsIndex: 0,
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
			req: &MsgFulfillTrade{
				Creator: "",
			},
			err: sdkerrors.ErrInvalidAddress,
		},
		{
			desc: "Invalid creator address 2",
			req: &MsgFulfillTrade{
				Creator: invalidAddr,
			},
			err: sdkerrors.ErrInvalidAddress,
		},
		{
			desc: "Invalid creator address 3",
			req: &MsgFulfillTrade{
				Creator: "test",
			},
			err: sdkerrors.ErrInvalidAddress,
		},
		{
			desc: "Invalid ItemId",
			req: &MsgFulfillTrade{
				Creator: correctAddr,
				Items: []ItemRef{{
					ItemId: "111111111",
				}},
				CoinInputsIndex: 0,
			},
			err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "Invalid CookbookId",
			req: &MsgFulfillTrade{
				Creator: correctAddr,
				Items: []ItemRef{{
					CookbookId: "1",
					ItemId:     EncodeItemID(1234),
				}},
				CoinInputsIndex: 0,
			},
			err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "Invalid PaymentInfos 1",
			req: &MsgFulfillTrade{
				Creator:         correctAddr,
				CoinInputsIndex: 0,
				Items: []ItemRef{{
					CookbookId: "testCookbook",
					ItemId:     EncodeItemID(1234),
				}},
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
			req: &MsgFulfillTrade{
				Creator:         correctAddr,
				CoinInputsIndex: 0,
				Items: []ItemRef{{
					CookbookId: "testCookbook",
					ItemId:     EncodeItemID(1234),
				}},
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
			req: &MsgFulfillTrade{
				Creator:         correctAddr,
				CoinInputsIndex: 0,
				Items: []ItemRef{{
					CookbookId: "testCookbook",
					ItemId:     EncodeItemID(1234),
				}},
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
			req: &MsgFulfillTrade{
				Creator:         correctAddr,
				CoinInputsIndex: 0,
				Items: []ItemRef{{
					CookbookId: "testCookbook",
					ItemId:     EncodeItemID(1234),
				}},
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
			req: &MsgFulfillTrade{
				Creator:         correctAddr,
				CoinInputsIndex: 0,
				Items: []ItemRef{{
					CookbookId: "testCookbook",
					ItemId:     EncodeItemID(1234),
				}},
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
			req: &MsgFulfillTrade{
				Creator:         correctAddr,
				CoinInputsIndex: 0,
				Items: []ItemRef{{
					CookbookId: "testCookbook",
					ItemId:     EncodeItemID(1234),
				}},
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
			tc.req.Id = uint64(index)
			err := tc.req.ValidateBasic()
			if err != nil {
				require.ErrorIs(t, err, tc.err)
			} else {
				require.NoError(t, tc.err)
			}
		})
	}
}
