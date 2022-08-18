package keeper_test

import (
	"fmt"

	"github.com/Pylons-tech/pylons/x/pylons/keeper"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

// Test for SetItemString function

// TEST 1
// we create message (type: types.MsgSetItemString) with default Creator, CookbookId and Id
// check if no error

// TEST 2
// we create message (type: types.MsgSetItemString) with invalid CookbookId and Id
// check if if error is proper

// TEST 3
// we create message (type: types.MsgSetItemString) with invalid Creator
// check if if error is proper
func (suite *IntegrationTestSuite) TestItemMsgServerSetStringField1() {
	k := suite.k
	bk := suite.bankKeeper
	ctx := suite.ctx
	require := suite.Require()

	srv := keeper.NewMsgServerImpl(k)
	wctx := sdk.WrapSDKContext(ctx)

	creator := types.GenTestBech32FromString("test")
	updateFee := k.UpdateItemStringFee(ctx)

	updateFee.Amount = updateFee.Amount.Mul(sdk.NewInt(int64(1)))
	coinsWithUpdateFee := sdk.NewCoins(updateFee)

	creatorAddr, err := sdk.AccAddressFromBech32(creator)
	require.NoError(err)

	err = k.MintCoinsToAddr(ctx, creatorAddr, coinsWithUpdateFee)
	require.NoError(err)

	expectedString := "test"
	cookbook := &types.MsgCreateCookbook{
		Creator:      creator,
		Id:           "1",
		Name:         "testCookbookName",
		Description:  "descdescdescdescdescdescdescdesc",
		Developer:    "",
		Version:      "v0.0.1",
		SupportEmail: "test@email.com",
		Enabled:      false,
	}

	// setting cookbook required to provide a valid "scope" for items
	_, err = srv.CreateCookbook(wctx, cookbook)
	require.NoError(err)

	// set dummy item in store
	item := types.Item{
		CookbookId: "",
		Id:         "",
		Owner:      creator,
		MutableStrings: []types.StringKeyValue{
			{Key: expectedString, Value: expectedString},
		},
	}

	for index, tc := range []struct {
		desc         string
		request      types.MsgSetItemString
		itemnotfound bool
		err          error
	}{
		{
			desc: "Completed",
			request: types.MsgSetItemString{
				Creator: creator,
				Field:   expectedString,
				Value:   "new string",
			},
		},
		{
			desc: "Item not found",
			request: types.MsgSetItemString{
				Creator:    creator,
				CookbookId: "testCookbookId",
				Id:         "testId",
				Field:      expectedString,
				Value:      "new string",
			},
			itemnotfound: true,
			err:          sdkerrors.ErrKeyNotFound,
		},
		{
			desc: "Unauthorized",
			request: types.MsgSetItemString{
				Creator: "testPylons",
				Field:   expectedString,
				Value:   "new string",
			},
			err: sdkerrors.ErrInvalidRequest,
		},
	} {
		tc := tc
		suite.Run(tc.desc, func() {
			item.CookbookId = fmt.Sprintf("%d", index)
			item.Id = fmt.Sprintf("%d", index)
			if !tc.itemnotfound {
				tc.request.CookbookId = fmt.Sprintf("%d", index)
				tc.request.Id = fmt.Sprintf("%d", index)
			}
			k.SetItem(ctx, item)
			_, err = srv.SetItemString(wctx, &tc.request)

			if tc.err != nil {
				require.ErrorIs(err, tc.err)
			} else {
				require.NoError(err)
				// get item
				rst, found := k.GetItem(ctx, item.CookbookId, item.Id)
				require.True(found)
				require.NotEqual(expectedString, rst.MutableStrings[0].Value)
				expectedString = "new string"
				require.Equal(expectedString, rst.MutableStrings[0].Value)

				// check payment
				balance := bk.SpendableCoins(ctx, k.FeeCollectorAddress())
				require.True(balance.IsEqual(coinsWithUpdateFee))
			}
		})
	}
}
