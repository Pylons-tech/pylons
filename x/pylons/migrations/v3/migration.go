package v3

import (
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	paramtypes "github.com/cosmos/cosmos-sdk/x/params/types"
)

func migrateParamsStore(ctx sdk.Context, paramstore paramtypes.Subspace) {
	if paramstore.HasKeyTable() {
		paramstore.Set(ctx, types.ParamStoreKeyMaxTxsInBlock, types.DefaultMaxTxsInBlock)
	} else {
		paramstore.WithKeyTable(types.ParamKeyTable())
		paramstore.Set(ctx, types.ParamStoreKeyMaxTxsInBlock, types.DefaultMaxTxsInBlock)
	}
}

// MigrateStore performs in-place store migrations from v0.43 to v0.46. The
// migration includes:
//
// - Migrate proposals to be Msg-based.
func MigrateStore(ctx sdk.Context, paramstore paramtypes.Subspace) error {
	migrateParamsStore(ctx, paramstore)
	return nil
}
