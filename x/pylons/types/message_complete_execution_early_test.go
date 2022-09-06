package types

import (
	"testing"

	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	"github.com/stretchr/testify/require"
)

func TestMsgCompleteExecutionEarlyValidateBasic(t *testing.T) {
	correctAddr := "cosmos1n67vdlaejpj3uzswr9qapeg76zlkusj5k875ma"
	invalidAddr := "pylo1xn72u3jxlpqx8tfgmjf0xg970q36xensjngsme"
	for _, tc := range []struct {
		desc string
		req  *MsgCompleteExecutionEarly
		err  error
	}{
		{
			desc: "Valid",
			req: &MsgCompleteExecutionEarly{
				Creator: correctAddr,
				Id:      "1",
			},
			err: nil,
		},
		{
			desc: "Invalid creator address 1",
			req: &MsgCompleteExecutionEarly{
				Creator: "",
				Id:      "1",
			},
			err: sdkerrors.ErrInvalidAddress,
		},
		{
			desc: "Invalid creator address 2",
			req: &MsgCompleteExecutionEarly{
				Creator: invalidAddr,
				Id:      "1",
			},
			err: sdkerrors.ErrInvalidAddress,
		},
		{
			desc: "Invalid creator address 3",
			req: &MsgCompleteExecutionEarly{
				Creator: "test",
				Id:      "1",
			},
			err: sdkerrors.ErrInvalidAddress,
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
