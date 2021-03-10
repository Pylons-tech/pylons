package queriers

import (
	"context"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// query endpoints supported by the nameservice Querier
const (
	KeyGetLockedCoin = "get_locked_coins"
)

// GetLockedCoins returns locked coins based on user
func (querier *querierServer) GetLockedCoins(ctx context.Context, req *types.GetLockedCoinsRequest) (*types.GetLockedCoinsResponse, error) {
	if req.Address == "" {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "no address is provided in path")
	}

	accAddr, err := sdk.AccAddressFromBech32(req.Address)

	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	lc := querier.Keeper.GetLockedCoin(sdk.UnwrapSDKContext(ctx), accAddr)

	return &types.GetLockedCoinsResponse{
		NodeVersion: lc.NodeVersion,
		Sender:      lc.Sender.String(),
		Amount:      lc.Amount,
	}, nil
}
