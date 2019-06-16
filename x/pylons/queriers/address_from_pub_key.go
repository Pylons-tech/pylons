package queriers

import (
	"encoding/hex"

	"github.com/MikeSofaer/pylons/x/pylons/keep"
	sdk "github.com/cosmos/cosmos-sdk/types"
	abci "github.com/tendermint/tendermint/abci/types"
	crypto "github.com/tendermint/tendermint/crypto/secp256k1"
)

// query endpoints supported by the nameservice Querier
const (
	KeyAddrFromPubKey = "addr_from_pub_key"
)

// AddrFromPubKey returns a cookbook based on the cookbook id
func AddrFromPubKey(ctx sdk.Context, path []string, req abci.RequestQuery, keeper keep.Keeper) ([]byte, sdk.Error) {

	if len(path) < 1 {
		return nil, sdk.ErrInternal("The hex pub key not provided")
	}
	hexPubKey := path[0]

	pubKeyBytes, err := hex.DecodeString(hexPubKey)
	if err != nil {
		return nil, sdk.ErrInternal(err.Error())
	}

	var pubKeyBytes33 [33]byte
	copy(pubKeyBytes33[:], pubKeyBytes)
	pubKey := crypto.PubKeySecp256k1(pubKeyBytes33)

	addrResp := AddrResp{
		Bech32Addr: sdk.AccAddress(pubKey.Address().Bytes()).String(),
	}
	// if we cannot find the value then it should return an error
	bz, err := keeper.Cdc.MarshalJSON(addrResp)
	if err != nil {
		return nil, sdk.ErrInternal(err.Error())
	}

	return bz, nil

}

// AddrResp holds the bech32 encoded address
type AddrResp struct {
	Bech32Addr string
}
