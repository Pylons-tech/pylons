package types

import (
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	"github.com/rogpeppe/go-internal/semver"
)

// CookbookModified checks if any field of cookbookA except creator (transfer of ownership is always allowed)
// is changed with respect to cookbookB. Valid edits require a higher version
func CookbookModified(original, updated Cookbook) (bool, error) {
	modified := false

	if original.Name != updated.Name {
		modified = true
	}

	if original.Description != updated.Description {
		modified = true
	}

	if original.Developer != updated.Developer {
		modified = true
	}

	if original.SupportEmail != updated.SupportEmail {
		modified = true
	}

	if original.CostPerBlock.Denom != updated.CostPerBlock.Denom {
		modified = true
	} else if original.CostPerBlock.IsEqual(updated.CostPerBlock) {
		modified = true
	}

	if original.Enabled != updated.Enabled {
		modified = true
	}

	if modified {
		comp := semver.Compare(original.Version, updated.Version)
		if comp != -1 {
			return modified, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "version needs to be higher when updating")
		}
	}
	return modified, nil
}
