package inttest

import (
	"errors"
	"sync"

	testing "github.com/Pylons-tech/pylons/test/evtesting"
	"github.com/Pylons-tech/pylons/x/pylons/handlers"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/x/auth"
	"github.com/tendermint/tendermint/crypto/secp256k1"
)

var keyMapMux sync.Mutex
var keyAddressMap = make(map[string]sdk.AccAddress)
var keyPrivateMap = make(map[string]secp256k1.PrivKeySecp256k1)
var chainAccountCount uint64 = 0

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
	acc := &auth.BaseAccount{
		Sequence:      0,
		Coins:         sdk.Coins{},
		AccountNumber: chainAccountCount,
		PubKey:        keyPrivateMap[key].PubKey(),
		Address:       address,
	}
	tci.Ak.SetAccount(tci.Ctx, acc)

	return nil
}
