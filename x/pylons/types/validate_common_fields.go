package types

import (
	"regexp"

	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/rogpeppe/go-internal/semver"

	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// ValidateEmail validates the email string provided
func ValidateEmail(email string) error {
	exp := regexp.MustCompile(`^([a-zA-Z0-9_\-.]+)@([a-zA-Z0-9_\-.]+)\.([a-zA-Z0-9]{2,})$`)
	if exp.MatchString(email) {
		return nil
	}

	return sdkerrors.Wrap(ErrInvalidRequestField, "invalid email address")
}

// ValidateVersion validates the SemVer
func ValidateVersion(s string) error {
	if semver.IsValid(s) {
		return nil
	}

	return sdkerrors.Wrap(ErrInvalidRequestField, "invalid semVer")
}

// ValidateID validates IDs
// A valid ID follows the same rules as variable names in a programming language
func ValidateID(s string) error {
	regex := regexp.MustCompile(`^[a-zA-Z_][a-zA-Z_0-9]*$`)
	if regex.MatchString(s) {
		return nil
	}

	return sdkerrors.Wrap(ErrInvalidRequestField, "invalid ID")
}

// ValidateUsername validates Usernames
// A valid username follows:
// 		Usernames can consist of lowercase and capitals
//		Usernames can consist of alphanumeric characters
//		Usernames can consist of underscore and hyphens and spaces
//		Cannot be two underscores, two hypens or two spaces in a row
//		Cannot have a underscore, hypen or space at the start or end
//		Cannot be a valid cosmos SDK address
func ValidateUsername(s string) error {
	regex := regexp.MustCompile(`^[A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$`)
	if regex.MatchString(s) {
		_, err := sdk.AccAddressFromBech32(s) // if valid SDK address, return error
		if err == nil {
			return sdkerrors.Wrap(ErrInvalidRequestField, "invalid username")
		}

		return nil
	}

	return sdkerrors.Wrap(ErrInvalidRequestField, "invalid username")
}

// ValidateNumber validates numbers
func ValidateNumber(s string) error {
	regex := regexp.MustCompile(`^[0-9]+$`)
	if regex.MatchString(s) {
		return nil
	}

	return sdkerrors.Wrap(ErrInvalidRequestField, "invalid number")
}

// ValidateItemID validates an ItemID
func ValidateItemID(s string) error {
	decode := DecodeItemID(s)
	if EncodeItemID(decode) != s {
		return sdkerrors.Wrap(ErrInvalidRequestField, "invalid itemID")
	}

	return nil
}
