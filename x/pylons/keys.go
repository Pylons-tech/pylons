package pylons

import (
	"github.com/Pylons-tech/pylons/x/pylons/types"
)

const (
	// ModuleName is the name of the module
	ModuleName = types.ModuleName

	// StoreKey to be used when creating the KVStore
	StoreKey = ModuleName

	// RouterKey is the module name router key
	RouterKey = types.RouterKey

	// QuerierRoute to be used for querierer msgs
	QuerierRoute = ModuleName
)
