package v046_test

// func TestMigrateStore(t *testing.T) {
// 	cdc := simapp.MakeTestEncodingConfig().Codec
// 	key := sdk.NewKVStoreKey(types.AppleInAppPurchaseOrderKey)
// 	ctx := testutil.DefaultContext(key, sdk.NewTransientStoreKey("transient_test"))
// 	store := ctx.KVStore(key)

// 	// Create 2 AppleInAppPurchaseOrder
// 	prop1 := v1.AppleInAppPurchaseOrder{
// 		Quantity:     "1",
// 		ProductID:    "test_prod_1",
// 		PurchaseID:   "test_purchase_1",
// 		PurchaseDate: "28-07-2022",
// 		Creator:      types.GenTestBech32FromString("test1"),
// 	}
// 	prop1Bz, err := cdc.Marshal(&prop1)

// 	prop2 := v1.AppleInAppPurchaseOrder{
// 		Quantity:     "2",
// 		ProductID:    "test_prod_2",
// 		PurchaseID:   "test_purchase_2",
// 		PurchaseDate: "28-07-2022",
// 		Creator:      types.GenTestBech32FromString("test2"),
// 	}
// 	prop2Bz, err := cdc.Marshal(&prop2)

// 	store.Set(types.KeyPrefix(prop1.PurchaseID), prop1Bz)
// 	store.Set(types.KeyPrefix(prop2.PurchaseID), prop2Bz)

// 	// Run migrations.
// 	err = v046.MigrateStore(ctx, key, cdc)
// 	require.NoError(t, err)

// 	var newProp1 types.AppleInAppPurchaseOrder
// 	err = cdc.Unmarshal(store.Get(types.KeyPrefix(prop1.PurchaseID)), &newProp1)
// 	require.NoError(t, err)

// 	var newProp2 types.AppleInAppPurchaseOrder
// 	err = cdc.Unmarshal(store.Get(types.KeyPrefix(prop2.PurchaseID)), &newProp2)
// 	require.NoError(t, err)
// }
