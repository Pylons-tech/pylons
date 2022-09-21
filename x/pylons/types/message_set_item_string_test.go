package types

import (
	"testing"

	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	"github.com/stretchr/testify/require"
)

func TestMsgSetItemStringValidateBasic(t *testing.T) {
	correctCreatorAddr := "cosmos1n67vdlaejpj3uzswr9qapeg76zlkusj5k875ma"
	invalidAddr := "pylo1xn72u3jxlpqx8tfgmjf0xg970q36xensjngsme"

	for _, tc := range []struct {
		desc string
		req  *MsgSetItemString
		err  error
	}{
		{
			desc: "Valid",
			req: &MsgSetItemString{
				Creator:    correctCreatorAddr,
				CookbookId: "testCookbookId",
				Id:         EncodeItemID(1234),
				Field:      "test",
			},
			err: nil,
		},
		{
			desc: "Invalid creator address 1",
			req: &MsgSetItemString{
				Creator: "",
			},
			err: sdkerrors.ErrInvalidAddress,
		},
		{
			desc: "Invalid creator address 2",
			req: &MsgSetItemString{
				Creator: invalidAddr,
			},
			err: sdkerrors.ErrInvalidAddress,
		},
		{
			desc: "Invalid creator address 3",
			req: &MsgSetItemString{
				Creator: "test",
			},
			err: sdkerrors.ErrInvalidAddress,
		},
		{
			desc: "Invalid CookbookId",
			req: &MsgSetItemString{
				Creator:    correctCreatorAddr,
				CookbookId: "1",
			},
			err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "Invalid Id",
			req: &MsgSetItemString{
				Creator:    correctCreatorAddr,
				CookbookId: "testCookbookId",
				Id:         "111111111",
			},
			err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "Invalid Field",
			req: &MsgSetItemString{
				Creator:    correctCreatorAddr,
				CookbookId: "testCookbookId",
				Id:         EncodeItemID(1234),
				Field:      "111111111",
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
