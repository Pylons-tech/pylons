package types

type DoubleUpgradeParam struct {
	Key           string
	UpgradeAmount FloatString // set item's double Key value to originalValue + UpgradeAmount on item
}
