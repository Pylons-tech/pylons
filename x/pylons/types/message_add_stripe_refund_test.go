package types

import (
	"testing"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	"github.com/stretchr/testify/require"
)

func TestMsgAddStripeRefundValidateBasic(t *testing.T) {
	correctAddr := "cosmos1n67vdlaejpj3uzswr9qapeg76zlkusj5k875ma"
	invalidAddr := "pylo1xn72u3jxlpqx8tfgmjf0xg970q36xensjngsme"
	for _, tc := range []struct {
		desc string
		req  *MsgAddStripeRefund
		err  error
	}{
		{
			desc: "Valid",
			req: &MsgAddStripeRefund{
				Payment: &PaymentInfo{
					PurchaseId:    "test",
					ProcessorName: "test",
					PayerAddr:     GenTestBech32FromString("test"),
					Amount:        sdk.OneInt(),
					ProductId:     "test",
					Signature:     "test",
				},
				Creator: correctAddr,
			},
			err: nil,
		},
		{
			desc: "Invalid creator address 1",
			req: &MsgAddStripeRefund{
				Payment: &PaymentInfo{
					PurchaseId:    "test",
					ProcessorName: "test",
					PayerAddr:     GenTestBech32FromString("test"),
					Amount:        sdk.OneInt(),
					ProductId:     "test",
					Signature:     "test",
				},
				Creator: "testCreator",
			},
			err: sdkerrors.ErrInvalidAddress,
		},
		{
			desc: "Invalid creator address 2",
			req: &MsgAddStripeRefund{
				Payment: &PaymentInfo{
					PurchaseId:    "test",
					ProcessorName: "test",
					PayerAddr:     GenTestBech32FromString("test"),
					Amount:        sdk.OneInt(),
					ProductId:     "test",
					Signature:     "test",
				},
				Creator: invalidAddr,
			},
			err: sdkerrors.ErrInvalidAddress,
		},
		{
			desc: "Invalid creator address 3",
			req: &MsgAddStripeRefund{
				Payment: &PaymentInfo{
					PurchaseId:    "test",
					ProcessorName: "test",
					PayerAddr:     GenTestBech32FromString("test"),
					Amount:        sdk.OneInt(),
					ProductId:     "test",
					Signature:     "test",
				},
				Creator: "",
			},
			err: sdkerrors.ErrInvalidAddress,
		},
		{
			desc: "InvalidPurchaseID",
			req: &MsgAddStripeRefund{
				Payment: &PaymentInfo{
					PurchaseId:    "",
					ProcessorName: "test",
					PayerAddr:     GenTestBech32FromString("test"),
					Amount:        sdk.OneInt(),
					ProductId:     "test",
					Signature:     "test",
				},
				Creator: correctAddr,
			},
			err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "InvalidProductID",
			req: &MsgAddStripeRefund{
				Payment: &PaymentInfo{
					PurchaseId:    "test",
					ProcessorName: "test",
					PayerAddr:     GenTestBech32FromString("test"),
					Amount:        sdk.OneInt(),
					ProductId:     "",
					Signature:     "test",
				},
				Creator: correctAddr,
			},
			err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "InvalidSignature",
			req: &MsgAddStripeRefund{
				Payment: &PaymentInfo{
					PurchaseId:    "test",
					ProcessorName: "test",
					PayerAddr:     GenTestBech32FromString("test"),
					Amount:        sdk.OneInt(),
					ProductId:     "test",
					Signature:     "",
				},
				Creator: correctAddr,
			},
			err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "InvalidAmount",
			req: &MsgAddStripeRefund{
				Payment: &PaymentInfo{
					PurchaseId:    "test",
					ProcessorName: "test",
					PayerAddr:     GenTestBech32FromString("test"),
					Amount:        sdk.ZeroInt(),
					ProductId:     "test",
					Signature:     "test",
				},
				Creator: correctAddr,
			},
			err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "InvalidAddress",
			req: &MsgAddStripeRefund{
				Payment: &PaymentInfo{
					PurchaseId:    "test",
					ProcessorName: "test",
					PayerAddr:     "test",
					Amount:        sdk.OneInt(),
					ProductId:     "test",
					Signature:     "test",
				},
				Creator: correctAddr,
			},
			err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "InvalidProcessorName",
			req: &MsgAddStripeRefund{
				Payment: &PaymentInfo{
					PurchaseId:    "test",
					ProcessorName: "",
					PayerAddr:     GenTestBech32FromString("test"),
					Amount:        sdk.OneInt(),
					ProductId:     "test",
					Signature:     "test",
				},
				Creator: correctAddr,
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
