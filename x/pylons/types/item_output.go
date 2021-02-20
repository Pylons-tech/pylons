package types

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// NewItemModifyOutput returns ItemOutput that is modified from item input
func NewItemModifyOutput(ID string, ItemInputRef string, ModifyParams ItemModifyParams) ItemModifyOutput {
	return ItemModifyOutput{
		ID:           ID,
		ItemInputRef: ItemInputRef,
		Doubles:      ModifyParams.Doubles,
		Longs:        ModifyParams.Longs,
		Strings:      ModifyParams.Strings,
		TransferFee:  ModifyParams.TransferFee,
	}
}

// SetTransferFee set generate item's transfer fee
func (mit *ItemModifyOutput) SetTransferFee(transferFee int64) {
	mit.TransferFee = transferFee
}

// NewItemOutput returns new ItemOutput generated from recipe
func NewItemOutput(ID string, Doubles *DoubleParamList, Longs *LongParamList, Strings *StringParamList, TransferFee int64) ItemOutput {
	return ItemOutput{
		ID:          ID,
		Doubles:     Doubles,
		Longs:       Longs,
		Strings:     Strings,
		TransferFee: TransferFee,
	}
}

// SetTransferFee set generate item's transfer fee
func (io *ItemOutput) SetTransferFee(transferFee int64) {
	io.TransferFee = transferFee
}

// Item function acualize an item from item output data
func (io ItemOutput) Item(cookbook string, sender sdk.AccAddress, ec CelEnvCollection) (*Item, error) {
	// This function is used on ExecuteRecipe's AddExecutedResult, and it's
	// not acceptable to provide predefined GUID
	dblActualize, err := io.Doubles.Actualize(ec)
	if err != nil {
		return nil, err
	}
	longActualize, err := io.Longs.Actualize(ec)
	if err != nil {
		return nil, err
	}
	stringActualize, err := io.Strings.Actualize(ec)
	if err != nil {
		return nil, err
	}

	transferFee := io.TransferFee

	lastBlockHeight := ec.variables["lastBlockHeight"].(int64)

	return NewItem(cookbook, dblActualize, longActualize, stringActualize, sender, lastBlockHeight, transferFee), nil
}
