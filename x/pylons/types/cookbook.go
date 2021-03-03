package types

import (
	"fmt"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

// TypeCookbook is a store key for cookbook
const TypeCookbook = "cookbook"

// Cookbook is a struct that contains all the metadata of a cookbook
type Cookbook struct {
	NodeVersion  SemVer
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

// NewCookbook return a new Cookbook
func NewCookbook(sEmail Email, sender sdk.AccAddress, version SemVer, name, description, developer string, cpb int) Cookbook {
	cb := Cookbook{
		NodeVersion:  SemVer{"0.0.1"},
		Name:         name,
		Description:  description,
		Version:      version,
		Developer:    developer,
		SupportEmail: sEmail,
		Sender:       sender,
		CostPerBlock: cpb,
	}

	cb.ID = KeyGen(sender)
	return cb
}

func (cb Cookbook) String() string {
	return fmt.Sprintf(`
	Cookbook{ 
		NodeVersion: %s,
		Name: %s,
		Description: %s,
		Version: %s,
		Developer: %s,
		Level: %d,
		SupportEmail: %s,
		CostPerBlock: %d,
		Sender: %s,
	}`, cb.NodeVersion, cb.Name, cb.Description, cb.Version, cb.Developer, cb.Level, cb.SupportEmail, cb.CostPerBlock, cb.Sender)
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

func CookbookListToGetCookbookResponseList(list []Cookbook) []*GetCookbookResponse {
	var res []*GetCookbookResponse
	for _, cookbook := range list {
		res = append(res, &GetCookbookResponse{
			NodeVersion:  &cookbook.NodeVersion,
			ID:           cookbook.ID,
			Name:         cookbook.Name,
			Description:  cookbook.Description,
			Version:      &cookbook.Version,
			Developer:    cookbook.Developer,
			Level:        &cookbook.Level,
			SupportEmail: &cookbook.SupportEmail,
			CostPerBlock: int64(cookbook.CostPerBlock),
			Sender:       cookbook.Sender.String(),
		})
	}
	return res
}
