package msgs

import (
	"github.com/MikeSofaer/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

type MsgExecuteRecipe struct {
	ID     string
	Sender sdk.AccAddress
	Inputs types.InputList
}
