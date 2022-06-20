package keeper_test

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"

	"github.com/Pylons-tech/pylons/x/pylons/keeper"
	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (suite *IntegrationTestSuite) TestMsgServerSendItems() {
	k := suite.k
	bk := suite.bankKeeper
	ctx := suite.ctx
	require := suite.Require()

	wctx := sdk.WrapSDKContext(ctx)
	srv := keeper.NewMsgServerImpl(k)

	// create N cookbook for N different creators
	cookbooks := createNCookbook(k, ctx, 5)
	// create N items for each cookbook, all with same owner
	items := make([]types.Item, 0)
	for _, cookbook := range cookbooks {
		items = append(items, createNItemSameOwnerAndCookbook(k, ctx, 5, cookbook.Id, true)...)
	}

	owner := items[0].Owner
	receiver := types.GenTestBech32FromString("receiver")

	// assign coins to owner to pay for transfers - 5*5*100 = 2500pylon since every item created by
	// createNItemSameOwnerAndCookbook costs 100pylon to transfer
	// first, create an initial supply
	coin := sdk.NewCoin(types.PylonsCoinDenom, sdk.NewInt(2500))
	mintAmt := sdk.NewCoins()
	mintAmt = mintAmt.Add(coin)

	ownerAddr, _ := sdk.AccAddressFromBech32(owner)
	// transfer coins to our test address
	err := k.MintCoinsToAddr(ctx, ownerAddr, mintAmt)
	require.NoError(err)

	itemsRequestList := make([]types.ItemRef, 25)
	for i, item := range items {
		itemsRequestList[i] = types.ItemRef{CookbookId: item.CookbookId, ItemId: item.Id}
	}

	for _, tc := range []struct {
		desc    string
		request *types.MsgSendItems
		err     error
	}{
		{
			desc: "Unauthorized",
			request: &types.MsgSendItems{
				Creator:  types.GenTestBech32FromString("wrong_owner"),
				Receiver: receiver,
				Items:    itemsRequestList,
			},
			err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "Valid",
			request: &types.MsgSendItems{
				Creator:  owner,
				Receiver: receiver,
				Items:    itemsRequestList,
			},
			err: nil,
		},
		{
			desc: "InvalidRequest",
			request: &types.MsgSendItems{
				Creator:  owner,
				Receiver: receiver,
				Items:    []types.ItemRef{{CookbookId: "not_found", ItemId: "not_found"}},
			},
			err: sdkerrors.ErrInvalidRequest,
		},
	} {
		tc := tc
		suite.Run(tc.desc, func() {
			_, err := srv.SendItems(wctx, tc.request)
			if tc.err != nil {
				require.ErrorIs(err, tc.err)
			} else {
				require.NoError(err)
				// check that transfer completed
				senderAddr, _ := sdk.AccAddressFromBech32(tc.request.Creator)
				senderItems := k.GetAllItemByOwner(ctx, senderAddr)
				for _, itemRef := range tc.request.Items {
					item, _ := k.GetItem(ctx, itemRef.CookbookId, itemRef.ItemId)
					require.Equal(tc.request.Receiver, item.Owner)
					for _, senderItem := range senderItems {
						require.NotEqual(itemRef.ItemId, senderItem.Id)
						require.NotEqual(itemRef.CookbookId, senderItem.CookbookId)
					}
				}
				// check that balance of sender is now 0pylon
				balance := bk.SpendableCoins(ctx, senderAddr)
				require.True(balance.IsEqual(sdk.NewCoins(sdk.NewCoin(types.PylonsCoinDenom, sdk.ZeroInt()))))
			}
		})
	}
}

func (suite *IntegrationTestSuite) TestMsgServerSendItemsNonTradable() {
	k := suite.k
	bk := suite.bankKeeper
	ctx := suite.ctx
	require := suite.Require()

	wctx := sdk.WrapSDKContext(ctx)
	srv := keeper.NewMsgServerImpl(k)

	// create N cookbook for N different creators
	cookbooks := createNCookbook(k, ctx, 5)
	// create N items for each cookbook, all with same owner
	items := make([]types.Item, 0)
	for _, cookbook := range cookbooks {
		items = append(items, createNItemSameOwnerAndCookbook(k, ctx, 5, cookbook.Id, false)...)
	}

	owner := items[0].Owner
	receiver := types.GenTestBech32FromString("receiver")

	// assign coins to owner to pay for transfers - 5*5*100 = 2500pylon since every item created by
	// createNItemSameOwnerAndCookbook costs 100pylon to transfer
	// first, create an initial supply
	coin := sdk.NewCoin(types.PylonsCoinDenom, sdk.NewInt(2500))
	mintAmt := sdk.NewCoins()
	mintAmt = mintAmt.Add(coin)

	ownerAddr, _ := sdk.AccAddressFromBech32(owner)
	// transfer coins to our test address
	err := k.MintCoinsToAddr(ctx, ownerAddr, mintAmt)
	require.NoError(err)

	itemsRequestList := make([]types.ItemRef, 25)
	for i, item := range items {
		itemsRequestList[i] = types.ItemRef{CookbookId: item.CookbookId, ItemId: item.Id}
	}

	for _, tc := range []struct {
		desc    string
		request *types.MsgSendItems
		err     error
	}{
		{
			desc: "Unauthorized",
			request: &types.MsgSendItems{
				Creator:  types.GenTestBech32FromString("wrong_owner"),
				Receiver: receiver,
				Items:    itemsRequestList,
			},
			err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "NonTradable",
			request: &types.MsgSendItems{
				Creator:  owner,
				Receiver: receiver,
				Items:    itemsRequestList,
			},
			err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "InvalidRequest",
			request: &types.MsgSendItems{
				Creator:  owner,
				Receiver: receiver,
				Items:    []types.ItemRef{{CookbookId: "not_found", ItemId: "not_found"}},
			},
			err: sdkerrors.ErrInvalidRequest,
		},
	} {
		tc := tc
		suite.Run(tc.desc, func() {
			_, err := srv.SendItems(wctx, tc.request)
			if tc.err != nil {
				require.ErrorIs(err, tc.err)
			} else {
				require.NoError(err)
				// check that transfer completed
				senderAddr, _ := sdk.AccAddressFromBech32(tc.request.Creator)
				senderItems := k.GetAllItemByOwner(ctx, senderAddr)
				for _, itemRef := range tc.request.Items {
					item, _ := k.GetItem(ctx, itemRef.CookbookId, itemRef.ItemId)
					require.Equal(tc.request.Receiver, item.Owner)
					for _, senderItem := range senderItems {
						require.NotEqual(itemRef.ItemId, senderItem.Id)
						require.NotEqual(itemRef.CookbookId, senderItem.CookbookId)
					}
				}
				// check that balance of sender is now 0pylon
				balance := bk.SpendableCoins(ctx, senderAddr)
				require.True(balance.IsEqual(sdk.NewCoins(sdk.NewCoin(types.PylonsCoinDenom, sdk.ZeroInt()))))
			}
		})
	}
}
