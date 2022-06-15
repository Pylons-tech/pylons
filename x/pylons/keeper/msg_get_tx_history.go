package keeper

import (
	"context"
	"encoding/json"
	"net/http"
	"sort"
	"strconv"
	"strings"
	"time"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/types/tx"
	authtx "github.com/cosmos/cosmos-sdk/x/auth/tx"
	"google.golang.org/grpc/codes"
)

func TxHistoryRequestHandler(w http.ResponseWriter, r *http.Request, ctx client.Context) {
	data := r.URL.Query()
	denom := data.Get("denom")
	address := data.Get("address")
	if len(address) != 45 {
		w.Header().Add(types.HTTPContentTypeKey, types.HTTPContentTypeVal)
		info, _ := json.Marshal(types.StandardError{
			Code:    codes.InvalidArgument.String(),
			Message: types.AddressInvalid,
		})
		_, _ = w.Write(info)
		return
	}

	limit, _ := strconv.ParseInt(data.Get("limit"), 10, 64)
	offset, _ := strconv.ParseInt(data.Get("offset"), 10, 64)
	if offset < types.MinVal {
		w.Header().Add(types.HTTPContentTypeKey, types.HTTPContentTypeVal)
		info, _ := json.Marshal(types.StandardError{
			Code:    codes.InvalidArgument.String(),
			Message: types.OffsetInvalid,
		})
		_, _ = w.Write(info)
		return
	} else if offset == types.MinVal {
		offset = types.DefaultOffset
	}

	if limit < 0 {
		w.Header().Add(types.HTTPContentTypeKey, types.HTTPContentTypeVal)
		info, _ := json.Marshal(types.StandardError{
			Code:    codes.InvalidArgument.String(),
			Message: types.LimitInvalid,
		})
		_, _ = w.Write(info)
		return
	} else if limit == types.MinVal {
		limit = types.DefaultLimit
	}

	res, err := GetTxHistory(ctx, address, denom, limit, offset)
	if err != nil {
		w.Header().Add(types.HTTPContentTypeKey, types.HTTPContentTypeVal)
		info, _ := json.Marshal(types.StandardError{
			Code:    types.GetErrorHistoryCode,
			Message: types.GetErrorHistoryMsg,
		})
		_, _ = w.Write(info)
		return
	}
	w.Header().Add(types.HTTPContentTypeKey, types.HTTPContentTypeVal)
	info, _ := json.Marshal(res)
	_, _ = w.Write(info)
}

func GetTxHistory(ctx client.Context, address, denom string, limit, offset int64) ([]*types.History, error) {
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
	eventFound:
		for _, e := range txRes.Logs[0].Events {
			switch e.Type {
			case types.TransferEventKey:
				for _, attr := range e.GetAttributes() {
					switch attr.Key {
					case types.KeyAmount:
						if len(attr.Value) == 0 {
							entry.Amount = types.ValZero
						} else {
							entry.Amount = attr.Value
						}
					case types.KeyRecipient:
						entry.Address = attr.Value
					}
				}
			case types.CreateItemKey:
				entry.Address = ""
				for _, attr := range e.GetAttributes() {
					switch attr.Key {
					case types.KeyAmount:
						if len(attr.Value) == 0 {
							nft.Amount = types.ValZero
						} else {
							nft.Amount = attr.Value
						}
					case types.KeyCookbookID:
						nft.CookbookID = attr.Value
					case types.KeyRecipeID:
						nft.RecipeID = attr.Value
					case types.KeyReceiver:
						nft.Address = attr.Value
					}
				}
				userHistory = append(userHistory, nft)
				break eventFound
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
					switch attr.Key {
					case types.KeyAmount:
						if len(attr.Value) == 0 {
							entry.Amount = types.ValZero
						} else {
							entry.Amount = attr.Value
						}
					case types.KeySender:
						entry.Address = attr.Value
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
			if e.Type == types.TransferEventKey {
				for _, attr := range e.GetAttributes() {
					switch attr.Key {
					case types.KeyAmount:
						if len(attr.Value) == 0 {
							nft.Amount = types.ValZero
						} else {
							nft.Amount = attr.Value
						}
					case types.KeyCookbookID:
						nft.CookbookID = attr.Value
					case types.KeyRecipeID:
						nft.RecipeID = attr.Value
					case types.KeySender:
						nft.Address = attr.Value
					}
				}
				userHistory = append(userHistory, nft)
			}
		}
	}

	sort.Slice(userHistory, func(i, j int) bool {
		return userHistory[i].CreatedAt >= userHistory[j].CreatedAt
	})

	if len(denom) > 0 {
		his := []*types.History{}
		for _, h := range userHistory {
			if strings.Contains(h.Amount, denom) {
				his = append(his, h)
			}
		}
		userHistory = his
	}

	offset = limit * (offset - 1)
	limit += offset

	if offset > int64(len(userHistory)) {
		return []*types.History{}, nil
	} else if limit > int64(len(userHistory)) {
		return userHistory[offset:], nil
	}
	return userHistory[offset:limit], nil
}
