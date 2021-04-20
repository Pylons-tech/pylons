package queriers

import (
	"context"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// query endpoints supported by the nameservice Querier
const (
	KeyListCookbook = "list_cookbook"
)

// ListCookbook returns a cookbook based on the cookbook id
func (querier *querierServer) ListCookbook(ctx context.Context, req *types.ListCookbookRequest) (*types.ListCookbookResponse, error) {
	var err error
	var accAddr sdk.AccAddress

	if req.Address != "" {
		accAddr, err = sdk.AccAddressFromBech32(req.Address)

		if err != nil {
			return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
		}
	}

	cookbooks, err := querier.Keeper.GetCookbooksBySender(sdk.UnwrapSDKContext(ctx), accAddr)
	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	return &types.ListCookbookResponse{Cookbooks: cookbooks}, nil
}
