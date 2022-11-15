# Pylons Upgrades

This folder contains sub-folders for every pylons upgrade. It also defines upgrade structs,
that each upgrade implements. These then get included in the application
`app.go` to run the upgrade.

## Version History

- v3 - migration to cosmos SDK v46
- v4 - Pre-Mainnet Upgrade
- v5 - Mainnet Upgrade

## Upgrade types

Upgrade defines a struct containing necessary fields that a `SoftwareUpgradeProposal`
must have written, in order for the state migration to go smoothly.
An upgrade must implement this struct, and then set it in the `app.go`.
The `app.go` will then define the `upgrade handler`.

```go
type Upgrade struct {
	// Upgrade version name, for the upgrade handler, e.g. `v7`
	UpgradeName string
	// Store upgrades, should be used for any new modules introduced, new modules deleted, or store names renamed.
	StoreUpgrades storetypes.StoreUpgrades
}
```
