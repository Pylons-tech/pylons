package queriers

import (
	"context"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// query endpoints supported by the nameservice Querier
const (
	KeyGetCookbook = "get_cookbook"
)

// GetCookbook returns a cookbook based on the cookbook id
func (querier *querierServer) GetCookbook(ctx context.Context, req *types.GetCookbookRequest) (*types.GetCookbookResponse, error) {
	if req.CookbookID == "" {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "no cookbook id is provided in path")
	}

	cookbook, err := querier.Keeper.GetCookbook(sdk.UnwrapSDKContext(ctx), req.CookbookID)

	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	return &types.GetCookbookResponse{
		NodeVersion:  cookbook.NodeVersion,
		ID:           cookbook.ID,
		Name:         cookbook.Name,
		Description:  cookbook.Description,
		Version:      cookbook.Version,
		Developer:    cookbook.Developer,
		Level:        cookbook.Level,
		SupportEmail: cookbook.SupportEmail,
		CostPerBlock: cookbook.CostPerBlock,
		Sender:       cookbook.Sender,
	}, nil
}
