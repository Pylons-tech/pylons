package types

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// TypeCookbook is a store key for cookbook
const TypeCookbook = "cookbook"

// NewCookbook return a new Cookbook
func NewCookbook(sEmail string, sender sdk.AccAddress, version, name, description, developer string, cpb int64) Cookbook {
	cb := Cookbook{
		NodeVersion:  "0.0.1",
		Name:         name,
		Description:  description,
		Version:      version,
		Developer:    developer,
		SupportEmail: sEmail,
		Sender:       sender.String(),
		CostPerBlock: cpb,
	}

	cb.ID = KeyGen(sender)
	return cb
}
