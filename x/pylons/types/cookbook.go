package types

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// Cookbook is a struct that contains all the metadata of a cookbook
type Cookbook struct {
	Name         string
	Description  string
	Version      string
	Developer    string
	Level        Level
	SupportEmail Email
	Sender       sdk.AccAddress
}

// NewCookbook return a new Cookbook
func NewCookbook(sEmail Email, sender sdk.AccAddress, name, description, version, developer string) Cookbook {
	return Cookbook{
		Name:         name,
		Description:  description,
		Version:      version,
		Developer:    developer,
		SupportEmail: sEmail,
		Sender:       sender,
	}
}
