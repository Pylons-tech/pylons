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
	sdkTypes "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/tx"
	authtx "github.com/cosmos/cosmos-sdk/x/auth/tx"
	"google.golang.org/grpc/codes"
)

func TxHistoryRequestHandler(w http.ResponseWriter, r *http.Request, ctx client.Context) {
	data := r.URL.Query()
	denom := data.Get("denom")
	address := data.Get("address")

	// format of address 'address' / %27address%27
	if len(address) == types.MinVal {
		// if address not found return error
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
	// checking is offset is correct if exits
	if offset < types.MinVal {
		// if offset is negative return error
		w.Header().Add(types.HTTPContentTypeKey, types.HTTPContentTypeVal)
		info, _ := json.Marshal(types.StandardError{
			Code:    codes.InvalidArgument.String(),
			Message: types.OffsetInvalid,
		})
		_, _ = w.Write(info)
		return
	} else if offset == types.MinVal {
		offset = types.DefaultOffset // min value of offset is 1
	}

	// checking if limit is correct
	if limit < types.MinVal {
		// if limit is negative return error
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

	// query for tx history of events on basis of address
	res, err := GetTxHistory(ctx, address, denom, limit, offset)
	if err != nil {
		// incase of error return error
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
	// initialiing cosmos sdk service to get query events
	txService := authtx.NewTxServer(ctx, nil, nil)

	// 1. querying cosmos sdk service to get transfer.sender event
	// from this event we get 2 types of TxHistory i.e. SEND and NFTBUY
	history, err := txService.GetTxsEvent(context.Background(), &tx.GetTxsEventRequest{Events: []string{
		types.TransferSenderEvent + address,
	}})
	if err != nil {
		return nil, err
	}
	// helper function to extract specific event information i.e. tranfer and create_item
	userHistory := QueryEventSender(history.TxResponses)

	// 2. querying cosmos sdk service to get transfer.recipient event
	// from this event we get 1 types of TxHistory i.e. RECEIVE
	history, err = txService.GetTxsEvent(context.Background(), &tx.GetTxsEventRequest{Events: []string{
		types.TransferRecipientEvent + address,
	}})
	if err != nil {
		return nil, err
	}
	// helper function to extract specific event information i.e. tranfer
	// adding records to collection
	userHistory = append(userHistory, QueryEventRecipientBank(history.TxResponses)...)

	// 3. querying cosmos sdk service to get create_item.receiver event
	// from this event we get 1 types of TxHistory i.e. NFTSELL
	history, err = txService.GetTxsEvent(context.Background(), &tx.GetTxsEventRequest{Events: []string{
		types.CreateItemReceiverEvent + address,
	}})
	if err != nil {
		return nil, err
	}
	// helper function to extract specific event information i.e. create_item
	// adding records to collection
	userHistory = append(userHistory, QueryEventNFTSell(history.TxResponses)...)

	sort.Slice(userHistory, func(i, j int) bool {
		return userHistory[i].CreatedAt >= userHistory[j].CreatedAt
	})

	// if incoming request is for a specific denomination
	if len(denom) > types.MinVal {
		his := []*types.History{}
		// filter out the specific denomination from the tx history
		for _, h := range userHistory {
			if strings.Contains(h.Amount, denom) {
				his = append(his, h)
			}
		}
		userHistory = his
	}

	// calculating limit and offset to retutrn paginated slice of complete tx history
	offset = limit * (offset - 1) // subtracted 1 as indices start at 0, case offset is 1 i.e. first page, where first index is 0
	limit += offset

	// case: if offset if outof bound the return empty response
	if offset > int64(len(userHistory)) {
		return []*types.History{}, nil
	} else if limit > int64(len(userHistory)) { // case if limit is outof bounds the return history from offset to end
		return userHistory[offset:], nil
	}
	// normal case pagination lies between the slices
	return userHistory[offset:limit], nil
}

/*
* Event information is contained with in the log entry of the TxResponse
* In log entry events can be further found at log[n].Events
* Hence, we first loop over all the txResponses in the history from cosmos
* Then find our desired event and store it
 */

func QueryEventSender(block []*sdkTypes.TxResponse) (userHistory []*types.History) {
	for _, txRes := range block {
		// getting block time to note the time event occcured
		// parsing date in string to date object
		date, _ := time.Parse(time.RFC3339, txRes.Timestamp)
		// using date to get unix timestamp of the block
		// as we have 2 types from this block SEND and NFTBUY
		entry := &types.History{
			CreatedAt: date.Unix(),
			Type:      types.TxTypeSend,
		}
		nft := &types.History{
			CreatedAt: date.Unix(),
			Type:      types.TxTypeNFTBuy,
		}
		for _, log := range txRes.Logs {
		eventFound:
			for _, e := range log.Events {
				switch e.Type {
				// case transfer event found, i.e. user have sent amount user bank send
				case types.TransferEventKey:
					for _, attr := range e.GetAttributes() {
						// extract amount of transfer and the recipient address
						switch attr.Key {
						case types.KeyAmount:
							if len(attr.Value) == types.MinVal {
								entry.Amount = types.ValZero
							} else {
								entry.Amount = attr.Value
							}
						case types.KeyRecipient:
							entry.Address = attr.Value
						}
					}
					// case create_item event found extracyt amount at which nft is bought
					// its identification id's and owner address
				case types.CreateItemKey:
					entry.Address = ""
					for _, attr := range e.GetAttributes() {
						switch attr.Key {
						case types.KeyAmount:
							if len(attr.Value) == types.MinVal {
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
					// if creat_item event is found then skip any other event search, break loop
					break eventFound
				}
				// if transfer as sender is found for a bank transfer add it to history
				if len(entry.Address) > types.MinVal {
					userHistory = append(userHistory, entry)
				}
			}
		}
	}
	// return collected  userHistory
	return userHistory
}

func QueryEventRecipientBank(block []*sdkTypes.TxResponse) (userHistory []*types.History) {
	for _, txRes := range block {
		// getting block time to note the time event occcured
		// parsing date in string to date object
		date, _ := time.Parse(time.RFC3339, txRes.Timestamp)
		// using date to get unix timestamp of the block
		// as we have 1 types from this block, i.e. RECEIVE
		entry := &types.History{
			CreatedAt: date.Unix(),
			Type:      types.TxTypeReceive,
		}
		for _, log := range txRes.Logs {
			for _, e := range log.Events {
				// case transfer event is found, i.e. user have received amount from bank send
				// extract amount of transfer and sender address
				if e.Type == types.TransferEventKey {
					for _, attr := range e.GetAttributes() {
						switch attr.Key {
						case types.KeyAmount:
							if len(attr.Value) == types.MinVal {
								entry.Amount = types.ValZero
							} else {
								entry.Amount = attr.Value
							}
						case types.KeySender:
							entry.Address = attr.Value
						}
					}
					// add entry to userHistroy
					userHistory = append(userHistory, entry)
				}
			}
		}
	}
	return userHistory
}

func QueryEventNFTSell(block []*sdkTypes.TxResponse) (userHistory []*types.History) {
	for _, txRes := range block {
		// getting block time to note the time event occcured
		// parsing date in string to date object
		date, _ := time.Parse(time.RFC3339, txRes.Timestamp)
		// using date to get unix timestamp of the block
		// as we have 1 types from this block i.e. NFTSELL
		nft := &types.History{
			CreatedAt: date.Unix(),
			Type:      types.TxTypeNFTSell,
		}
		for _, log := range txRes.Logs {
			for _, e := range log.Events {
				// case create_item event is found
				if e.Type == types.CreateItemKey {
					// extract amount at which NFT is sold,
					// its identification id's and buyers address
					for _, attr := range e.GetAttributes() {
						switch attr.Key {
						case types.KeyAmount:
							if len(attr.Value) == types.MinVal {
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
					// add to history collection
					userHistory = append(userHistory, nft)
				}
			}
		}
	}
	return userHistory
}
