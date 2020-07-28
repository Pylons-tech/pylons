package types

import (
	"fmt"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

// ItemModifyParams describes the fields that needs to be modified
type ItemModifyParams struct {
	Doubles     DoubleParamList
	Longs       LongParamList
	Strings     StringParamList
	TransferFee int64
}

// ItemModifyOutput describes what is modified from item input
type ItemModifyOutput struct {
	ItemInputRef int
	Doubles      DoubleParamList
	Longs        LongParamList
	Strings      StringParamList
	TransferFee  int64
}

// SetTransferFee set generate item's transfer fee
func (mit *ItemModifyOutput) SetTransferFee(transferFee int64) {
	mit.TransferFee = transferFee
}

// GetTransferFee set item's TransferFee
func (mit ItemModifyOutput) GetTransferFee() int64 {
	return mit.TransferFee
}

func (mit ItemModifyOutput) String() string {
	return fmt.Sprintf(`ItemModifyOutput{
		ItemInputRef: %d,
		Doubles: %+v,
		Longs:   %+v,
		Strings: %+v,
		TransferFee: %d,
	}`, mit.ItemInputRef, mit.Doubles, mit.Longs, mit.Strings, mit.TransferFee)
}

// SerializeModifyItemType describes the serialized format of ModifyItemType
type SerializeModifyItemType struct {
	ItemInputRef *int `json:",omitempty"`
	Doubles      DoubleParamList
	Longs        LongParamList
	Strings      StringParamList
	TransferFee  int64
}

// ItemOutput models the continuum of valid outcomes for item generation in recipes
type ItemOutput struct {
	Doubles     DoubleParamList
	Longs       LongParamList
	Strings     StringParamList
	TransferFee int64
}

// SetTransferFee set generate item's transfer fee
func (io *ItemOutput) SetTransferFee(transferFee int64) {
	io.TransferFee = transferFee
}

// GetTransferFee set item's TransferFee
func (io ItemOutput) GetTransferFee() int64 {
	return io.TransferFee
}

// NewItemModifyOutput returns ItemOutput that is modified from item input
func NewItemModifyOutput(ItemInputRef int, ModifyParams ItemModifyParams) ItemModifyOutput {
	return ItemModifyOutput{
		ItemInputRef: ItemInputRef,
		Doubles:      ModifyParams.Doubles,
		Longs:        ModifyParams.Longs,
		Strings:      ModifyParams.Strings,
		TransferFee:  ModifyParams.TransferFee,
	}
}

// NewItemOutput returns new ItemOutput generated from recipe
func NewItemOutput(Doubles DoubleParamList, Longs LongParamList, Strings StringParamList, TransferFee int64) ItemOutput {
	return ItemOutput{
		Doubles:     Doubles,
		Longs:       Longs,
		Strings:     Strings,
		TransferFee: TransferFee,
	}
}

// SerializeItemOutput describes the item output in serialize format
type SerializeItemOutput struct {
	ModifyItem  SerializeModifyItemType
	Doubles     DoubleParamList
	Longs       LongParamList
	Strings     StringParamList
	TransferFee int64
}

func (io ItemOutput) String() string {
	return fmt.Sprintf(`ItemOutput{
		Doubles: %+v,
		Longs:   %+v,
		Strings: %+v,
		TransferFee: %d,
	}`, io.Doubles, io.Longs, io.Strings, io.TransferFee)
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
