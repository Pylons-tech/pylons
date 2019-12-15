package types

import (
	"fmt"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/google/uuid"
)

const TypeCookbook = "cookbook"

// Cookbook is a struct that contains all the metadata of a cookbook
type Cookbook struct {
	ID           string // the cookbook guid
	Name         string
	Description  string
	Version      SemVer
	Developer    string
	Level        Level
	SupportEmail Email
	CostPerBlock int `json:",omitempty"`
	Sender       sdk.AccAddress
}

// CookbookList is a list of cookbook
type CookbookList struct {
	Cookbooks []Cookbook
}

func (cbl CookbookList) String() string {
	output := "CookbookList{"
	for _, cb := range cbl.Cookbooks {
		output += cb.String()
		output += ",\n"
	}
	output += "}"
	return output
}

// NewCookbook return a new Cookbook
func NewCookbook(sEmail Email, sender sdk.AccAddress, version SemVer, name, description, developer string, cpb int) Cookbook {
	cb := Cookbook{
		Name:         name,
		Description:  description,
		Version:      version,
		Developer:    developer,
		SupportEmail: sEmail,
		Sender:       sender,
		CostPerBlock: cpb,
	}

	cb.ID = cb.KeyGen()
	return cb
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
		Description: %s,
		Version: %s,
		Developer: %s,
		Level: %d,
		SupportEmail: %s,
		CostPerBlock: %d,
		Sender: %s,
	}`, cb.Name, cb.Description, cb.Version, cb.Developer, cb.Level, cb.SupportEmail, cb.CostPerBlock, cb.Sender)
}
