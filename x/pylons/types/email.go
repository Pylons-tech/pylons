package types

import (
	"errors"
	"regexp"
)

// Email is a string type with regex validation
type Email string

// Validate validates the email provided
func (e Email) Validate() error {
	exp := regexp.MustCompile(`^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$`)
	if exp.MatchString(string(e)) {
		return nil
	}

	return errors.New("invalid email address")
}
