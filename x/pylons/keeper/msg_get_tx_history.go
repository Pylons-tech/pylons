package keeper

import (
	"context"
	"encoding/json"
	"net/http"
	"sort"
	"strconv"
	"time"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/types/tx"
	authtx "github.com/cosmos/cosmos-sdk/x/auth/tx"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

func TxHistoryRequestHandler(w http.ResponseWriter, r *http.Request, ctx client.Context) {
	data := r.URL.Query()
	limit, _ := strconv.ParseInt(data.Get("limit"), 10, 64)
	offset, _ := strconv.ParseInt(data.Get("offset"), 10, 64)
	if offset < types.MinVal {
		err := status.Error(codes.InvalidArgument, "offset must greater than 0")
		w.Header().Add("content-type", "application/json")
		info, _ := json.Marshal(err)
		w.Write(info)
	} else if offset == types.MinVal {
		offset = types.DefaultOffset
	}

	if limit < 0 {
		err := status.Error(codes.InvalidArgument, "limit must greater than 0")
		w.Header().Add("content-type", "application/json")
		info, _ := json.Marshal(err)
		w.Write(info)
	} else if limit == types.MinVal {
		limit = types.DefaultLimit
	}

	res, err := GetTxHistory(ctx, data.Get("address"), limit, offset)
	if err != nil {
		w.Header().Add("content-type", "application/json")
		info, _ := json.Marshal(err)
		w.Write(info)

	} else {
		w.Header().Add("content-type", "application/json")
		info, _ := json.Marshal(res)
		w.Write(info)
	}
}

func GetTxHistory(ctx client.Context, address string, limit, offset int64) ([]*types.History, error) {
	txService := authtx.NewTxServer(ctx, nil, nil)
	history, err := txService.GetTxsEvent(context.Background(), &tx.GetTxsEventRequest{Events: []string{
		types.TransferSenderEvent + address,
	}})
	if err != nil {
		return nil, err
	}
	userHistory := []*types.History{}

	event := history.TxResponses
	for _, txRes := range event {
		date, _ := time.Parse(time.RFC3339, txRes.Timestamp)
		entry := &types.History{
			CreatedAt: date.Unix(),
			Type:      types.TxTypeSend,
		}
		nft := &types.History{
			CreatedAt: date.Unix(),
			Type:      types.TxTypeNFTBuy,
		}
		for _, e := range txRes.Logs[0].Events {
			if e.Type == types.TransferEventKey {
				for _, attr := range e.GetAttributes() {
					if string(attr.Key) == types.KeyAmount {
						if len(string(attr.Value)) == 0 {
							entry.Amount = types.ValZero
						} else {
							entry.Amount = string(attr.Value)
						}
					} else if string(attr.Key) == types.KeyRecipient {
						entry.Address = string(attr.Value)
					}
				}
			} else if e.Type == types.CreateItemKey {
				entry.Address = ""
				for _, attr := range e.GetAttributes() {
					if string(attr.Key) == types.KeyAmount {
						if len(string(attr.Value)) == 0 {
							nft.Amount = types.ValZero
						} else {
							nft.Amount = string(attr.Value)
						}
					} else if string(attr.Key) == types.KeyCookbookId {
						nft.CookbookID = string(attr.Value)
					} else if string(attr.Key) == types.KeyRecipeId {
						nft.RecipeID = string(attr.Value)
					} else if string(attr.Key) == types.KeyReceiver {
						nft.Address = string(attr.Value)
					}
				}
				userHistory = append(userHistory, nft)
				break
			}
			if len(entry.Address) > 0 {
				userHistory = append(userHistory, entry)
			}
		}
	}
	history, err = txService.GetTxsEvent(context.Background(), &tx.GetTxsEventRequest{Events: []string{
		types.TransferRecipientEvent + address,
	}})
	if err != nil {
		return nil, err
	}

	event = history.TxResponses
	for _, txRes := range event {
		date, _ := time.Parse(time.RFC3339, txRes.Timestamp)
		entry := &types.History{
			CreatedAt: date.Unix(),
			Type:      types.TxTypeReceive,
		}
		for _, e := range txRes.Logs[0].Events {
			if e.Type == types.TransferEventKey {
				for _, attr := range e.GetAttributes() {
					if string(attr.Key) == types.KeyAmount {
						if len(string(attr.Value)) == 0 {
							entry.Amount = types.ValZero
						} else {
							entry.Amount = string(attr.Value)
						}
					} else if string(attr.Key) == types.KeySender {
						entry.Address = string(attr.Value)
					}
				}
				userHistory = append(userHistory, entry)
			}
		}
	}
	history, err = txService.GetTxsEvent(context.Background(), &tx.GetTxsEventRequest{Events: []string{
		types.CreateItemReceiverEvent + address,
	}})
	if err != nil {
		return nil, err
	}

	event = history.TxResponses
	for _, txRes := range event {
		date, _ := time.Parse(time.RFC3339, txRes.Timestamp)
		nft := &types.History{
			CreatedAt: date.Unix(),
			Type:      types.TxTypeNFTSell,
		}
		for _, e := range txRes.Logs[0].Events {
			if e.Type == types.CreateItemKey {
				for _, attr := range e.GetAttributes() {
					if string(attr.Key) == types.KeyAmount {
						if len(string(attr.Value)) == 0 {
							nft.Amount = types.ValZero
						} else {
							nft.Amount = string(attr.Value)
						}
					} else if string(attr.Key) == types.KeyCookbookId {
						nft.CookbookID = string(attr.Value)
					} else if string(attr.Key) == types.KeyRecipeId {
						nft.RecipeID = string(attr.Value)
					} else if string(attr.Key) == types.KeySender {
						nft.Address = string(attr.Value)
					}
				}
				userHistory = append(userHistory, nft)
			}
		}
	}

	sort.Slice(userHistory, func(i, j int) bool {
		return userHistory[i].CreatedAt >= userHistory[j].CreatedAt
	})

	offset = limit * (offset - 1)
	limit = limit + offset

	if offset > int64(len(userHistory)) {
		return []*types.History{}, nil
	} else if limit > int64(len(userHistory)) {
		return userHistory[offset:], nil
	}
	return userHistory[offset:limit], nil
}
