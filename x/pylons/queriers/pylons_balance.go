package queriers

import (
	"context"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// query endpoints supported by the nameservice Querier
const (
	KeyPylonsBalance = "balance"
)

// PylonsBalance provides balances in pylons
func (querier *querierServer) PylonsBalance(ctx context.Context, req *types.PylonsBalanceRequest) (res *types.PylonsBalanceResponse, err error) {
	if req.Size() == 0 {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "no sender is provided in path")
	}

	accAddr, err1 := sdk.AccAddressFromBech32(req.Address)

	if err1 != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err1.Error())
	}
	coins := querier.Keeper.CoinKeeper.GetAllBalances(sdk.UnwrapSDKContext(ctx), accAddr)

	var value int64
	for _, coin := range coins {
		if coin.Denom == types.Pylon {
			value = coin.Amount.Int64()
			break
		}
	}

	return &types.PylonsBalanceResponse{
		Balance: value,
	}, nil
}
