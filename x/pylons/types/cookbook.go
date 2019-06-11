package types

import (
	"fmt"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/google/uuid"
)

// Cookbook is a struct that contains all the metadata of a cookbook
type Cookbook struct {
	Name         string
	Description  string
	Version      SemVer
	Developer    string
	Level        Level
	SupportEmail Email
	Sender       sdk.AccAddress
}

// Cookbooks is a list of cookbook
type Cookbooks []Cookbook

// NewCookbook return a new Cookbook
func NewCookbook(sEmail Email, sender sdk.AccAddress, version SemVer, name, description, developer string) Cookbook {
	return Cookbook{
		Name:         name,
		Description:  description,
		Version:      version,
		Developer:    developer,
		SupportEmail: sEmail,
		Sender:       sender,
	}
}

// KeyGen generates key for the store
func (cb Cookbook) KeyGen() string {
	id := uuid.New()
	return cb.Sender.String() + id.String()
}

func (cb Cookbook) String() string {
	return fmt.Sprintf(`
	Cookbook{ 
		Name: %s,
		Developer: %s,
		Tier: %d,
		Support Email: %s,
	}`, cb.Name, cb.Developer, int(cb.Level), cb.SupportEmail)
}
