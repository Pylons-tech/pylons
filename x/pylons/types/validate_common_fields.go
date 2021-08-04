package types

import (
	"regexp"

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
	regex := regexp.MustCompile(`^([0-9]+)\.([0-9]+)\.([0-9]+)(?:-([0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*))?(?:\+[0-9A-Za-z-]+)?$`)
	if regex.MatchString(s) {
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

// ValidateNumber validates numbers
func ValidateNumber(s string) error {
	regex := regexp.MustCompile(`^[0-9]+$`)
	if regex.MatchString(s) {
		return nil
	}

	return sdkerrors.Wrap(ErrInvalidRequestField, "invalid number")
}
