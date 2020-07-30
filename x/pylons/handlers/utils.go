package handlers

import (
	"encoding/json"
	"errors"

	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

func errInternal(err error) error {
	return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
}

func marshalJSON(intf interface{}) (*sdk.Result, error) {
	mData, err := json.Marshal(intf)

	if err != nil {
		return nil, errInternal(err)
	}

	return &sdk.Result{Data: mData}, nil
}

// Contains is a utility function to find an int value from int array
func Contains(arr []int, it int) bool {
	for _, a := range arr {
		if a == it {
			return true
		}
	}
	return false
}

// Max returns the larger of x or y.
func Max(x, y int64) int64 {
	if x < y {
		return y
	}
	return x
}

// Min returns the larger of x or y.
func Min(x, y int64) int64 {
	if x > y {
		return y
	}
	return x
}

// GetItemsFromIDs get items from IDs
func GetItemsFromIDs(ctx sdk.Context, keeper keep.Keeper, itemIDs []string, sender sdk.AccAddress) ([]types.Item, error) {
	var inputItems []types.Item
	keys := make(map[string]bool)

	for _, id := range itemIDs {
		if _, value := keys[id]; !value {
			keys[id] = true

			item, err := keeper.GetItem(ctx, id)
			if err != nil {
				return inputItems, err
			}
			if !item.Sender.Equals(sender) {
				return inputItems, errors.New("item owner is not same as sender")
			}

			inputItems = append(inputItems, item)
		} else {
			return inputItems, errors.New("multiple use of same item as item inputs")
		}
	}
	return inputItems, nil
}
