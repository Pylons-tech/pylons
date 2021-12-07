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

	items := []string{msg.LHitem, msg.RHitem, msg.Armoritem, msg.Nft}
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
		Creator:    msg.Creator,
		CookbookID: msg.CookbookID,
		LHitem:     msg.LHitem,
		RHitem:     msg.RHitem,
		Armoritem:  msg.Armoritem,
		NFT:				msg.Nft,
		Status: 		"waiting",
		Log:				"",
		OpponentFighter: 0,
	}

	id := k.AppendFighter(ctx, fighter)
	fighter.ID = id

	// go through all fights and see if there is a worthy opponent
	for oppoID, opponent := range openFights {

		// this ensures that fighters are on the same cookbook and have not fought yet, only fighting against oneself is currently commented out
		if (opponent.CookbookID == msg.CookbookID && opponent.Status == "waiting" && id != uint64(oppoID)	) /* && opponent.Creator != msg.Creator */  {

			fmt.Println("oppoid:", oppoID, "ownid:", id)
			fmt.Println("fighter oppoid:", opponent.ID, "figther own id:", fighter.ID)

			battleWinner, battleLog, err := k.Battle(ctx, fighter, opponent)
			if err != nil {
				return nil, sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, "battle ended with error %v", err.Error)
			}
			if battleWinner == "A" {
				opponent.Status = "loss"
				opponent.Log = battleLog
				opponent.OpponentFighter = id
				fighter.Status = "win"
				fighter.Log = battleLog
				fighter.OpponentFighter = uint64(oppoID)
			} else {
				opponent.Status = "win"
				opponent.Log = battleLog
				opponent.OpponentFighter = id
				fighter.Status = "loss"
				fighter.Log = battleLog
				fighter.OpponentFighter = uint64(oppoID)
			}

			k.SetFighter(ctx, opponent)
			k.SetFighter(ctx, fighter)

			break
		}
	}

	err := ctx.EventManager().EmitTypedEvent(&types.EventCreateFighter{
		ID: id,
		Creator: msg.Creator,
	})

	return &types.MsgEnlistForArenaResponse{ID: id}, err
}
