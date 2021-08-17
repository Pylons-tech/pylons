package types

import (
	"testing"

	"github.com/stretchr/testify/require"
)

func TestValidateEmail(t *testing.T) {
	for _, tc := range []struct {
		desc  string
		email string
		err   error
	}{
		{desc: "ValidEmail", email: "test@email.valid"},
		{desc: "InvalidEmail1", email: "inv alid@test.email", err: ErrInvalidRequestField},
		{desc: "InvalidEmail2", email: "xyz", err: ErrInvalidRequestField},
		{desc: "InvalidEmail3", email: "inv&alid@test.email", err: ErrInvalidRequestField},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			err := ValidateEmail(tc.email)
			if tc.err != nil {
				require.ErrorIs(t, err, tc.err)
			} else {
				require.NoError(t, err)
			}
		})
	}
}

func TestValidateVersion(t *testing.T) {
	for _, tc := range []struct {
		desc    string
		version string
		err     error
	}{
		{desc: "ValidVersion", version: "v1.0.0"},
		{desc: "ValidVersion1", version: "v0.1.0-alpha"},
		{desc: "InvalidVersion1", version: "xyz", err: ErrInvalidRequestField},
		{desc: "InvalidVersion2", version: "1.0", err: ErrInvalidRequestField},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			err := ValidateVersion(tc.version)
			if tc.err != nil {
				require.ErrorIs(t, err, tc.err)
			} else {
				require.NoError(t, err)
			}
		})
	}
}

func TestValidateID(t *testing.T) {
	for _, tc := range []struct {
		desc string
		id   string
		err  error
	}{
		{desc: "ValidID", id: "test"},
		{desc: "ValidID1", id: "_test123test"},
		{desc: "InvalidID1", id: "1test", err: ErrInvalidRequestField},
		{desc: "InvalidID2", id: "test id", err: ErrInvalidRequestField},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			err := ValidateID(tc.id)
			if tc.err != nil {
				require.ErrorIs(t, err, tc.err)
			} else {
				require.NoError(t, err)
			}
		})
	}
}

func TestValidateNumber(t *testing.T) {
	for _, tc := range []struct {
		desc string
		id   string
		err  error
	}{
		{desc: "ValidNum", id: "0"},
		{desc: "ValidNum1", id: "42"},
		{desc: "InvalidNum1", id: "_1", err: ErrInvalidRequestField},
		{desc: "InvalidNum2", id: "", err: ErrInvalidRequestField},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			err := ValidateNumber(tc.id)
			if tc.err != nil {
				require.ErrorIs(t, err, tc.err)
			} else {
				require.NoError(t, err)
			}
		})
	}
}
