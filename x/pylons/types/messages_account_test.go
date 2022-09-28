package types

import (
	"testing"

	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	"github.com/stretchr/testify/require"
)

func TestMsgCreateAccountValidateBasic(t *testing.T) {
	correctCreatorAddr := "cosmos1n67vdlaejpj3uzswr9qapeg76zlkusj5k875ma"
	invalidAddr := "pylo1xn72u3jxlpqx8tfgmjf0xg970q36xensjngsme"

	for _, tc := range []struct {
		desc string
		req  *MsgCreateAccount
		err  error
	}{
		{
			desc: "Valid",
			req: &MsgCreateAccount{
				Creator:         correctCreatorAddr,
				ReferralAddress: "",
			},
			err: nil,
		},
		{
			desc: "Invalid creator address 1",
			req: &MsgCreateAccount{
				Creator:  "",
			},
			err: sdkerrors.ErrInvalidAddress,
		},
		{
			desc: "Invalid creator address 2",
			req: &MsgCreateAccount{
				Creator:  invalidAddr,
			},
			err: sdkerrors.ErrInvalidAddress,
		},
		{
			desc: "Invalid creator address 3",
			req: &MsgCreateAccount{
				Creator:  "test",
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

func TestMsgUpdateAccountValidateBasic(t *testing.T) {
	correctCreatorAddr := "cosmos1n67vdlaejpj3uzswr9qapeg76zlkusj5k875ma"
	invalidAddr := "pylo1xn72u3jxlpqx8tfgmjf0xg970q36xensjngsme"

	for _, tc := range []struct {
		desc string
		req  *MsgUpdateAccount
		err  error
	}{
		{
			desc: "Valid",
			req: &MsgUpdateAccount{
				Creator:  correctCreatorAddr,
				Username: "Username",
			},
			err: nil,
		},
		{
			desc: "Invalid creator address 1",
			req: &MsgUpdateAccount{
				Creator:  "",
				Username: "Username",
			},
			err: sdkerrors.ErrInvalidAddress,
		},
		{
			desc: "Invalid creator address 2",
			req: &MsgUpdateAccount{
				Creator:  invalidAddr,
				Username: "Username",
			},
			err: sdkerrors.ErrInvalidAddress,
		},
		{
			desc: "Invalid creator address 3",
			req: &MsgUpdateAccount{
				Creator:  "test",
				Username: "Username",
			},
			err: sdkerrors.ErrInvalidAddress,
		},
		{
			desc: "Invalid username",
			req: &MsgUpdateAccount{
				Creator:  correctCreatorAddr,
				Username: "",
			},
			err: ErrInvalidRequestField,
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
func TestMsgSetUsername(t *testing.T) {
	correctCreatorAddr := "cosmos1n67vdlaejpj3uzswr9qapeg76zlkusj5k875ma"
	invalidAddr := "pylo1xn72u3jxlpqx8tfgmjf0xg970q36xensjngsme"

	for _, tc := range []struct {
		desc string
		req  *MsgSetUsername
		err  error
	}{
		{
			desc: "Valid",
			req: &MsgSetUsername{
				Creator:         correctCreatorAddr,
				Username: "Username",
			},
			err: nil,
		},
		{
			desc: "Invalid creator address 1",
			req: &MsgSetUsername{
				Creator:  "",
			},
			err: sdkerrors.ErrInvalidAddress,
		},
		{
			desc: "Invalid creator address 2",
			req: &MsgSetUsername{
				Creator:  invalidAddr,
			},
			err: sdkerrors.ErrInvalidAddress,
		},
		{
			desc: "Invalid creator address 3",
			req: &MsgSetUsername{
				Creator:  "test",
			},
			err: sdkerrors.ErrInvalidAddress,
		},
		{
			desc: "Invalid username",
			req: &MsgSetUsername{
				Creator:  correctCreatorAddr,
				Username: "",
			},
			err: ErrInvalidRequestField,
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