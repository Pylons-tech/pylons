package keeper_test

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	bankTypes "github.com/cosmos/cosmos-sdk/x/bank/types"

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
		items = append(items, createNItemSameOwnerAndCookbook(k, ctx, 5, cookbook.ID)...)
	}

	owner := items[0].Owner
	receiver := types.GenTestBech32FromString("receiver")

	// assign coins to owner to pay for transfers - 5*5*100 = 2500pylon since every item created by
	// createNItemSameOwnerAndCookbook costs 100pylon to transfer
	// first, create an initial supply
	coin := sdk.NewCoin(types.PylonsCoinDenom, sdk.NewInt(2500))
	mintAmt := sdk.Coins{}
	mintAmt = mintAmt.Add(coin)
	// set arbitrary initial supply - can use same value as mintAmt
	supply := bankTypes.NewSupply(mintAmt)
	bk.SetSupply(ctx, supply)
	ownerAddr, _ := sdk.AccAddressFromBech32(owner)
	// transfer coins to our test address
	err := k.MintCoinsToAddr(ctx, ownerAddr, mintAmt)
	require.NoError(err)

	itemsRequestList := make([]types.ItemRef, 25)
	for i, item := range items {
		itemsRequestList[i] = types.ItemRef{CookbookID: item.CookbookID, ItemID: item.ID}
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
				Items: 	  itemsRequestList,
			},
			err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "Valid",
			request: &types.MsgSendItems{
				Creator:  owner,
				Receiver: receiver,
				Items: 	  itemsRequestList,
			},
			err: nil,
		},
		{
			desc: "InvalidRequest",
			request: &types.MsgSendItems{
				Creator:  owner,
				Receiver: receiver,
				Items: 	  []types.ItemRef{{CookbookID: "not_found", ItemID: "not_found"}},
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
					item, _ := k.GetItem(ctx, itemRef.CookbookID, itemRef.ItemID)
					require.Equal(tc.request.Receiver, item.Owner)
					for _, senderItem := range senderItems {
						require.NotEqual(itemRef.ItemID, senderItem.ID)
						require.NotEqual(itemRef.CookbookID, senderItem.CookbookID)
					}
				}
				// check that balance of sender is now 0pylon
				balance := bk.SpendableCoins(ctx, senderAddr)
				require.True(balance.IsEqual(sdk.NewCoins(sdk.NewCoin(types.PylonsCoinDenom, sdk.ZeroInt()))))
			}
		})
	}
}
