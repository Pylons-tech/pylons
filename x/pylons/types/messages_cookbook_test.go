package types

import (
	"testing"

	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	"github.com/stretchr/testify/require"
)

func TestMsgCreateCookbookValidateBasic(t *testing.T) {
	correctCreatorAddr := "cosmos1n67vdlaejpj3uzswr9qapeg76zlkusj5k875ma"
	invalidAddr := "pylo1xn72u3jxlpqx8tfgmjf0xg970q36xensjngsme"

	index := "any"
	name := "testNameTestName"
	description := "testDescriptionTestDescriptionTestDescription"
	version := "v1.0.0"
	email := "test@email.com"

	for _, tc := range []struct {
		desc string
		req  *MsgCreateCookbook
		err  error
	}{
		{
			desc: "Valid",
			req: &MsgCreateCookbook{
				Creator:      correctCreatorAddr,
				Id:           index,
				Name:         name,
				Description:  description,
				Developer:    "",
				Version:      version,
				SupportEmail: email,
				Enabled:      false,
			},
			err: nil,
		},
		{
			desc: "Invalid creator address 1",
			req: &MsgCreateCookbook{
				Creator: "",
			},
			err: sdkerrors.ErrInvalidAddress,
		},
		{
			desc: "Invalid creator address 2",
			req: &MsgCreateCookbook{
				Creator: invalidAddr,
			},
			err: sdkerrors.ErrInvalidAddress,
		},
		{
			desc: "Invalid creator address 3",
			req: &MsgCreateCookbook{
				Creator: "test",
			},
			err: sdkerrors.ErrInvalidAddress,
		},
		{
			desc: "Invalid Id",
			req: &MsgCreateCookbook{
				Creator: correctCreatorAddr,
				Id:      "test $%^",
			},
			err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "Invalid Name's Length",
			req: &MsgCreateCookbook{
				Creator: correctCreatorAddr,
				Id:      index,
				Name:    "",
			},
			err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "Invalid Description's Length",
			req: &MsgCreateCookbook{
				Creator:     correctCreatorAddr,
				Id:          index,
				Name:        name,
				Description: "",
			},
			err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "Invalid SupportEmail",
			req: &MsgCreateCookbook{
				Creator:      correctCreatorAddr,
				Id:           index,
				Name:         name,
				Description:  description,
				Developer:    "",
				Version:      version,
				SupportEmail: "email $%^",
			},
			err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "Invalid Version",
			req: &MsgCreateCookbook{
				Creator:      correctCreatorAddr,
				Id:           index,
				Name:         name,
				Description:  description,
				Developer:    "",
				Version:      "100",
				SupportEmail: email,
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

func TestMsgUpdateCookbookValidateBasic(t *testing.T) {
	correctCreatorAddr := "cosmos1n67vdlaejpj3uzswr9qapeg76zlkusj5k875ma"
	invalidAddr := "pylo1xn72u3jxlpqx8tfgmjf0xg970q36xensjngsme"

	index := "any"
	name := "testNameTestName"
	description := "testDescriptionTestDescriptionTestDescription"
	version := "v1.0.0"
	email := "test@email.com"

	for _, tc := range []struct {
		desc string
		req  *MsgUpdateCookbook
		err  error
	}{
		{
			desc: "Valid",
			req: &MsgUpdateCookbook{
				Creator:      correctCreatorAddr,
				Id:           index,
				Name:         name,
				Description:  description,
				Developer:    "",
				Version:      version,
				SupportEmail: email,
				Enabled:      false,
			},
			err: nil,
		},
		{
			desc: "Invalid creator address 1",
			req: &MsgUpdateCookbook{
				Creator: "",
			},
			err: sdkerrors.ErrInvalidAddress,
		},
		{
			desc: "Invalid creator address 2",
			req: &MsgUpdateCookbook{
				Creator: invalidAddr,
			},
			err: sdkerrors.ErrInvalidAddress,
		},
		{
			desc: "Invalid creator address 3",
			req: &MsgUpdateCookbook{
				Creator: "test",
			},
			err: sdkerrors.ErrInvalidAddress,
		},
		{
			desc: "Invalid Id",
			req: &MsgUpdateCookbook{
				Creator: correctCreatorAddr,
				Id:      "test $%^",
			},
			err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "Invalid Name's Length",
			req: &MsgUpdateCookbook{
				Creator: correctCreatorAddr,
				Id:      index,
				Name:    "",
			},
			err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "Invalid Description's Length",
			req: &MsgUpdateCookbook{
				Creator:     correctCreatorAddr,
				Id:          index,
				Name:        name,
				Description: "",
			},
			err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "Invalid SupportEmail",
			req: &MsgUpdateCookbook{
				Creator:      correctCreatorAddr,
				Id:           index,
				Name:         name,
				Description:  description,
				Developer:    "",
				Version:      version,
				SupportEmail: "email $%^",
			},
			err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "Invalid Version",
			req: &MsgUpdateCookbook{
				Creator:      correctCreatorAddr,
				Id:           index,
				Name:         name,
				Description:  description,
				Developer:    "",
				Version:      "100",
				SupportEmail: email,
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
