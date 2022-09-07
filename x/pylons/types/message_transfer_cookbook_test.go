package types

import (
	"testing"

	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	"github.com/stretchr/testify/require"
)

func TestMsgTransferCookbookValidateBasic(t *testing.T) {
	correctCreatorAddr := "cosmos1n67vdlaejpj3uzswr9qapeg76zlkusj5k875ma"
	correctReceiverAddr := "cosmos1chamgpjkyr9hc4k3t8xgevu3k83arkddv72pd0"
	invalidAddr := "pylo1xn72u3jxlpqx8tfgmjf0xg970q36xensjngsme"

	for _, tc := range []struct {
		desc string
		req  *MsgTransferCookbook
		err  error
	}{
		{
			desc: "Valid",
			req: &MsgTransferCookbook{
				Creator:   correctCreatorAddr,
				Id:        "test",
				Recipient: correctReceiverAddr,
			},
			err: nil,
		},
		{
			desc: "Invalid creator address 1",
			req: &MsgTransferCookbook{
				Creator: "",
			},
			err: sdkerrors.ErrInvalidAddress,
		},
		{
			desc: "Invalid creator address 2",
			req: &MsgTransferCookbook{
				Creator: invalidAddr,
			},
			err: sdkerrors.ErrInvalidAddress,
		},
		{
			desc: "Invalid creator address 3",
			req: &MsgTransferCookbook{
				Creator: "test",
			},
			err: sdkerrors.ErrInvalidAddress,
		},
		{
			desc: "Invalid recipient address 1",
			req: &MsgTransferCookbook{
				Creator:   correctCreatorAddr,
				Recipient: "",
			},
			err: sdkerrors.ErrInvalidAddress,
		},
		{
			desc: "Invalid recipient address 2",
			req: &MsgTransferCookbook{
				Creator:   correctCreatorAddr,
				Recipient: invalidAddr,
			},
			err: sdkerrors.ErrInvalidAddress,
		},
		{
			desc: "Invalid recipient address 3",
			req: &MsgTransferCookbook{
				Creator:   correctCreatorAddr,
				Recipient: "test",
			},
			err: sdkerrors.ErrInvalidAddress,
		},
		{
			desc: "Invalid ID",
			req: &MsgTransferCookbook{
				Creator:   correctCreatorAddr,
				Id:        "11111111",
				Recipient: correctReceiverAddr,
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
