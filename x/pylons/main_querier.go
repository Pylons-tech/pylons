package pylons

import (
	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/queriers"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	abci "github.com/tendermint/tendermint/abci/types"
)

// NewQuerier is the module level router for state queries
func NewQuerier(keeper keep.Keeper) sdk.Querier {
	return func(ctx sdk.Context, path []string, req abci.RequestQuery) (res []byte, err error) {
		if len(path) < 1 {
			return nil, sdkerrors.Wrap(sdkerrors.ErrUnknownRequest, "no endpoint path provided for pylons query")
		}
		switch path[0] {
		case queriers.KeyPylonsBalance:
			return queriers.PylonsBalance(ctx, path[1:], req, keeper)
		case queriers.KeyCheckGoogleIAPOrder:
			return queriers.CheckGoogleIAPOrder(ctx, path[1:], req, keeper)
		case queriers.KeyGetCookbook:
			return queriers.GetCookbook(ctx, path[1:], req, keeper)
		case queriers.KeyGetItem:
			return queriers.GetItem(ctx, path[1:], req, keeper)
		case queriers.KeyGetRecipe:
			return queriers.GetRecipe(ctx, path[1:], req, keeper)
		case queriers.KeyGetExecution:
			return queriers.GetExecution(ctx, path[1:], req, keeper)
		case queriers.KeyGetTrade:
			return queriers.GetTrade(ctx, path[1:], req, keeper)
		case queriers.KeyListCookbook:
			return queriers.ListCookbook(ctx, path[1:], req, keeper)
		case queriers.KeyGetLockedCoin:
			return queriers.GetLockedCoins(ctx, path[1:], req, keeper)
		case queriers.KeyGetLockedCoinDetails:
			return queriers.GetLockedCoinDetails(ctx, path[1:], req, keeper)
		case queriers.KeyAddrFromPubKey:
			return queriers.AddrFromPubKey(ctx, path[1:], req, keeper)
		case queriers.KeyListRecipe:
			return queriers.ListRecipe(ctx, path[1:], req, keeper)
		case queriers.KeyListRecipeByCookbook:
			return queriers.ListRecipeByCookbook(ctx, path[1:], req, keeper)
		case queriers.KeyListShortenRecipe:
			return queriers.ListShortenRecipe(ctx, path[1:], req, keeper)
		case queriers.KeyListShortenRecipeByCookbook:
			return queriers.ListShortenRecipeByCookbook(ctx, path[1:], req, keeper)
		case queriers.KeyItemsByCookbook:
			return queriers.ItemsByCookbook(ctx, path[1:], req, keeper)
		case queriers.KeyItemsBySender:
			return queriers.ItemsBySender(ctx, path[1:], req, keeper)
		case queriers.KeyListExecutions:
			return queriers.ListExecutions(ctx, path[1:], req, keeper)
		case queriers.KeyListTrade:
			return queriers.ListTrade(ctx, path[1:], req, keeper)
		default:
			return nil, sdkerrors.Wrap(sdkerrors.ErrUnknownRequest, "unknown pylons query endpoint")
		}
	}
}
