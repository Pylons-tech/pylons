package queriers

import (
	"context"
	"encoding/hex"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	crypto "github.com/tendermint/tendermint/crypto/secp256k1"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

// AddrFromPubKey returns a bech32 public address from the public key
func (querier *querierServer) AddrFromPubKey(ctx context.Context, req *types.AddrFromPubKeyRequest) (*types.AddrFromPubKeyResponse, error) {

	if req.HexPubKey == "" {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "The hex pub key not provided")
	}

	pubKeyBytes, err := hex.DecodeString(req.HexPubKey)
	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	var pubKeyBytes33 [33]byte
	copy(pubKeyBytes33[:], pubKeyBytes)
	var pubKey = crypto.PubKey(pubKeyBytes33[:])

	return &types.AddrFromPubKeyResponse{
		Bech32Addr: sdk.AccAddress(pubKey.Address().Bytes()).String(),
	}, nil
}
