package types

import (
	"errors"
	"regexp"
)

// ValidateVersion validates the SemVer
func ValidateVersion(s string) error {
	regex := regexp.MustCompile(`^([0-9]+)\.([0-9]+)\.([0-9]+)(?:-([0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*))?(?:\+[0-9A-Za-z-]+)?$`)
	if regex.MatchString(s) {
		return nil
	}

	return errors.New("invalid semVer")
}
