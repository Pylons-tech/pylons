package types

import (
	"errors"
	"regexp"
)

// SemVer is semantic versioning
type SemVer string

func (s SemVer) Validate() error {
	regex := regexp.MustCompile(`^([0-9]+)\.([0-9]+)\.([0-9]+)(?:-([0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*))?(?:\+[0-9A-Za-z-]+)?$`)
	if regex.MatchString(string(s)) {
		return nil
	}

	return errors.New("invalid semVer")
}
