package keeper

import (
	"crypto"
	"crypto/rsa"
	"crypto/sha1" // nolint: gosec
	"crypto/x509"
	"encoding/base64"
	"fmt"
	"strconv"

	"github.com/cosmos/cosmos-sdk/store/prefix"
	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

// GetGoogleIAPOrderCount get the total number of TypeName.LowerCamel
func (k Keeper) GetGoogleIAPOrderCount(ctx sdk.Context) uint64 {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.GoogleInAppPurchaseOrderCountKey))
	byteKey := types.KeyPrefix(types.GoogleInAppPurchaseOrderCountKey)
	bz := store.Get(byteKey)

	// Count doesn't exist: no element
	if bz == nil {
		return 0
	}

	// Parse bytes
	count, err := strconv.ParseUint(string(bz), 10, 64)
	if err != nil {
		// Panic because the count should be always formattable to uint64
		panic("cannot decode count")
	}

	return count
}

// SetGoogleIAPOrderCount set the total number of googlIAPOrder
func (k Keeper) SetGoogleIAPOrderCount(ctx sdk.Context, count uint64) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.GoogleInAppPurchaseOrderCountKey))
	byteKey := types.KeyPrefix(types.GoogleInAppPurchaseOrderCountKey)
	bz := []byte(strconv.FormatUint(count, 10))
	store.Set(byteKey, bz)

	// required for random seed init given how it's handled rn
	k.IncrementEntityCount(ctx)
}

// AppendGoogleIAPOrder appends a googleIAPOrder in the store with a new id and update the count
func (k Keeper) AppendGoogleIAPOrder(
	ctx sdk.Context,
	googleIAPOrder types.GoogleInAppPurchaseOrder,
) uint64 {
	// Create the googleIAPOrder
	count := k.GetGoogleIAPOrderCount(ctx)

	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.GoogleInAppPurchaseOrderKey))
	appendedValue := k.cdc.MustMarshalBinaryBare(&googleIAPOrder)
	store.Set(types.KeyPrefix(googleIAPOrder.PurchaseToken), appendedValue)

	// Update googleIAPOrder count
	k.SetGoogleIAPOrderCount(ctx, count+1)

	return count
}

// SetGoogleIAPOrder set a specific googleIAPOrder in the store
func (k Keeper) SetGoogleIAPOrder(ctx sdk.Context, googleIAPOrder types.GoogleInAppPurchaseOrder) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.GoogleInAppPurchaseOrderKey))
	b := k.cdc.MustMarshalBinaryBare(&googleIAPOrder)
	store.Set(types.KeyPrefix(googleIAPOrder.PurchaseToken), b)
}

// GetGoogleIAPOrder returns a googleIAPOrder from its id
func (k Keeper) GetGoogleIAPOrder(ctx sdk.Context, purchaseToken string) types.GoogleInAppPurchaseOrder {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.GoogleInAppPurchaseOrderKey))
	var googleIAPOrder types.GoogleInAppPurchaseOrder
	k.cdc.MustUnmarshalBinaryBare(store.Get(types.KeyPrefix(purchaseToken)), &googleIAPOrder)
	return googleIAPOrder
}

// HasGoogleIAPOrder checks if the googleIAPOrder exists in the store
func (k Keeper) HasGoogleIAPOrder(ctx sdk.Context, purchaseToken string) bool {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.GoogleInAppPurchaseOrderKey))
	return store.Has(types.KeyPrefix(purchaseToken))
}

// GetGoogleIAPOrderOwner returns the creator of the
func (k Keeper) GetGoogleIAPOrderOwner(ctx sdk.Context, purchaseToken string) string {
	return k.GetGoogleIAPOrder(ctx, purchaseToken).Creator
}

// GetAllGoogleIAPOrder returns all googleIAPOrder
func (k Keeper) GetAllGoogleIAPOrder(ctx sdk.Context) (list []types.GoogleInAppPurchaseOrder) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.GoogleInAppPurchaseOrderKey))
	iterator := sdk.KVStorePrefixIterator(store, []byte{})

	defer iterator.Close()

	for ; iterator.Valid(); iterator.Next() {
		var val types.GoogleInAppPurchaseOrder
		k.cdc.MustUnmarshalBinaryBare(iterator.Value(), &val)
		list = append(list, val)
	}

	return
}

// ValidateGoogleIAPSignature is function for testing signature on local
func (k Keeper) ValidateGoogleIAPSignature(ctx sdk.Context, msg *types.MsgGoogleInAppPurchaseGetPylons) error {
	// References
	// offline verification JS module https://github.com/voltrue2/in-app-purchase/blob/e966ee1348bd4f67581779abeec59c4bbc2b2ebc/lib/google.js#L788
	// Cordova Plugin code that check offline https://github.com/j3k0/cordova-plugin-purchase/blob/8861bd2392a48d643ffc754b8f59afc1e6afab60/src/android/cc/fovea/Security.java#L94
	// https://stackoverflow.com/questions/31349710/google-play-billing-response-signature-verification

	// We should contact google team to check if this is correct use

	// TODO switch coins types
	playStorePubKeyBytes, err := base64.StdEncoding.DecodeString(k.CoinIssuers(ctx)[0].GoogleInAppPurchasePubKey)
	if err != nil {
		return fmt.Errorf("play store base64 public key decoding failure: %s", err.Error())
	}
	re, err := x509.ParsePKIXPublicKey(playStorePubKeyBytes)
	if err != nil {
		return err
	}
	pub := re.(*rsa.PublicKey)
	receiptData, err := base64.StdEncoding.DecodeString(msg.ReceiptDataBase64)
	if err != nil {
		return err
	}

	// Google forces us to use unsafe sha1 for IAP verification
	h := sha1.New() // nolint: gosec
	_, err = h.Write(receiptData)
	if err != nil {
		return err
	}
	digest := h.Sum(nil)

	ds, err := base64.StdEncoding.DecodeString(msg.Signature)
	if err != nil {
		return fmt.Errorf("msg signature base64 decoding failure: %s", err.Error())
	}
	err = rsa.VerifyPKCS1v15(pub, crypto.SHA1, digest, ds)
	return err
}

// GetAmount returns pylons amount by product and package
func (k Keeper) GetAmount(ctx sdk.Context, iap types.GoogleInAppPurchaseOrder) sdk.Coins {

	for _, issuer := range k.CoinIssuers(ctx) {
		pkgs := issuer.Packages
		for _, pkg := range pkgs {
			if pkg.ProductID == iap.ProductID {
				return sdk.Coins{sdk.NewCoin(types.PylonsCoinDenom, pkg.Amount)}
			}
		}
	}

	return sdk.Coins{sdk.NewInt64Coin(types.PylonsCoinDenom, 0)}
}
