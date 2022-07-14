package types

import (
	"regexp"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"

	"github.com/rogpeppe/go-internal/semver"
)

// ValidateFieldLength checks if a string field is within minLength and maxLength
func ValidateFieldLength(field string, minLength, maxLength int) error {
	if len(field) < minLength || len(field) > maxLength {
		return sdkerrors.Wrapf(ErrInvalidRequestField, "invalid field length for field %v.  Must be in range [%v, %v]", field, minLength, maxLength)
	}
	return nil
}

// Special Characters Exclusion exception '-' & '_'
func ValidatedDenom(denom string) bool {
	nameRegex := regexp.MustCompile(`^([a-zA-Z0-9_-])$`)
	return nameRegex.MatchString(denom)
}

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

// ValidateItemID validates an ItemID
func ValidateItemID(s string) error {
	decode := DecodeItemID(s)
	if EncodeItemID(decode) != s {
		return sdkerrors.Wrap(ErrInvalidRequestField, "invalid itemID")
	}

	return nil
}

// ValidatePaymentInfo validates a payment receipt
func ValidatePaymentInfo(p PaymentInfo) error {
	_, err := sdk.AccAddressFromBech32(p.PayerAddr)
	if err != nil {
		return sdkerrors.Wrap(ErrInvalidRequestField, "invalid address in payment info")
	}

	if !p.Amount.IsPositive() {
		return sdkerrors.Wrap(ErrInvalidRequestField, "invalid amount in payment info")
	}

	if p.ProcessorName == "" {
		return sdkerrors.Wrap(ErrInvalidRequestField, "empty payment processor name in payment info")
	}

	if p.PurchaseId == "" {
		return sdkerrors.Wrap(ErrInvalidRequestField, "empty purchase ID in payment info")
	}

	if p.ProductId == "" {
		return sdkerrors.Wrap(ErrInvalidRequestField, "empty product ID in payment info")
	}

	if p.Signature == "" {
		return sdkerrors.Wrap(ErrInvalidRequestField, "empty signature in payment info")
	}

	return nil
}

// ValidateRedeemInfo validates a redeem receipt
func ValidateRedeemInfo(r RedeemInfo) error {
	_, err := sdk.AccAddressFromBech32(r.Address)
	if err != nil {
		return sdkerrors.Wrap(ErrInvalidRequestField, "invalid address in redeem info")
	}

	if !r.Amount.IsPositive() {
		return sdkerrors.Wrap(ErrInvalidRequestField, "invalid amount in redeem info")
	}

	if r.ProcessorName == "" {
		return sdkerrors.Wrap(ErrInvalidRequestField, "empty payment processor name in redeem info")
	}

	if r.Id == "" {
		return sdkerrors.Wrap(ErrInvalidRequestField, "empty purchase ID in redeem info")
	}

	if r.Signature == "" {
		return sdkerrors.Wrap(ErrInvalidRequestField, "empty signature in payment info")
	}

	return nil
}
