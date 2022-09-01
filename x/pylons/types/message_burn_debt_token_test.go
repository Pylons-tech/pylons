package types

import (
	"testing"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	"github.com/stretchr/testify/require"
)

func TestMsgBurnDebtTokenValidateBasic(t *testing.T) {
	correctAddr := "cosmos1n67vdlaejpj3uzswr9qapeg76zlkusj5k875ma"
	invalidAddr := "pylo1xn72u3jxlpqx8tfgmjf0xg970q36xensjngsme"
	for _, tc := range []struct {
		desc string
		req  *MsgBurnDebtToken
		err  error
	}{
		{
			desc: "Valid",
			req: &MsgBurnDebtToken{
				RedeemInfo: RedeemInfo{
					Id:            "test",
					ProcessorName: "test",
					Address:       GenTestBech32FromString("test"),
					Amount:        sdk.OneInt(),
					Signature:     "test",
				},
				Creator: correctAddr,
			},
			err: nil,
		},
		{
			desc: "Invalid creator address 1",
			req: &MsgBurnDebtToken{
				RedeemInfo: RedeemInfo{
					Id:            "test",
					ProcessorName: "test",
					Address:       GenTestBech32FromString("test"),
					Amount:        sdk.OneInt(),
					Signature:     "test",
				},
				Creator: "",
			},
			err: sdkerrors.ErrInvalidAddress,
		},
		{
			desc: "Invalid creator address 2",
			req: &MsgBurnDebtToken{
				RedeemInfo: RedeemInfo{
					Id:            "test",
					ProcessorName: "test",
					Address:       GenTestBech32FromString("test"),
					Amount:        sdk.OneInt(),
					Signature:     "test",
				},
				Creator: invalidAddr,
			},
			err: sdkerrors.ErrInvalidAddress,
		},
		{
			desc: "Invalid creator address 3",
			req: &MsgBurnDebtToken{
				RedeemInfo: RedeemInfo{
					Id:            "test",
					ProcessorName: "test",
					Address:       GenTestBech32FromString("test"),
					Amount:        sdk.OneInt(),
					Signature:     "test",
				},
				Creator: "test",
			},
			err: sdkerrors.ErrInvalidAddress,
		},
		{
			desc: "InvalidID",
			req: &MsgBurnDebtToken{
				RedeemInfo: RedeemInfo{
					Id:            "",
					ProcessorName: "test",
					Address:       GenTestBech32FromString("test"),
					Amount:        sdk.OneInt(),
					Signature:     "test",
				},
				Creator: correctAddr,
			},
			err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "InvalidSignature",
			req: &MsgBurnDebtToken{
				RedeemInfo: RedeemInfo{
					Id:            "test",
					ProcessorName: "test",
					Address:       GenTestBech32FromString("test"),
					Amount:        sdk.OneInt(),
					Signature:     "",
				},
				Creator: correctAddr,
			},
			err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "InvalidAmount",
			req: &MsgBurnDebtToken{
				RedeemInfo: RedeemInfo{
					Id:            "test",
					ProcessorName: "test",
					Address:       GenTestBech32FromString("test"),
					Amount:        sdk.ZeroInt(),
					Signature:     "test",
				},
				Creator: correctAddr,
			},
			err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "InvalidAddress",
			req: &MsgBurnDebtToken{
				RedeemInfo: RedeemInfo{
					Id:            "test",
					ProcessorName: "test",
					Address:       "test",
					Amount:        sdk.OneInt(),
					Signature:     "test",
				},
				Creator: correctAddr,
			},
			err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "InvalidProcessorName",
			req: &MsgBurnDebtToken{
				RedeemInfo: RedeemInfo{
					Id:            "test",
					ProcessorName: "",
					Address:       GenTestBech32FromString("test"),
					Amount:        sdk.OneInt(),
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
