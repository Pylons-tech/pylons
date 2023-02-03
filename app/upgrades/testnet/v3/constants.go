package v3

import (
	"github.com/Pylons-tech/pylons/app/upgrades"
	storetypes "github.com/cosmos/cosmos-sdk/store/types"
	icacontrollertypes "github.com/cosmos/ibc-go/v5/modules/apps/27-interchain-accounts/controller/types"
	icahosttypes "github.com/cosmos/ibc-go/v5/modules/apps/27-interchain-accounts/host/types"
)

const UpgradeName = "sdk-46"

var Upgrade = upgrades.Upgrade{
	UpgradeName: UpgradeName,
	StoreUpgrades: storetypes.StoreUpgrades{
		Added:   []string{icacontrollertypes.StoreKey, icahosttypes.StoreKey},
		Deleted: []string{"epoch"},
	},
}
