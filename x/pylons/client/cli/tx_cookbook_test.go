package cli_test

import (
	"fmt"
	"testing"

	"github.com/Pylons-tech/pylons/x/pylons/types"

	"github.com/cosmos/cosmos-sdk/client/flags"
	clitestutil "github.com/cosmos/cosmos-sdk/testutil/cli"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	"github.com/stretchr/testify/require"

	"github.com/Pylons-tech/pylons/testutil/network"
	"github.com/Pylons-tech/pylons/x/pylons/client/cli"
)

func TestCreateCookbook(t *testing.T) {
	net := network.New(t)
	val := net.Validators[0]
	ctx := val.ClientCtx
	id := "testID"

	validFields := []string{
		"testCookbookName",
		"DescriptionDescriptionDescription",
		"Developer",
		"v0.0.1",
		"test@email.com",
		"{\"denom\": \"pylons\", \"amount\": \"1\"}",
		"true",
	}

	validNoDeveloper := []string{
		"testCookbookName",
		"DescriptionDescriptionDescription",
		"",
		"v0.0.2",
		"test@email.com",
		"{\"denom\": \"pylons\", \"amount\": \"1\"}",
		"true",
	}

	invalidName := []string{
		"",
		"DescriptionDescriptionDescription",
		"Developer",
		"v0.0.3",
		"test@email.com",
		"{\"denom\": \"pylons\", \"amount\": \"1\"}",
		"true",
	}

	invalidDescription := []string{
		"testCookbookName",
		"",
		"Developer",
		"v0.0.4",
		"test@email.com",
		"{\"denom\": \"pylons\", \"amount\": \"1\"}",
		"true",
	}

	invalidVersion1 := []string{
		"testCookbookName",
		"DescriptionDescriptionDescription",
		"Developer",
		"0.0.1",
		"test@email.com",
		"{\"denom\": \"pylons\", \"amount\": \"1\"}",
		"true",
	}

	invalidVersion2 := []string{
		"testCookbookName",
		"DescriptionDescriptionDescription",
		"Developer",
		"1",
		"test@email.com",
		"{\"denom\": \"pylons\", \"amount\": \"1\"}",
		"true",
	}

	invalidVersion3 := []string{
		"testCookbookName",
		"DescriptionDescriptionDescription",
		"Developer",
		"version",
		"test@email.com",
		"{\"denom\": \"pylons\", \"amount\": \"1\"}",
		"true",
	}

	invalidEmail := []string{
		"testCookbookName",
		"DescriptionDescriptionDescription",
		"Developer",
		"v0.0.5",
		"incorrect email",
		"{\"denom\": \"pylons\", \"amount\": \"1\"}",
		"true",
	}

	emptyCoin := []string{
		"testCookbookName",
		"DescriptionDescriptionDescription",
		"Developer",
		"v0.0.6",
		"test@email.com",
		"{}",
		"true",
	}

	invalidCoinAmount := []string{
		"testCookbookName",
		"DescriptionDescriptionDescription",
		"Developer",
		"v0.0.7",
		"test@email.com",
		"{\"denom\": \"pylons\", \"amount\": \"-1\"}",
		"true",
	}

	invalidEnabledField := []string{
		"testCookbookName",
		"DescriptionDescriptionDescription",
		"Developer",
		"v0.0.8",
		"test@email.com",
		"{\"denom\": \"pylons\", \"amount\": \"1\"}",
		"incorrect",
	}

	common := []string{
		fmt.Sprintf("--%s=%s", flags.FlagFrom, val.Address.String()),
		fmt.Sprintf("--%s=true", flags.FlagSkipConfirmation),
		fmt.Sprintf("--%s=%s", flags.FlagBroadcastMode, flags.BroadcastBlock),
		fmt.Sprintf("--%s=%s", flags.FlagFees, sdk.NewCoins(sdk.NewCoin(net.Config.BondDenom, sdk.NewInt(10))).String()),
	}

	for _, tc := range []struct {
		desc   string
		id     string
		fields []string
		args   []string
		err    error
		code   uint32
	}{
		{
			id:     id,
			desc:   "valid",
			fields: validFields,
			args:   common,
			err:    nil,
			code:   0,
		},
		{
			id:     id,
			desc:   "duplicateID",
			fields: validFields,
			args:   common,
			err:    nil,
			code:   sdkerrors.ErrInvalidRequest.ABCICode(),
		},
		{
			id:     "ValidNoDeveloper",
			desc:   "ValidNoDeveloper",
			fields: validNoDeveloper,
			args:   common,
			err:    nil,
			code:   0,
		},
		{
			id:     "InvalidName",
			desc:   "InvalidName",
			fields: invalidName,
			args:   common,
			err:    nil,
			code:   sdkerrors.ErrInvalidRequest.ABCICode(),
		},
		{
			id:     "InvalidDescription",
			desc:   "InvalidDescription",
			fields: invalidDescription,
			args:   common,
			err:    nil,
			code:   sdkerrors.ErrInvalidRequest.ABCICode(),
		},
		{
			id:     "InvalidVersion1",
			desc:   "InvalidVersion1",
			fields: invalidVersion1,
			args:   common,
			err:    sdkerrors.ErrInvalidRequest,
			code:   types.ErrInvalidRequestField.ABCICode(),
		},
		{
			id:     "InvalidVersion2",
			desc:   "InvalidVersion2",
			fields: invalidVersion2,
			args:   common,
			err:    sdkerrors.ErrInvalidRequest,
			code:   types.ErrInvalidRequestField.ABCICode(),
		},
		{
			id:     "InvalidVersion3",
			desc:   "InvalidVersion3",
			fields: invalidVersion3,
			args:   common,
			err:    sdkerrors.ErrInvalidRequest,
			code:   types.ErrInvalidRequestField.ABCICode(),
		},
		{
			id:     "InvalidEmail",
			desc:   "InvalidEmail",
			fields: invalidEmail,
			args:   common,
			err:    sdkerrors.ErrInvalidRequest,
			code:   types.ErrInvalidRequestField.ABCICode(),
		},
		{
			id:     "EmptyCoin",
			desc:   "EmptyCoin",
			fields: emptyCoin,
			args:   common,
			err:    sdkerrors.ErrInvalidCoins,
			code:   types.ErrInvalidRequestField.ABCICode(),
		},
		{
			id:     "InvalidCoinAmount",
			desc:   "InvalidCoinAmount",
			fields: invalidCoinAmount,
			args:   common,
			err:    sdkerrors.ErrInvalidCoins,
			code:   types.ErrInvalidRequestField.ABCICode(),
		},
		{
			id:     "InvalidEnabledField",
			desc:   "InvalidEnabledField",
			fields: invalidEnabledField,
			args:   common,
			err:    sdkerrors.ErrInvalidRequest,
			code:   types.ErrInvalidRequestField.ABCICode(),
		},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			args := []string{tc.id}
			args = append(args, tc.fields...)
			args = append(args, tc.args...)
			out, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdCreateCookbook(), args)
			if tc.err != nil {
				require.ErrorIs(t, err, tc.err)
			} else {
				require.NoError(t, err)
				var resp sdk.TxResponse
				require.NoError(t, ctx.Codec.UnmarshalJSON(out.Bytes(), &resp))
				require.Equal(t, tc.code, resp.Code)
			}
		})
	}
}

