package v5

import (
	storetypes "github.com/cosmos/cosmos-sdk/store/types"

	"github.com/Pylons-tech/pylons/app/upgrades"
)

const (
	// UpgradeName is the shared upgrade plan name for mainnet and testnet
	UpgradeName = "v1.1.0"
)

// TODO: Update StoreUpgrades

var Upgrade = upgrades.Upgrade{
	UpgradeName: UpgradeName,
	StoreUpgrades: storetypes.StoreUpgrades{
		Added:   []string{},
		Deleted: []string{},
	},
}
