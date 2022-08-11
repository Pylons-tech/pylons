package keeper

import (
	"github.com/cosmos/cosmos-sdk/store/prefix"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	"github.com/cosmos/cosmos-sdk/types/query"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

// SetRecipe set a specific recipe in the store from its ID
func (k Keeper) SetRecipe(ctx sdk.Context, recipe types.Recipe) {
	recipesStore := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.RecipeKey))
	cookbookRecipesStore := prefix.NewStore(recipesStore, types.KeyPrefix(recipe.CookbookId))
	b := k.cdc.MustMarshal(&recipe)
	cookbookRecipesStore.Set(types.KeyPrefix(recipe.Id), b)

	// required for random seed init given how it's handled rn
	k.IncrementEntityCount(ctx)
}

// GetRecipe returns a recipe from its ID
func (k Keeper) GetRecipe(ctx sdk.Context, cookbookID, id string) (val types.Recipe, found bool) {
	recipesStore := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.RecipeKey))
	cookbookRecipesStore := prefix.NewStore(recipesStore, types.KeyPrefix(cookbookID))

	b := cookbookRecipesStore.Get(types.KeyPrefix(id))
	if b == nil {
		return val, false
	}

	k.cdc.MustUnmarshal(b, &val)
	return val, true
}

// GetAllRecipe returns all recipe
func (k Keeper) GetAllRecipe(ctx sdk.Context) (list []types.Recipe) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.RecipeKey))
	iterator := sdk.KVStorePrefixIterator(store, []byte{})

	defer iterator.Close()

	for ; iterator.Valid(); iterator.Next() {
		var val types.Recipe
		k.cdc.MustUnmarshal(iterator.Value(), &val)
		list = append(list, val)
	}

	return
}

// GetAllRecipesByCookbook returns all recipes owned by cookbook
func (k Keeper) GetAllRecipesByCookbook(ctx sdk.Context, cookbookID string) (list []types.Recipe) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.RecipeKey))
	iterator := sdk.KVStorePrefixIterator(store, types.KeyPrefix(cookbookID))

	defer iterator.Close()

	for ; iterator.Valid(); iterator.Next() {
		var val types.Recipe
		k.cdc.MustUnmarshal(iterator.Value(), &val)
		list = append(list, val)
	}

	return
}

func (k Keeper) getRecipesByCookbookPaginated(ctx sdk.Context, cookbookID string, pagination *query.PageRequest) ([]types.Recipe, *query.PageResponse, error) {
	recipes := make([]types.Recipe, 0)

	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.RecipeKey))
	store = prefix.NewStore(store, types.KeyPrefix(cookbookID))

	pageRes, err := query.Paginate(store, pagination, func(_, value []byte) error {
		var val types.Recipe
		k.cdc.MustUnmarshal(value, &val)
		recipes = append(recipes, val)
		return nil
	})
	if err != nil {
		return nil, nil, err
	}

	return recipes, pageRes, nil
}

// GetCoinsInputsByIndex will return coins that are provided in recipe at index
func (k Keeper) GetCoinsInputsByIndex(ctx sdk.Context, recipe types.Recipe, coinInputsIndex int) (sdk.Coins, error) {
	var coinInputs sdk.Coins
	switch {
	case len(recipe.CoinInputs) == 0:
		coinInputs = sdk.NewCoins(sdk.NewCoin(types.PylonsCoinDenom, sdk.ZeroInt()))
	case coinInputsIndex >= len(recipe.CoinInputs) && len(recipe.CoinInputs) != 0:
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "invalid coinInputs index")
	default:
		coinInputs = recipe.CoinInputs[coinInputsIndex].Coins
	}

	return coinInputs, nil
}

// UpdateCoinsDenom returns updated coins denom
// We will not update Denom if user have enough coin
// We will update Denom if user did not have enough coin but
// User have enough IBC coin
func (k Keeper) UpdateCoinsDenom(ctx sdk.Context, addr sdk.AccAddress, coinInputs sdk.Coins) (sdk.Coins, error) {
	for i, coin := range coinInputs {

		isEnough := k.HasEnoughBalance(ctx, addr, coin)
		if !isEnough {

			isIBCDenomEnough := k.HasEnoughIBCDenomBalance(ctx, addr, coin)

			if isIBCDenomEnough {

				denomTrace, _ := k.GetDenomTrace(ctx, coin)
				coin.Denom = denomTrace.IBCDenom()
				coinInputs[i] = coin
			}
		}
	}

	return coinInputs, nil
}
