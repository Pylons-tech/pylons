package queriers

import (
	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	abci "github.com/tendermint/tendermint/abci/types"
)

// query endpoints supported by the nameservice Querier
const (
	KeyListShortenRecipe = "list_shorten_recipe"
)

// ShortenRecipe is a struct to manage shorten recipes
type ShortenRecipe struct {
	ID          string // the recipe guid
	CookbookID  string // the cookbook guid
	Name        string
	Description string
	Sender      sdk.AccAddress
}

// ShortenRecipeList is list of shorten recipes
type ShortenRecipeList struct {
	Recipes []ShortenRecipe
}

// NewShortenRecipe is a constructor for ShortenRecipe
func NewShortenRecipe(ID, cbID, Name, Description string, Sender sdk.AccAddress) ShortenRecipe {
	return ShortenRecipe{
		ID:          ID,
		CookbookID:  cbID,
		Name:        Name,
		Description: Description,
		Sender:      Sender,
	}
}

// ListShortenRecipe returns a recipe based on the recipe id
func ListShortenRecipe(ctx sdk.Context, path []string, req abci.RequestQuery, keeper keep.Keeper) ([]byte, error) {
	if len(path) == 0 {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "no address is provided in path")
	}
	addr := path[0]
	var shortenRecipeList ShortenRecipeList
	var recipes []types.Recipe
	var shortenRecipes []ShortenRecipe
	accAddr, err := sdk.AccAddressFromBech32(addr)

	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	if accAddr.Empty() {
		recipes = keeper.GetRecipes(ctx)
	} else {
		recipes = keeper.GetRecipesBySender(ctx, accAddr)
	}

	for _, rcp := range recipes {
		shortenRecipes = append(shortenRecipes, NewShortenRecipe(
			rcp.ID, rcp.CookbookID, rcp.Description, rcp.Description, rcp.Sender))
	}

	shortenRecipeList = ShortenRecipeList{
		Recipes: shortenRecipes,
	}

	rcpl, err := keeper.Cdc.MarshalJSON(shortenRecipeList)
	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	return rcpl, nil
}
