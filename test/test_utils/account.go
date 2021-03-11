package testutils

import (
	"errors"
	codectypes "github.com/cosmos/cosmos-sdk/codec/types"
	cryptotypes "github.com/cosmos/cosmos-sdk/crypto/types"
	"sync"

	"github.com/Pylons-tech/pylons/x/pylons/handlers"
	testing "github.com/Pylons-tech/pylons_sdk/cmd/evtesting"
	sdk "github.com/cosmos/cosmos-sdk/types"
	authtypes "github.com/cosmos/cosmos-sdk/x/auth/types"
)

var keyMapMux sync.Mutex
var keyAddressMap = make(map[string]sdk.AccAddress)
var keyPrivateMap = make(map[string]cryptotypes.PrivKey)
var chainAccountCount uint64

// AddNewLocalKey is a function to add key cli
func AddNewLocalKey(key string) (sdk.AccAddress, error) {
	keyMapMux.Lock()
	defer keyMapMux.Unlock()
	address, exist := keyAddressMap[key]
	if exist {
		return address, errors.New("account already exist")
	}
	private, address, err := handlers.GenAccount()
	if err != nil {
		return address, err
	}
	keyAddressMap[key] = address
	keyPrivateMap[key] = private
	return address, err
}

// GetAccountAddr is a function to get account address from key
func GetAccountAddr(key string, t *testing.T) sdk.AccAddress {
	keyMapMux.Lock()
	defer keyMapMux.Unlock()
	address, exist := keyAddressMap[key]
	t.WithFields(testing.Fields{
		"address": address,
	}).MustTrue(exist, "key does not exist")
	return address
}

// CreateChainAccount is a function to create account on chain
func CreateChainAccount(key string) error {
	keyMapMux.Lock()
	defer keyMapMux.Unlock()
	address, exist := keyAddressMap[key]
	if !exist {
		return errors.New("account does not exist on local")
	}
	any, err := codectypes.NewAnyWithValue(keyPrivateMap[key].PubKey())
	if err != nil {
		return err
	}
	acc := &authtypes.BaseAccount{
		Sequence:      0,
		AccountNumber: chainAccountCount,
		PubKey:        any,
		Address:       address.String(),
	}
	tci.Ak.SetAccount(tci.Ctx, acc)
	chainAccountCount++

	return nil
}
