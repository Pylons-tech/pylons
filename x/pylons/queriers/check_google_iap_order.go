package queriers

import (
	"encoding/json"

	"github.com/Pylons-tech/pylons/x/pylons/keep"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	abci "github.com/tendermint/tendermint/abci/types"
)

// query endpoints supported by the nameservice Querier
const (
	KeyCheckGoogleIAPOrder = "check_google_iap_order"
)

// CheckGoogleIAPOrder check if google iap order is given to user with purchase token
func CheckGoogleIAPOrder(ctx sdk.Context, path []string, req abci.RequestQuery, keeper keep.Keeper) ([]byte, error) {
	if len(path) == 0 {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "no item id is provided in path")
	}
	purchaseToken := path[0]
	exist := keeper.HasGoogleIAPOrder(ctx, purchaseToken)

	// if we cannot find the value then it should return an error
	bz, err := json.Marshal(map[string]interface{}{
		"purchaseToken": purchaseToken,
		"exist":         exist,
	})
	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	return bz, nil

}
