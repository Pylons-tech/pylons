package msgs

import (
	"github.com/MikeSofaer/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// NewMsgCreateCookbookWithGUID is creating a new MsgCreateCookbook with GUID
func NewMsgCreateCookbookWithGUID(GUID, name, desc, devel string, version types.SemVer, sEmail types.Email, level types.Level, cpb int, sender sdk.AccAddress) MsgCreateCookbook {
	return MsgCreateCookbook{
		ID:           GUID,
		Name:         name,
		Description:  desc,
		Developer:    devel,
		Version:      version,
		SupportEmail: sEmail,
		Level:        level,
		Sender:       sender,
		CostPerBlock: &cpb,
	}
}

// NewMsgCreateRecipe a constructor for CreateRecipe msg
func NewMsgCreateRecipeWithGUID(GUID, recipeName, cookbookID, description string,
	coinInputs types.CoinInputList,
	itemInputs types.ItemInputList,
	entries types.WeightedParamList,
	blockInterval int64,
	sender sdk.AccAddress) MsgCreateRecipe {
	return MsgCreateRecipe{
		ID:            GUID,
		Name:          recipeName,
		CookbookID:    cookbookID,
		Description:   description,
		CoinInputs:    coinInputs,
		ItemInputs:    itemInputs,
		Entries:       entries,
		BlockInterval: int64(blockInterval),
		Sender:        sender,
	}
}

// NewMsgExecuteRecipeWithGUID a constructor for ExecuteCookbook msg with GUID input
func NewMsgExecuteRecipeWithGUID(GUID string, recipeID string, sender sdk.AccAddress, itemIDs []string) MsgExecuteRecipe {
	msg := MsgExecuteRecipe{
		ExecID:   GUID,
		RecipeID: recipeID,
		Sender:   sender,
		ItemIDs:  itemIDs,
	}
	if len(GUID) == 0 {
		msg.ExecID = msg.KeyGen()
	}
	return msg
}

// NewMsgFiatItem a constructor for MsgFiatItem msg
func NewMsgFiatItemWithGUID(GUID string, cookbookID string, doubles []types.DoubleKeyValue, longs []types.LongKeyValue, strings []types.StringKeyValue, sender sdk.AccAddress) MsgFiatItem {
	return MsgFiatItem{
		ID:         GUID,
		CookbookID: cookbookID,
		Doubles:    doubles,
		Longs:      longs,
		Strings:    strings,
		Sender:     sender,
	}
}
