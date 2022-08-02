package v046

import (
	"github.com/cosmos/cosmos-sdk/codec"
	storetypes "github.com/cosmos/cosmos-sdk/store/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// migrateProposals migrates all legacy proposals into MsgExecLegacyContent
// proposals.
func migrateAppleInAppPurchaseOrder(store sdk.KVStore, cdc codec.BinaryCodec) error {

	return nil
}

// MigrateStore performs in-place store migrations from v0.43 to v0.46. The
// migration includes:
//
// - Migrate proposals to be Msg-based.
func MigrateStore(ctx sdk.Context, storeKey storetypes.StoreKey, cdc codec.BinaryCodec) error {
	store := ctx.KVStore(storeKey)

	return migrateAppleInAppPurchaseOrder(store, cdc)
}
