package types

import (
	"testing"

	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	"github.com/stretchr/testify/require"
)

func TestMsgCookbookValidateBasic(t *testing.T) {
	correctCreatorAddr := "cosmos1n67vdlaejpj3uzswr9qapeg76zlkusj5k875ma"
	invalidAddr := "pylo1xn72u3jxlpqx8tfgmjf0xg970q36xensjngsme"

	index := "any"
	name := "testNameTestName"
	description := "testDescriptionTestDescriptionTestDescription"
	version := "v1.0.0"
	email := "test@email.com"

	for _, tc := range []struct {
		desc       string
		create_req *MsgCreateCookbook
		update_req *MsgUpdateCookbook
		err        error
	}{
		{
			desc: "Valid",
			create_req: &MsgCreateCookbook{
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
			create_req: &MsgCreateCookbook{
				Creator: "",
			},
			err: sdkerrors.ErrInvalidAddress,
		},
		{
			desc: "Invalid creator address 2",
			create_req: &MsgCreateCookbook{
				Creator: invalidAddr,
			},
			err: sdkerrors.ErrInvalidAddress,
		},
		{
			desc: "Invalid creator address 3",
			create_req: &MsgCreateCookbook{
				Creator: "test",
			},
			err: sdkerrors.ErrInvalidAddress,
		},
		{
			desc: "Invalid Id",
			create_req: &MsgCreateCookbook{
				Creator: correctCreatorAddr,
				Id:      "test $%^",
			},
			err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "Invalid Name's Length",
			create_req: &MsgCreateCookbook{
				Creator: correctCreatorAddr,
				Id:      index,
				Name:    "",
			},
			err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "Invalid Description's Length",
			create_req: &MsgCreateCookbook{
				Creator:     correctCreatorAddr,
				Id:          index,
				Name:        name,
				Description: "",
			},
			err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "Invalid SupportEmail",
			create_req: &MsgCreateCookbook{
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
			create_req: &MsgCreateCookbook{
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
			tc.update_req = (*MsgUpdateCookbook)(tc.create_req)
			err := tc.create_req.ValidateBasic()
			if err != nil {
				require.ErrorIs(t, err, tc.err)
			} else {
				require.NoError(t, tc.err)
			}
			err = tc.update_req.ValidateBasic()
			if err != nil {
				require.ErrorIs(t, err, tc.err)
			} else {
				require.NoError(t, tc.err)
			}
		})
	}
}
