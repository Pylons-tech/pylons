package keeper

import (
	"context"
	"fmt"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

func (k msgServer) EnlistForArena(goCtx context.Context, msg *types.MsgEnlistForArena) (*types.MsgEnlistForArenaResponse, error) {
	ctx := sdk.UnwrapSDKContext(goCtx)

	//creator_items := make([]types.Item, 0)


	items := []string{msg.LHitem, msg.RHitem, msg.Armoritem}
	// check that each item provided for battle is owned by the combattants
	for _, itemIDstring := range items {
		item, found := k.GetItem(ctx, msg.CookbookID, itemIDstring)
		if !found {
			return nil, sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, "item with id %v and cookbook id %v not found", itemIDstring, msg.CookbookID)
		}
		if item.Owner != msg.Creator {
			return nil, sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, "item with id %v and cookbook id %v not owned", itemIDstring, msg.CookbookID)
		}
	}


	openFights := k.GetAllFighters(ctx)



	var fighter = types.Fighter{
		Creator:     	msg.Creator,
		CookbookID:  	msg.CookbookID,
		LHitem:  			msg.LHitem,
		RHitem: 			msg.RHitem,
		Armoritem: 		msg.Armoritem,
	}

	for _, opponent := range openFights {
		if (opponent.CookbookID == msg.CookbookID /* && opponent.Creator != msg.Creator */) {
			fmt.Println("Fighters matched!", opponent)
			k.Battle(ctx, fighter, opponent)
		}
	}


	id := k.AppendFighter(
		ctx,
		fighter,
	)

	err := ctx.EventManager().EmitTypedEvent(&types.EventCreateFighter{
		Creator: msg.Creator,
		ID:      id,
	})

	return &types.MsgEnlistForArenaResponse{
		ID: id,
		Info: "Blaa",
	}, err
}
