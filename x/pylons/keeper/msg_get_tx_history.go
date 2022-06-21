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
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	"github.com/cosmos/cosmos-sdk/types/tx"
	authtx "github.com/cosmos/cosmos-sdk/x/auth/tx"
)

func TxHistoryRequestHandler(w http.ResponseWriter, r *http.Request, ctx client.Context) {
	data := r.URL.Query()
	denom := data.Get("denom")
	// format of address 'address' / %27address%27
	address := data.Get("address")
	limit, _ := strconv.ParseInt(data.Get("limit"), 10, 64)
	offset, _ := strconv.ParseInt(data.Get("offset"), 10, 64)

	// setting with default values
	if offset == types.MinVal {
		offset = types.DefaultOffset
	}

	// checking if limit is correct
	if limit == types.MinVal {
		limit = types.DefaultLimit
	}

	validationErr := ValidateRequest(address, limit, offset)
	if validationErr != nil {
		info, _ := json.Marshal(validationErr)
		_, _ = w.Write(info)
		return
	}

	// query for tx history of events on basis of address
	res, err := GetTxHistory(ctx, address, denom, limit, offset)
	if err != nil {
		// incase of error return error
		w.Header().Add(types.HTTPContentTypeKey, types.HTTPContentTypeVal)
		info, _ := json.Marshal(sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, types.GetErrorHistoryMsg))
		_, _ = w.Write(info)
		return
	}
	w.Header().Add(types.HTTPContentTypeKey, types.HTTPContentTypeVal)
	info, _ := json.Marshal(res)
	_, _ = w.Write(info)
}

func GetTxHistory(ctx client.Context, address, denom string, limit, offset int64) ([]*types.History, error) {
	// initializing cosmos sdk service to get query events
	txService := authtx.NewTxServer(ctx, nil, nil)

	// 1. querying cosmos sdk service to get transfer.sender event
	// from this event we get 2 types of TxHistory i.e. SEND and NFTBUY
	history, err := QueryHistoryCosmos(txService, types.TransferSenderEvent+address)
	if err != nil {
		return nil, err
	}
	// helper function to extract specific event information i.e. transfer and create_item
	userHistory := QueryEventSender(history.TxResponses)

	// 2. querying cosmos sdk service to get transfer.recipient event
	// from this event we get 1 types of TxHistory i.e. RECEIVE
	history, err = QueryHistoryCosmos(txService, types.TransferRecipientEvent+address)
	if err != nil {
		return nil, err
	}
	// helper function to extract specific event information i.e. transfer
	// adding records to collection
	userHistory = append(userHistory, QueryEventRecipientBank(history.TxResponses)...)

	// 3. querying cosmos sdk service to get create_item.receiver event
	// from this event we get 1 types of TxHistory i.e. NFTSELL
	history, err = QueryHistoryCosmos(txService, types.CreateItemReceiverEvent+address)
	if err != nil {
		return nil, err
	}
	// helper function to extract specific event information i.e. create_item
	// adding records to collection
	userHistory = append(userHistory, QueryEventNFTSell(history.TxResponses)...)

	// sorting final user history with chronological order
	userHistory = Sort(userHistory)

	// if incoming request is for a specific denomination
	if len(denom) > types.MinVal {
		userHistory = FilterOnDenom(denom, userHistory)
	}

	// calculating limit and offset to return paginated slice of complete tx history
	offset = limit * (offset - 1) // subtracted 1 as indices start at 0, case offset is 1 i.e. first page, where first index is 0
	limit += offset

	// case: if offset if out of bound the return empty response
	if offset > int64(len(userHistory)) {
		return []*types.History{}, nil
	} else if limit > int64(len(userHistory)) { // case if limit is out of bounds the return history from offset to end
		return userHistory[offset:], nil
	}
	// normal case pagination lies between the slices
	return userHistory[offset:limit], nil
}

/*
* Common Function to query tx History from cosmos
 */
func QueryHistoryCosmos(txService tx.ServiceServer, query string) (history *tx.GetTxsEventResponse, err error) {
	history, err = txService.GetTxsEvent(context.Background(), &tx.GetTxsEventRequest{Events: []string{
		query,
	}})
	if err != nil {
		return nil, err
	}
	return history, nil
}

/*
* Event information is contained with in the log entry of the TxResponse
* In log entry events can be further found at log[n].Events
* Hence, we first loop over all the txResponses in the history from cosmos
* Then find our desired event and store it
 */

func QueryEventSender(block []*sdkTypes.TxResponse) (userHistory []*types.History) {
	for _, txRes := range block {
		// getting block time to note the time event occurred
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
			entry, nft = GetBankCreateItemEvent(log.Events, entry, nft)
			// if transfer as sender is found for a bank transfer add it to history
			if entry != nil {
				userHistory = append(userHistory, entry)
			}
			if nft != nil {
				userHistory = append(userHistory, nft)
			}
		}
	}
	// return collected  userHistory
	return userHistory
}

