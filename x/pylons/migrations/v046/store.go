package v046

import (
	"github.com/Pylons-tech/pylons/x/pylons/types"
	v1 "github.com/Pylons-tech/pylons/x/pylons/types/v1"
	"github.com/cosmos/cosmos-sdk/codec"
	"github.com/cosmos/cosmos-sdk/store/prefix"
	storetypes "github.com/cosmos/cosmos-sdk/store/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	paramtypes "github.com/cosmos/cosmos-sdk/x/params/types"
)

// migrateProposals migrates all legacy proposals into MsgExecLegacyContent
// proposals.
func migrateAppleInAppPurchaseOrder(store sdk.KVStore, cdc codec.BinaryCodec) error {
	orderStore := prefix.NewStore(store, []byte(types.AppleInAppPurchaseOrderKey))

	iter := orderStore.Iterator(nil, nil)
	defer iter.Close()

	for ; iter.Valid(); iter.Next() {
		var oldProp v1.AppleInAppPurchaseOrder
		err := cdc.Unmarshal(iter.Value(), &oldProp)
		if err != nil {
			return err
		}

		newProp := convertToNewAppleInAppPurchaseOrder(oldProp)
		bz, err := cdc.Marshal(&newProp)
		if err != nil {
			return err
		}

		// Set new value on store.
		orderStore.Set(iter.Key(), bz)
	}

	return nil
}

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
func MigrateStore(ctx sdk.Context, storeKey storetypes.StoreKey, paramstore paramtypes.Subspace, cdc codec.BinaryCodec) error {
	store := ctx.KVStore(storeKey)
	migrateParamsStore(ctx, paramstore)
	return migrateAppleInAppPurchaseOrder(store, cdc)
}
