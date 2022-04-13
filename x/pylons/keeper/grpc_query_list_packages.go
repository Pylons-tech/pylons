package keeper

import (
	"context"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

func (k Keeper) ListPackages(goCtx context.Context, req *types.QueryListPackagesRequest) (*types.QueryListPackagesResponse, error) {
	if req == nil {
		return nil, status.Error(codes.InvalidArgument, "invalid request")
	}

	ctx := sdk.UnwrapSDKContext(goCtx)
	var googleIapPackageList []*types.GoogleInAppPurchasePackage

	for _, ci := range k.CoinIssuers(ctx) {

		for _, pack := range ci.Packages {
			p := pack
			googleIapPackageList = append(googleIapPackageList, &p)
		}

	}
	// TODO: Process the query
	_ = ctx

	return &types.QueryListPackagesResponse{PackageList: googleIapPackageList}, nil
}