func GetBankCreateItemEvent(events sdkTypes.StringEvents, entry *types.History, nft *types.History) (*types.History, *types.History) {
	for _, e := range events {
		switch e.Type {
		// case transfer event found, i.e. user have sent amount user bank send
		case types.TransferEventKey:
			ExtractBankEvent(e, entry, false)
			// case create_item event found extract amount at which nft is bought
			// its identification id's and owner address
		case types.CreateItemKey:
			entry.Address = ""
			// sending true to extract receiver
			ExtractExecuteRecipeEvent(e, nft, false)
			return nil, nft
			// if creat_item event is found then skip any other event search, break loop
		}
	}
	// if transfer as sender is found for a bank transfer add it to history
	if len(entry.Address) > types.MinVal {
		return entry, nil
	}
	return nil, nil
}

func QueryEventRecipientBank(block []*sdkTypes.TxResponse) (userHistory []*types.History) {
	for _, txRes := range block {
		// getting block time to note the time event occurred
		// parsing date in string to date object
		date, _ := time.Parse(time.RFC3339, txRes.Timestamp)
		// using date to get unix timestamp of the block
		// as we have 1 types from this block, i.e. RECEIVE
		entry := &types.History{
			CreatedAt: date.Unix(),
			Type:      types.TxTypeReceive,
		}
		for _, log := range txRes.Logs {
			entry = GetBankEvent(log.Events, entry)
			if entry != nil {
				userHistory = append(userHistory, entry)
			}
		}
	}
	return userHistory
}

func GetBankEvent(events sdkTypes.StringEvents, entry *types.History) *types.History {
	for _, e := range events {
		// case transfer event is found, i.e. user have received amount from bank send
		// extract amount of transfer and sender address
		if e.Type == types.TransferEventKey {
			// passing true as we need to extract sender's info
			ExtractBankEvent(e, entry, true)
			// add entry to userHistory
			return entry
		}
	}
	return nil
}

func QueryEventNFTSell(block []*sdkTypes.TxResponse) (userHistory []*types.History) {
	for _, txRes := range block {
		// getting block time to note the time event occurred
		// parsing date in string to date object
		date, _ := time.Parse(time.RFC3339, txRes.Timestamp)
		// using date to get unix timestamp of the block
		// as we have 1 types from this block i.e. NFTSELL
		nft := &types.History{
			CreatedAt: date.Unix(),
			Type:      types.TxTypeNFTSell,
		}
		for _, log := range txRes.Logs {
			nft = GetCreateItemEvent(log.Events, nft)
			if nft != nil {
				userHistory = append(userHistory, nft)
			}
		}
	}
	return userHistory
}

func GetCreateItemEvent(events sdkTypes.StringEvents, nft *types.History) *types.History {
	for _, e := range events {
		// case create_item event is found
		if e.Type == types.CreateItemKey {
			// extract amount at which NFT is sold,
			// its identification id's and buyers address
			// sending true to extract recipe executors's info
			ExtractExecuteRecipeEvent(e, nft, true)
			// add to history collection
			return nft
		}
	}
	return nil
}

/*
* sender bool variable will be used to check which address we need to extract
 */

func ExtractBankEvent(e sdkTypes.StringEvent, entry *types.History, sender bool) {
	for _, attr := range e.GetAttributes() {
		switch attr.Key {
		case types.KeyAmount:
			if len(attr.Value) == types.MinVal {
				entry.Amount = types.ValZero
			} else {
				entry.Amount = attr.Value
			}
		case types.KeySender:
			if sender {
				entry.Address = attr.Value
			}
		case types.KeyRecipient:
			if !sender {
				entry.Address = attr.Value
			}
		}
	}
}

func ExtractExecuteRecipeEvent(e sdkTypes.StringEvent, nft *types.History, sender bool) {
	for _, attr := range e.GetAttributes() {
		switch attr.Key {
		case types.KeyAmount:
			if len(attr.Value) == types.MinVal {
				nft.Amount = types.ValZero
			} else {
				nft.Amount = attr.Value
			}
		case types.KeyCookbookID:
			nft.CookbookId = attr.Value
		case types.KeyRecipeID:
			nft.RecipeId = attr.Value
		case types.KeySender:
			if sender {
				nft.Address = attr.Value
			}
		case types.KeyReceiver:
			if !sender {
				nft.Address = attr.Value
			}
		}
	}
}

// helper func validate address
func IsInvalidAddress(address string) bool {
	return len(address) == types.MinVal
}

// helper func validate limit offset values
func IsInvalidNum(val int64) bool {
	return val < types.MinVal
}

// validate all common params i.e. address, limit and offset
func ValidateRequest(address string, limit, offset int64) error {
	if IsInvalidAddress(address) {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, types.AddressNotFound)
	}
	_, err := sdkTypes.AccAddressFromBech32(strings.Trim(address, "'"))
	if err != nil {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, types.AddressInvalid)
	}

	if IsInvalidNum(offset) {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, types.OffsetInvalid)
	}

	if IsInvalidNum(limit) {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, types.LimitInvalid)
	}
	return nil
}

// sorts the userHistory array chronologically
func Sort(userHistory []*types.History) []*types.History {
	sort.Slice(userHistory, func(i, j int) bool {
		return userHistory[i].CreatedAt >= userHistory[j].CreatedAt
	})
	return userHistory
}

// case denom is present it will filter transaction based on that denom
func FilterOnDenom(denom string, userHistory []*types.History) []*types.History {
	his := []*types.History{}
	// filter out the specific denomination from the tx history
	for _, h := range userHistory {
		if strings.Contains(h.Amount, denom) {
			his = append(his, h)
		}
	}
	return his
}
