package keeper

import (
	"github.com/Pylons-tech/pylons/x/pylons/types/v1beta1"
	"github.com/cosmos/cosmos-sdk/store/prefix"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// SetPylonsAccount set a specific pylons account in the store from its index
// this function sets two symmetric KVStores with address -> username
// and username -> address mappings
func (k Keeper) SetPylonsAccount(ctx sdk.Context, accountAddr v1beta1.AccountAddr, username v1beta1.Username) {
	binaryAddr := k.cdc.MustMarshal(&accountAddr)
	binaryUsername := k.cdc.MustMarshal(&username)
	usernamePrefixStore := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.UsernameKey))
	accountPrefixStore := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.AccountKey))

	usernamePrefixStore.Set(v1beta1.KeyPrefix(username.Value), binaryAddr)
	accountPrefixStore.Set(v1beta1.KeyPrefix(accountAddr.Value), binaryUsername)
}

func (k Keeper) SetPylonsReferral(ctx sdk.Context, address, username, referral string) {
	val, found := k.GetPylonsReferral(ctx, referral)
	if found {
		val.Users = append(val.Users, &v1beta1.RefereeSignup{
			Username: username,
			Address:  address,
		})
		binaryReferral := k.cdc.MustMarshal(&val)
		referralPrefixStore := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.ReferralKey))
		referralPrefixStore.Set(v1beta1.KeyPrefix(referral), binaryReferral)
	} else {
		binaryReferral := k.cdc.MustMarshal(&v1beta1.ReferralKV{
			Address: referral,
			Users: []*v1beta1.RefereeSignup{
				{
					Username: username,
					Address:  address,
				},
			},
		})
		referralPrefixStore := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.ReferralKey))
		referralPrefixStore.Set(v1beta1.KeyPrefix(referral), binaryReferral)
	}
}

func (k Keeper) GetPylonsReferral(ctx sdk.Context, addr string) (val v1beta1.ReferralKV, found bool) {
	referralPrefixStore := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.ReferralKey))
	b := referralPrefixStore.Get(v1beta1.KeyPrefix(addr))
	if b == nil {
		return val, false
	}
	k.cdc.MustUnmarshal(b, &val)
	return val, true
}

// HasUsername checks if the username exists in the store
func (k Keeper) HasUsername(ctx sdk.Context, username v1beta1.Username) bool {
	usernamePrefixStore := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.UsernameKey))

	has := usernamePrefixStore.Has(v1beta1.KeyPrefix(username.Value))

	return has
}

// HasAccountAddr checks if the accountAddr exists in the store
func (k Keeper) HasAccountAddr(ctx sdk.Context, accountAddr v1beta1.AccountAddr) bool {
	accountPrefixStore := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.AccountKey))

	has := accountPrefixStore.Has(v1beta1.KeyPrefix(accountAddr.Value))

	return has
}

// GetAddressByUsername returns an address corresponding to its username
func (k Keeper) GetAddressByUsername(ctx sdk.Context, username string) (val v1beta1.AccountAddr, found bool) {
	usernamePrefixStore := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.UsernameKey))

	b := usernamePrefixStore.Get(v1beta1.KeyPrefix(username))
	if b == nil {
		return val, false
	}

	k.cdc.MustUnmarshal(b, &val)
	return val, true
}

// GetUsernameByAddress returns a username corresponding to its address
func (k Keeper) GetUsernameByAddress(ctx sdk.Context, address string) (val v1beta1.Username, found bool) {
	accountPrefixStore := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.AccountKey))

	b := accountPrefixStore.Get(v1beta1.KeyPrefix(address))
	if b == nil {
		return val, false
	}

	k.cdc.MustUnmarshal(b, &val)
	return val, true
}

// GetAllPylonsAccount returns symmetric username mappings
func (k Keeper) GetAllPylonsAccount(ctx sdk.Context) (list []v1beta1.UserMap) {
	usernamePrefixStore := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.UsernameKey))
	iterator := sdk.KVStorePrefixIterator(usernamePrefixStore, []byte{})

	defer iterator.Close()

	for ; iterator.Valid(); iterator.Next() {
		var account v1beta1.AccountAddr
		k.cdc.MustUnmarshal(iterator.Value(), &account)
		username, found := k.GetUsernameByAddress(ctx, account.Value)
		if found {
			list = append(list, v1beta1.UserMap{AccountAddr: account.Value, Username: username.Value})
		}

	}

	return
}
