package types

import (
	"errors"
	"regexp"
)

// Validate validates the email provided
func (e Email) Validate() error {
	exp := regexp.MustCompile(`^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z0-9]{2,})$`)
	if exp.MatchString(e.Str) {
		return nil
	}

	return errors.New("invalid email address")
}
