package msgs

import (
	"strings"
	"testing"

	"github.com/MikeSofaer/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"
)

func TestMsgCreateCookbookValidateBasic(t *testing.T) {
	sender, _ := sdk.AccAddressFromBech32("cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337")

	cases := map[string]struct {
		name         string
		desc         string
		devel        string
		version      types.SemVer
		sEmail       types.Email
		level        types.Level
		sender       sdk.AccAddress
		desiredError string
		showError    bool
	}{
		"cookbook name length check": {
			name:         "id001",
			desc:         "this has to meet character limits",
			devel:        "SketchyCo",
			version:      "1.0.0",
			sEmail:       "example@example.com",
			level:        0,
			sender:       sender,
			desiredError: "the name of the cookbook should have more than 8 characters",
			showError:    true,
		},
		"invalid address check": {
			name:         "id0000001",
			desc:         "this has to meet character limits",
			devel:        "SketchyCo",
			version:      "1.0.0",
			sEmail:       "example@example.com",
			level:        0,
			sender:       nil,
			desiredError: "invalid address",
			showError:    true,
		},
		"description length check": {
			name:         "id0000001",
			desc:         "",
			devel:        "SketchyCo",
			version:      "1.0.0",
			sEmail:       "example@example.com",
			level:        0,
			sender:       sender,
			desiredError: "the description should have more than 20 characters",
			showError:    true,
		},
		"email validation check": {
			name:         "id0000001",
			desc:         "this has to meet character limits",
			devel:        "SketchyCo",
			version:      "1.0.0",
			sEmail:       "wrong email type",
			level:        0,
			sender:       sender,
			desiredError: "invalid email address",
			showError:    true,
		},
		"level validation check": {
			name:         "id0000001",
			desc:         "this has to meet character limits",
			devel:        "SketchyCo",
			version:      "1.0.0",
			sEmail:       "example@example.com",
			level:        3,
			sender:       sender,
			desiredError: "Invalid cookbook plan",
			showError:    true,
		},
		"version validation check": {
			name:         "id0000001",
			desc:         "this has to meet character limits",
			devel:        "SketchyCo",
			version:      "version1 :)",
			sEmail:       "example@example.com",
			level:        0,
			sender:       sender,
			desiredError: "invalid semVer",
			showError:    true,
		},
		"successful check": {
			name:         "id0000001",
			desc:         "this has to meet character limits",
			devel:        "SketchyCo",
			version:      "1.0.0",
			sEmail:       "example@example.com",
			level:        0,
			sender:       sender,
			desiredError: "",
			showError:    false,
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			msg := NewMsgCreateCookbook(tc.name, tc.desc, tc.devel, tc.version, tc.sEmail, tc.level, tc.sender)
			validation := msg.ValidateBasic()
			if tc.showError == false {
				require.True(t, validation == nil)
			} else {
				require.True(t, validation != nil)
				require.True(t, strings.Contains(validation.Error(), tc.desiredError))
			}
		})
	}
}
