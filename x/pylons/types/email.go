package types

import (
	"errors"
	"regexp"
)

// ValidateEmail validates the email string provided
func ValidateEmail(email string) error {
	exp := regexp.MustCompile(`^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z0-9]{2,})$`)
	if exp.MatchString(email) {
		return nil
	}

	return errors.New("invalid email address")
}
