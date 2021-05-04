package types

// Validate performs validate genesis
func (gs GenesisState) Validate() error {
	return nil
}

// DefaultGenesis returns default genesis state
func DefaultGenesis() *GenesisState {
	return &GenesisState{
		Cookbooks: []Cookbook{},
		Recipes:   []Recipe{},
		Items:     []Item{},
	}
}