func TestUpdateCookbook(t *testing.T) {
	net := network.New(t)
	val := net.Validators[0]
	ctx := val.ClientCtx
	id := "testID"

	fields := []string{
		"testCookbookName",
		"DescriptionDescriptionDescription",
		"Developer",
		"v0.0.1",
		"test@email.com",
		"{\"denom\": \"pylons\", \"amount\": \"1\"}",
		"true",
	}
	common := []string{
		fmt.Sprintf("--%s=%s", flags.FlagFrom, val.Address.String()),
		fmt.Sprintf("--%s=true", flags.FlagSkipConfirmation),
		fmt.Sprintf("--%s=%s", flags.FlagBroadcastMode, flags.BroadcastBlock),
		fmt.Sprintf("--%s=%s", flags.FlagFees, sdk.NewCoins(sdk.NewCoin(net.Config.BondDenom, sdk.NewInt(10))).String()),
	}
	args := []string{id}
	args = append(args, fields...)
	args = append(args, common...)
	_, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdCreateCookbook(), args)
	require.NoError(t, err)

	// NOTE:
	// for all valid test cases, the version must be increasing from the previous.
	// all test cases are updating the same cookbook, so the version and other fields
	// will be carried over between tests

	valid := []string{
		"ModifiedCookbookname",
		"DescriptionDescriptionDescription",
		"Modified",
		"v0.0.2",
		"test@email.com",
		"{\"denom\": \"pylons\", \"amount\": \"1\"}",
		"true",
	}

	disable := []string{
		"ModifiedCookbooknameNew",
		"DescriptionDescriptionDescription",
		"Developer",
		"v0.0.3",
		"test@email.com",
		"{\"denom\": \"pylons\", \"amount\": \"1\"}",
		"false",
	}

	updateEmail := []string{
		"ModifiedCookbooknameNewNew",
		"DescriptionDescriptionDescription",
		"Developer",
		"v0.0.4",
		"newTest@email.com",
		"{\"denom\": \"pylons\", \"amount\": \"1\"}",
		"false",
	}

	changeCoin := []string{
		"ModifiedCookbooknameNew",
		"DescriptionDescriptionDescription",
		"Developer",
		"v0.0.5",
		"test@email.com",
		"{\"denom\": \"snolyp\", \"amount\": \"1\"}",
		"false",
	}

	invalidVersion := []string{
		"ModifiedCookbooknameNewNew",
		"DescriptionDescriptionDescription",
		"Developer",
		"0.0.5",
		"test@email.com",
		"{\"denom\": \"pylons\", \"amount\": \"1\"}",
		"false",
	}

	invalidVersionNoModifications := []string{
		"ModifiedCookbooknameNewNew",
		"DescriptionDescriptionDescription",
		"Developer",
		"0.0.5",
		"test@email.com",
		"{\"denom\": \"pylons\", \"amount\": \"1\"}",
		"false",
	}

	noModifications := []string{
		"ModifiedCookbooknameNewNew",
		"DescriptionDescriptionDescription",
		"Developer",
		"v0.0.5",
		"test@email.com",
		"{\"denom\": \"pylons\", \"amount\": \"1\"}",
		"false",
	}

	invalidVersion1 := []string{
		"ModifiedCookbooknameNewNew",
		"DescriptionDescriptionDescription",
		"Developer",
		"0.0.9",
		"test@email.com",
		"{\"denom\": \"pylons\", \"amount\": \"1\"}",
		"true",
	}

	invalidVersion2 := []string{
		"ModifiedCookbooknameNewNew",
		"DescriptionDescriptionDescription",
		"Developer",
		"1",
		"test@email.com",
		"{\"denom\": \"pylons\", \"amount\": \"1\"}",
		"true",
	}

	invalidVersion3 := []string{
		"ModifiedCookbooknameNewNew",
		"DescriptionDescriptionDescription",
		"Developer",
		"0.0.1",
		"test@email.com",
		"{\"denom\": \"pylons\", \"amount\": \"1\"}",
		"true",
	}

	invalidEmail := []string{
		"ModifiedCookbooknameNewNew",
		"DescriptionDescriptionDescription",
		"Developer",
		"v0.0.10",
		"incorrect email",
		"{\"denom\": \"pylons\", \"amount\": \"1\"}",
		"true",
	}

	emptyCoin := []string{
		"ModifiedCookbooknameNewNew",
		"DescriptionDescriptionDescription",
		"Developer",
		"v0.0.11",
		"test@email.com",
		"{}",
		"true",
	}

	invalidCoinAmount := []string{
		"ModifiedCookbooknameNewNew",
		"DescriptionDescriptionDescription",
		"Developer",
		"v0.0.12",
		"test@email.com",
		"{\"denom\": \"pylons\", \"amount\": \"-1\"}",
		"true",
	}

	invalidEnabledField := []string{
		"ModifiedCookbooknameNewNew",
		"DescriptionDescriptionDescription",
		"Developer",
		"v0.0.13",
		"test@email.com",
		"{\"denom\": \"pylons\", \"amount\": \"1\"}",
		"incorrect",
	}

	for _, tc := range []struct {
		desc string
		id   string
		args []string
		code uint32
		err  error
	}{
		{
			desc: "valid",
			id:   id,
			args: append(valid, common...),
			code: 0,
		},
		{
			desc: "disable",
			id:   id,
			args: append(disable, common...),
			code: 0,
		},
		{
			desc: "UpdateEmail",
			id:   id,
			args: append(updateEmail, common...),
			code: 0,
		},
		{
			desc: "ChangeCoin",
			id:   id,
			args: append(changeCoin, common...),
			code: 0,
		},
		{
			desc: "invalidVersionStateful",
			id:   id,
			args: append(invalidVersion, common...),
			err:  sdkerrors.ErrInvalidRequest,
			code: sdkerrors.ErrInvalidRequest.ABCICode(),
		},
		{
			desc: "invalidNoMods",
			id:   id,
			args: append(invalidVersionNoModifications, common...),
			err:  sdkerrors.ErrInvalidRequest,
			code: sdkerrors.ErrInvalidRequest.ABCICode(),
		},
		{
			desc: "noMods",
			id:   id,
			args: append(noModifications, common...),
			code: sdkerrors.ErrInvalidRequest.ABCICode(),
		},
		{
			desc: "InvalidVersion1",
			id:   id,
			args: append(invalidVersion1, common...),
			err:  sdkerrors.ErrInvalidRequest,
			code: types.ErrInvalidRequestField.ABCICode(),
		},
		{
			desc: "InvalidVersion2",
			id:   id,
			args: append(invalidVersion2, common...),
			err:  sdkerrors.ErrInvalidRequest,
			code: types.ErrInvalidRequestField.ABCICode(),
		},
		{
			desc: "InvalidVersion3",
			id:   id,
			args: append(invalidVersion3, common...),
			err:  sdkerrors.ErrInvalidRequest,
			code: types.ErrInvalidRequestField.ABCICode(),
		},
		{
			desc: "InvalidEmail",
			id:   id,
			args: append(invalidEmail, common...),
			err:  sdkerrors.ErrInvalidRequest,
			code: types.ErrInvalidRequestField.ABCICode(),
		},
		{
			desc: "EmptyCoin",
			id:   id,
			args: append(emptyCoin, common...),
			err:  sdkerrors.ErrInvalidCoins,
			code: types.ErrInvalidRequestField.ABCICode(),
		},
		{
			desc: "InvalidCoinAmount",
			id:   id,
			args: append(invalidCoinAmount, common...),
			err:  sdkerrors.ErrInvalidCoins,
			code: types.ErrInvalidRequestField.ABCICode(),
		},
		{
			desc: "InvalidEnabledField",
			id:   id,
			args: append(invalidEnabledField, common...),
			err:  sdkerrors.ErrInvalidRequest,
			code: types.ErrInvalidRequestField.ABCICode(),
		},
		{
			desc: "key not found",
			id:   "not_found",
			args: append(valid, common...),
			err:  nil,
			code: sdkerrors.ErrKeyNotFound.ABCICode(),
		},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			args := []string{tc.id}
			args = append(args, tc.args...)
			out, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdUpdateCookbook(), args)
			if tc.err != nil {
				require.ErrorIs(t, err, tc.err)
			} else {
				require.NoError(t, err)
				var resp sdk.TxResponse
				require.NoError(t, ctx.Codec.UnmarshalJSON(out.Bytes(), &resp))
				require.Equal(t, tc.code, resp.Code)
			}
		})
	}
}
