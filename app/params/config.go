package params

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/address"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

const (
	PylonsHumanCoinUnit = "pylon"
	PylonsBaseCoinUnit  = "upylon"
	PylonsExponent      = 6

	StakingHumanCoinUnit = "bedrock"
	StakingBaseCoinUnit  = "ubedrock"
	StakingExponent      = 6

	// Bech32PrefixAccAddr defines the Bech32 prefix of an account's address
	Bech32PrefixAccAddr = "pylo"
)

var (
	// Bech32PrefixAccPub defines the Bech32 prefix of an account's public key
	Bech32PrefixAccPub = Bech32PrefixAccAddr + "pub"
	// Bech32PrefixValAddr defines the Bech32 prefix of a validator's operator address
	Bech32PrefixValAddr = Bech32PrefixAccAddr + "valoper"
	// Bech32PrefixValPub defines the Bech32 prefix of a validator's operator public key
	Bech32PrefixValPub = Bech32PrefixAccAddr + "valoperpub"
	// Bech32PrefixConsAddr defines the Bech32 prefix of a consensus node address
	Bech32PrefixConsAddr = Bech32PrefixAccAddr + "valcons"
	// Bech32PrefixConsPub defines the Bech32 prefix of a consensus node public key
	Bech32PrefixConsPub = Bech32PrefixAccAddr + "valconspub"
)

func SetupDenomsAndPrefixes() {
	SetAddressPrefixes()
	RegisterDenoms()
}

func RegisterDenoms() {
	// register pylon
	// err := sdk.RegisterDenom(PylonsHumanCoinUnit, math.OneInt())
	// if err != nil {
	//	panic(err)
	// }
	// err = sdk.RegisterDenom(PylonsBaseCoinUnit, sdk.NewDecWithPrec(1, PylonsExponent))
	// if err != nil {
	//	panic(err)
	// }

	// register bedrock
	err := sdk.RegisterDenom(StakingHumanCoinUnit, sdk.OneDec())
	if err != nil {
		panic(err)
	}
	err = sdk.RegisterDenom(StakingBaseCoinUnit, sdk.NewDecWithPrec(1, StakingExponent))
	if err != nil {
		panic(err)
	}
}

func SetAddressPrefixes() {
	config := sdk.GetConfig()
	config.SetBech32PrefixForAccount(Bech32PrefixAccAddr, Bech32PrefixAccPub)
	config.SetBech32PrefixForValidator(Bech32PrefixValAddr, Bech32PrefixValPub)
	config.SetBech32PrefixForConsensusNode(Bech32PrefixConsAddr, Bech32PrefixConsPub)

	config.SetAddressVerifier(func(bytes []byte) error {
		if len(bytes) == 0 {
			return sdkerrors.Wrap(sdkerrors.ErrUnknownAddress, "addresses cannot be empty")
		}

		if len(bytes) > address.MaxAddrLen {
			return sdkerrors.Wrapf(sdkerrors.ErrUnknownAddress, "address max length is %d, got %d", address.MaxAddrLen, len(bytes))
		}

		if len(bytes) != 20 && len(bytes) != 32 {
			return sdkerrors.Wrapf(sdkerrors.ErrUnknownAddress, "address length must be 20 or 32 bytes, got %d", len(bytes))
		}

		return nil
	})
}
