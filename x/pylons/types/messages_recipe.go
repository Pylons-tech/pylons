package types

import (
	"strings"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

var _ sdk.Msg = &MsgCreateRecipe{}
var _ sdk.Msg = &MsgUpdateRecipe{}

func NewMsgCreateRecipe(creator string, cookbookID string, id string, name string, description string, version string, coinInput []CoinInput, itemInput []ItemInput, entries EntriesList, weightedOutputs []WeightedOutputs, blockInterval int64, costPerBlock sdk.Coin, enabled bool, extraInfo string) *MsgCreateRecipe {
	return &MsgCreateRecipe{
		Creator:       creator,
		CookbookID:    cookbookID,
		ID:            id,
		Name:          name,
		Description:   description,
		Version:       version,
		CoinInputs:    coinInput,
		ItemInputs:    itemInput,
		Entries:       entries,
		Outputs:       weightedOutputs,
		BlockInterval: blockInterval,
		CostPerBlock:  costPerBlock,
		Enabled:       enabled,
		ExtraInfo:     extraInfo,
	}
}

func (msg *MsgCreateRecipe) Route() string {
	return RouterKey
}

func (msg *MsgCreateRecipe) Type() string {
	return "CreateRecipe"
}

func (msg *MsgCreateRecipe) GetSigners() []sdk.AccAddress {
	creator, err := sdk.AccAddressFromBech32(msg.Creator)
	if err != nil {
		panic(err)
	}
	return []sdk.AccAddress{creator}
}

func (msg *MsgCreateRecipe) GetSignBytes() []byte {
	bz := ModuleCdc.MustMarshalJSON(msg)
	return sdk.MustSortJSON(bz)
}

func (msg *MsgCreateRecipe) ValidateBasic() error {
	_, err := sdk.AccAddressFromBech32(msg.Creator)
	if err != nil {
		return sdkerrors.Wrapf(sdkerrors.ErrInvalidAddress, "invalid creator address (%s)", err)
	}

	// check length of the name and description fields
	if err = ValidateFieldLength(msg.Name, DefaultMinFieldLength, DefaultMaxFieldLength); err != nil {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	if err = ValidateFieldLength(msg.Description, DefaultMinFieldLength, DefaultMaxFieldLength); err != nil {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	if err = ValidateID(msg.CookbookID); err != nil {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	if err = ValidateID(msg.ID); err != nil {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	if err = ValidateVersion(msg.Version); err != nil {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	if !msg.CostPerBlock.IsValid() {
		return sdkerrors.ErrInvalidCoins
	}

	if msg.BlockInterval < 0 {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "cannot provide negative blockInterval")
	}

	for i, coinInputs := range msg.CoinInputs {
		coins := coinInputs.Coins
		if !coins.Empty() {
			// Validate sdk coins
			if !coins.IsValid() {
				return sdkerrors.Wrapf(sdkerrors.ErrInvalidCoins, "invalid coinInputs at index %d", i)
			}

			if !coins.IsAllPositive() {
				return sdkerrors.Wrapf(sdkerrors.ErrInvalidCoins, "invalid coinInputs at index %d", i)
			}

			for _, coin := range coins {
				if IsCookbookDenom(coin.Denom) {
					split := strings.Split(coin.Denom, denomDivider)
					if split[0] != msg.CookbookID {
						return sdkerrors.Wrapf(sdkerrors.ErrInvalidCoins, "cookbookDenom %s must be from the recipe-owning cookbook ID %s", coin.Denom, msg.CookbookID)
					}

					if IsIBCDenomRepresentation(coin.Denom) {
						return sdkerrors.Wrapf(sdkerrors.ErrInvalidCoins, "cookbookDenom %s is of same form as ibc/{hash}", coin.Denom)
					}
				}
			}
		}
	}

	for _, ii := range msg.ItemInputs {
		if err = ValidateItemInput(ii); err != nil {
			return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
		}
	}

	idMap := make(map[string]bool)
	if err = ValidateEntriesList(msg.Entries, idMap); err != nil {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	sum := uint64(0)
	for _, o := range msg.Outputs {
		if err = ValidateOutputs(o, idMap); err != nil {
			return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
		}
		sum += o.Weight
	}

	entriesLen := 0
	if msg.Entries.CoinOutputs != nil {
		entriesLen += len(msg.Entries.CoinOutputs)
	}

	if msg.Entries.ItemOutputs != nil {
		entriesLen += len(msg.Entries.ItemOutputs)

	}

	if msg.Entries.ItemModifyOutputs != nil {
		entriesLen += len(msg.Entries.ItemModifyOutputs)

	}

	if sum <= 0 && entriesLen > 0 {
		return sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, "weights in weightedOutputs add up to %v, should be nonzero", sum)
	}

	// check if denoms are valid in coinOutputs
	// 3 types
	// global local denoms "denom"  INVALID
	// cookbook denoms "cookbookID/denom" VALID if cookbookID == msg.cookbookID
	// external ibc denoms "ibc/{hash}" INVALID
	msg.Entries.CoinOutputs, err = CreateValidCoinOutputsList(msg.CookbookID, msg.Entries.CoinOutputs)
	if err != nil {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "unable to build valid coin outputs list")
	}

	return nil
}

func NewMsgUpdateRecipe(creator string, cookbookID string, id string, name string, description string, version string, coinInput []CoinInput, itemInput []ItemInput, entries EntriesList, weightedOutputs []WeightedOutputs, blockInterval int64, costPerBlock sdk.Coin, enabled bool, extraInfo string) *MsgUpdateRecipe {
	return &MsgUpdateRecipe{
		Creator:       creator,
		CookbookID:    cookbookID,
		ID:            id,
		Name:          name,
		Description:   description,
		Version:       version,
		CoinInputs:    coinInput,
		ItemInputs:    itemInput,
		Entries:       entries,
		Outputs:       weightedOutputs,
		BlockInterval: blockInterval,
		CostPerBlock:  costPerBlock,
		Enabled:       enabled,
		ExtraInfo:     extraInfo,
	}
}

func (msg *MsgUpdateRecipe) Route() string {
	return RouterKey
}

func (msg *MsgUpdateRecipe) Type() string {
	return "UpdateRecipe"
}

func (msg *MsgUpdateRecipe) GetSigners() []sdk.AccAddress {
	creator, err := sdk.AccAddressFromBech32(msg.Creator)
	if err != nil {
		panic(err)
	}
	return []sdk.AccAddress{creator}
}

func (msg *MsgUpdateRecipe) GetSignBytes() []byte {
	bz := ModuleCdc.MustMarshalJSON(msg)
	return sdk.MustSortJSON(bz)
}

func (msg *MsgUpdateRecipe) ValidateBasic() error {
	_, err := sdk.AccAddressFromBech32(msg.Creator)
	if err != nil {
		return sdkerrors.Wrapf(sdkerrors.ErrInvalidAddress, "invalid creator address (%s)", err)
	}

	// check length of the name and description fields
	if err = ValidateFieldLength(msg.Name, DefaultMinFieldLength, DefaultMaxFieldLength); err != nil {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	if err = ValidateFieldLength(msg.Description, DefaultMinFieldLength, DefaultMaxFieldLength); err != nil {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	if err = ValidateID(msg.CookbookID); err != nil {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	if err = ValidateID(msg.ID); err != nil {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	if err = ValidateVersion(msg.Version); err != nil {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	if !msg.CostPerBlock.IsValid() {
		return sdkerrors.ErrInvalidCoins
	}

	if msg.BlockInterval < 0 {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "cannot provide negative blockInterval")
	}

	for i, coinInputs := range msg.CoinInputs {
		coins := coinInputs.Coins
		if !coins.Empty() {
			// Validate sdk coins
			if !coins.IsValid() {
				return sdkerrors.Wrapf(sdkerrors.ErrInvalidCoins, "invalid coinInputs at index %d", i)
			}

			if !coins.IsAllPositive() {
				return sdkerrors.Wrapf(sdkerrors.ErrInvalidCoins, "invalid coinInputs at index %d", i)
			}

			for _, coin := range coins {
				if IsCookbookDenom(coin.Denom) {
					split := strings.Split(coin.Denom, denomDivider)
					if split[0] != msg.CookbookID {
						return sdkerrors.Wrapf(sdkerrors.ErrInvalidCoins, "cookbookDenom %s must be from the recipe-owning cookbook ID %s", coin.Denom, msg.CookbookID)
					}

					if IsIBCDenomRepresentation(coin.Denom) {
						return sdkerrors.Wrapf(sdkerrors.ErrInvalidCoins, "cookbookDenom %s is of same form as ibc/{hash}", coin.Denom)
					}
				}
			}
		}
	}

	for _, ii := range msg.ItemInputs {
		if err = ValidateItemInput(ii); err != nil {
			return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
		}
	}

	idMap := make(map[string]bool)
	if err = ValidateEntriesList(msg.Entries, idMap); err != nil {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	sum := uint64(0)
	for _, o := range msg.Outputs {
		if err = ValidateOutputs(o, idMap); err != nil {
			return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
		}
		sum += o.Weight
	}

	entriesLen := 0
	if msg.Entries.CoinOutputs != nil {
		entriesLen += len(msg.Entries.CoinOutputs)
	}

	if msg.Entries.ItemOutputs != nil {
		entriesLen += len(msg.Entries.ItemOutputs)

	}

	if msg.Entries.ItemModifyOutputs != nil {
		entriesLen += len(msg.Entries.ItemModifyOutputs)

	}

	if sum <= 0 && entriesLen > 0 {
		return sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, "weights in weightedOutputs add up to %v, should be nonzero", sum)
	}

	// check if denoms are valid in coinOutputs
	// 3 types
	// global local denoms "denom"  INVALID
	// cookbook denoms "cookbookID/denom" VALID if cookbookID == msg.cookbookID
	// external ibc denoms "ibc/{hash}" INVALID
	msg.Entries.CoinOutputs, err = CreateValidCoinOutputsList(msg.CookbookID, msg.Entries.CoinOutputs)
	if err != nil {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "unable to build valid coin outputs list")
	}

	return nil
}
