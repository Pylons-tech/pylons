package keeper

import (
	"context"
	"encoding/json"
	"net/http"
	"strconv"

	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/rpc"
	coretypes "github.com/tendermint/tendermint/rpc/core/types"
)

func GetBlockByHeight(w http.ResponseWriter, r *http.Request, ctx client.Context) {
	data := r.URL.Query()

	height, err := strconv.ParseInt(data.Get("height"), 10, 64)
	if err != nil {
		info, _ := json.Marshal(err)
		_, _ = w.Write(info)
		return
	}

	res, err := getBlock(height, ctx)
	if err != nil {
		info, _ := json.Marshal(err)
		_, _ = w.Write(info)
		return
	}
	info, _ := json.Marshal(res)
	_, _ = w.Write(info)
}

func getBlock(height int64, ctx client.Context) (*coretypes.ResultBlock, error) {
	chainHeight, err := rpc.GetChainHeight(ctx)
	if err != nil {
		return nil, err
	}
	if height > chainHeight {
		return nil, err
	}

	// get the node
	node, err := ctx.GetNode()
	if err != nil {
		return nil, err
	}

	// get block at specific height
	res, err := node.Block(context.Background(), &height)
	if err != nil {
		return nil, err
	}
	return res, nil
}
