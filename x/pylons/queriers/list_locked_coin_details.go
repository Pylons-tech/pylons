package queriers

import (
	"context"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// query endpoints supported by the nameservice Querier
const (
	KeyGetLockedCoinDetails = "get_locked_coin_details"
)

// GetLockedCoinDetails returns locked coins with details based on user
func (querier *querierServer) GetLockedCoinDetails(ctx context.Context, req *types.GetLockedCoinDetailsRequest) (*types.GetLockedCoinDetailsResponse, error) {
	if req.Address == "" {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "no address is provided in path")
	}

	accAddr, err := sdk.AccAddressFromBech32(req.Address)

	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	lcd := querier.Keeper.GetLockedCoinDetails(sdk.UnwrapSDKContext(ctx), accAddr)

	return &types.GetLockedCoinDetailsResponse{
		Sender:         lcd.Sender,
		Amount:         lcd.Amount,
		LockCoinTrades: lcd.LockCoinTrades,
		LockCoinExecs:  lcd.LockCoinExecs,
	}, nil
}
