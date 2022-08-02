package v046_test

import (
	"testing"

	"github.com/stretchr/testify/require"

	"github.com/cosmos/cosmos-sdk/simapp"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	v1 "github.com/Pylons-tech/pylons/x/pylons/types/v1"
)

func TestVuong(t *testing.T) {
	cdc := simapp.MakeTestEncodingConfig().Codec
	// key := sdk.NewKVStoreKey(types.AppleInAppPurchaseOrderKey)
	// ctx := testutil.DefaultContext(key, sdk.NewTransientStoreKey("transient_test"))
	// store := ctx.KVStore(key)

	prop1 := v1.Recipe{
		CookbookID:  "ss",
		ID:          "ss",
		NodeVersion: 8,
		Name:        "khanh",
	}

	prop1Bz := cdc.MustMarshal(&prop1)

	prop2 := types.Recipe{
		CookbookId:  "ss",
		Id:          "ss",
		NodeVersion: 8,
		Name:        "khanh",
	}
	prop2Bz := cdc.MustMarshal(&prop2)

	require.Equal(t, prop1Bz, prop2Bz)
}
