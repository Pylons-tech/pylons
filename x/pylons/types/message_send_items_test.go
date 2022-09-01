package types

import (
	"testing"

	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	"github.com/stretchr/testify/require"
)

func TestMsgSendItemsValidateBasic(t *testing.T) {
	correctCreatorAddr := "cosmos1n67vdlaejpj3uzswr9qapeg76zlkusj5k875ma"
	correctReceiverAddr := "cosmos1chamgpjkyr9hc4k3t8xgevu3k83arkddv72pd0"
	invalidAddr := "pylo1xn72u3jxlpqx8tfgmjf0xg970q36xensjngsme"

	for _, tc := range []struct {
		desc string
		req  *MsgSendItems
		err  error
	}{
		{
			desc: "Valid",
			req: &MsgSendItems{
				Creator:  correctCreatorAddr,
				Receiver: correctReceiverAddr,
			},
			err: nil,
		},
		{
			desc: "Invalid creator address 1",
			req: &MsgSendItems{
				Creator: "",
			},
			err: sdkerrors.ErrInvalidAddress,
		},
		{
			desc: "Invalid creator address 2",
			req: &MsgSendItems{
				Creator: invalidAddr,
			},
			err: sdkerrors.ErrInvalidAddress,
		},
		{
			desc: "Invalid creator address 3",
			req: &MsgSendItems{
				Creator: "test",
			},
			err: sdkerrors.ErrInvalidAddress,
		},
		{
			desc: "Invalid receiver address 1",
			req: &MsgSendItems{
				Creator:  correctCreatorAddr,
				Receiver: "",
			},
			err: sdkerrors.ErrInvalidAddress,
		},
		{
			desc: "Invalid receiver address 2",
			req: &MsgSendItems{
				Creator:  correctCreatorAddr,
				Receiver: invalidAddr,
			},
			err: sdkerrors.ErrInvalidAddress,
		},
		{
			desc: "Invalid receiver address 3",
			req: &MsgSendItems{
				Creator:  correctCreatorAddr,
				Receiver: "test",
			},
			err: sdkerrors.ErrInvalidAddress,
		},
		{
			desc: "Invalid CookbookId",
			req: &MsgSendItems{
				Creator:  correctCreatorAddr,
				Receiver: correctReceiverAddr,
				Items: []ItemRef{{
					CookbookId: "1",
					ItemId:     EncodeItemID(1234),
				}},
			},
			err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "Invalid ItemId",
			req: &MsgSendItems{
				Creator:  correctCreatorAddr,
				Receiver: correctReceiverAddr,
				Items: []ItemRef{{
					ItemId: "111111111",
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
