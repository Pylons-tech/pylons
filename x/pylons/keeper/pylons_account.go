package keeper

import (
	"github.com/cosmos/cosmos-sdk/store/prefix"
	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

// SetPylonsAccount set a specific pylons account in the store from its index
// this function sets two symmetric KVStores with address -> username
// and username -> address mappings
func (k Keeper) SetPylonsAccount(ctx sdk.Context, accountAddr types.AccountAddr, username types.Username) {
	binaryAddr := k.cdc.MustMarshal(&accountAddr)
	binaryUsername := k.cdc.MustMarshal(&username)
	usernamePrefixStore := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.UsernameKey))
	accountPrefixStore := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.AccountKey))

	usernamePrefixStore.Set(types.KeyPrefix(username.Value), binaryAddr)
	accountPrefixStore.Set(types.KeyPrefix(accountAddr.Value), binaryUsername)
}

func (k Keeper) SetPylonsReferral(ctx sdk.Context, address, username, referral string) {
	val, found := k.GetPylonsReferral(ctx, referral)
	if found {
		val.Users = append(val.Users, &types.RefereeSignup{
			Username: username,
			Address:  address,
		})
		binaryReferral := k.cdc.MustMarshal(&val)
		referralPrefixStore := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.ReferralKey))
		referralPrefixStore.Set(types.KeyPrefix(referral), binaryReferral)
	} else {
		binaryReferral := k.cdc.MustMarshal(&types.ReferralKV{
			Address: referral,
			Users: []*types.RefereeSignup{
				{
					Username: username,
					Address:  address,
				},
			},
		})
		referralPrefixStore := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.ReferralKey))
		referralPrefixStore.Set(types.KeyPrefix(referral), binaryReferral)
	}
}

func (k Keeper) GetPylonsReferral(ctx sdk.Context, addr string) (val types.ReferralKV, found bool) {
	referralPrefixStore := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.ReferralKey))
	b := referralPrefixStore.Get(types.KeyPrefix(addr))
	if b == nil {
		return val, false
	}
	k.cdc.MustUnmarshal(b, &val)
	return val, true
}

func (k Keeper) SetPylonsKYC(ctx sdk.Context, kycaddress types.KYCAddress, kycusername types.KYCUsername) {
	binaryKYCAddr := k.cdc.MustMarshal(&kycaddress)
	binaryKYCUser := k.cdc.MustMarshal(&kycusername)
	kycaddrPrefixStore := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.KYCAddressKey))
	kycuserPrefixStore := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.KYCUsernameKey))

	kycaddrPrefixStore.Set(types.KeyPrefix(kycaddress.Value), binaryKYCUser)
	kycuserPrefixStore.Set(types.KeyPrefix(kycusername.Value), binaryKYCAddr)
}

func (k Keeper) HasPylonsKYC(ctx sdk.Context, kycaddress types.KYCAddress) bool {
	kycaddrPrefixStore := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.KYCAddressKey))

	has := kycaddrPrefixStore.Has(types.KeyPrefix(kycaddress.Value))

	return has
}

// GetAddressByUsername returns an address corresponding to its username
func (k Keeper) GetKYCAddressByUsername(ctx sdk.Context, kycusername string) (val types.KYCAddress, found bool) {
	kycuserPrefixStore := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.KYCUsernameKey))

	b := kycuserPrefixStore.Get(types.KeyPrefix(kycusername))
	if b == nil {
		return val, false
	}

	k.cdc.MustUnmarshal(b, &val)
	return val, true
}

// GetUsernameByAddress returns a username corresponding to its address
func (k Keeper) GetKYCUsernameByAddress(ctx sdk.Context, kycaddress string) (val types.KYCUsername, found bool) {
	kycaddrPrefixStore := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.KYCAddressKey))

	b := kycaddrPrefixStore.Get(types.KeyPrefix(kycaddress))
	if b == nil {
		return val, false
	}

	k.cdc.MustUnmarshal(b, &val)
	return val, true
}

func (k Keeper) GetPylonsKYC(ctx sdk.Context, addr string) (val types.KYCAddress, found bool) {
	kycPrefixStore := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.KYCAddressKey))
	b := kycPrefixStore.Get(types.KeyPrefix(addr))
	if b == nil {
		return val, false
	}
	k.cdc.MustUnmarshal(b, &val)
	return val, true
}

// HasUsername checks if the username exists in the store
func (k Keeper) HasUsername(ctx sdk.Context, username types.Username) bool {
	usernamePrefixStore := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.UsernameKey))

	has := usernamePrefixStore.Has(types.KeyPrefix(username.Value))

	return has
}

// HasAccountAddr checks if the accountAddr exists in the store
func (k Keeper) HasAccountAddr(ctx sdk.Context, accountAddr types.AccountAddr) bool {
	accountPrefixStore := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.AccountKey))

	has := accountPrefixStore.Has(types.KeyPrefix(accountAddr.Value))

	return has
}

// GetAddressByUsername returns an address corresponding to its username
func (k Keeper) GetAddressByUsername(ctx sdk.Context, username string) (val types.AccountAddr, found bool) {
	usernamePrefixStore := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.UsernameKey))

	b := usernamePrefixStore.Get(types.KeyPrefix(username))
	if b == nil {
		return val, false
	}

	k.cdc.MustUnmarshal(b, &val)
	return val, true
}

// GetUsernameByAddress returns a username corresponding to its address
func (k Keeper) GetUsernameByAddress(ctx sdk.Context, address string) (val types.Username, found bool) {
	accountPrefixStore := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.AccountKey))

	b := accountPrefixStore.Get(types.KeyPrefix(address))
	if b == nil {
		return val, false
	}

	k.cdc.MustUnmarshal(b, &val)
	return val, true
}

// GetAllPylonsAccount returns symmetric username mappings
func (k Keeper) GetAllPylonsAccount(ctx sdk.Context) (list []types.UserMap) {
	usernamePrefixStore := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.UsernameKey))
	iterator := sdk.KVStorePrefixIterator(usernamePrefixStore, []byte{})

	defer iterator.Close()

	for ; iterator.Valid(); iterator.Next() {
		var account types.AccountAddr
		k.cdc.MustUnmarshal(iterator.Value(), &account)
		username, found := k.GetUsernameByAddress(ctx, account.Value)
		if found {
			list = append(list, types.UserMap{AccountAddr: account.Value, Username: username.Value})
		}

	}

	return
}
