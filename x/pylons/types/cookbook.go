package types

import (
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	"github.com/rogpeppe/go-internal/semver"
)

// Modified checks if any field of cookbookA except creator (transfer of ownership is always allowed)
// is changed with respect to cookbookB. Valid edits require a higher version
func (cookbookA Cookbook) Modified(cookbookB Cookbook) (bool, error) {
	modified := false
	if cookbookA.Name != cookbookB.Name {
		modified = true
	}

	if cookbookA.Description != cookbookB.Description {
		modified = true
	}

	if cookbookA.Developer != cookbookB.Developer {
		modified = true
	}

	if cookbookA.SupportEmail != cookbookB.SupportEmail {
		modified = true
	}

	if !cookbookA.CostPerBlock.IsEqual(cookbookB.CostPerBlock) {
		modified = true
	}

	if modified {
		if semver.Compare(cookbookA.Version, cookbookB.Version) != -1 {
			return modified, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "version needs to be higher when updating")
		}
	}

	return modified, nil
}