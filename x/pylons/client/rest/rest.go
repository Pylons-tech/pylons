package rest

import (
	"fmt"
	"net/http"

	"github.com/cosmos/cosmos-sdk/client/context"
	clientrest "github.com/cosmos/cosmos-sdk/client/rest"
	"github.com/cosmos/cosmos-sdk/codec"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/rest"

	"github.com/MikeSofaer/pylons/x/pylons/types"

	"github.com/MikeSofaer/pylons/x/pylons/msgs"

	"github.com/gorilla/mux"
)

const (
	restName = "pylons"

	// DefaultCoinPerRequest is the number of coins the faucet sends per req
	DefaultCoinPerRequest = 500
)

// RegisterRoutes adds routes
func RegisterRoutes(cliCtx context.CLIContext, r *mux.Router, cdc *codec.Codec, storeName string) {
	r.HandleFunc(fmt.Sprintf("/%s/get_pylons", storeName), getPylonsHandler(cdc, cliCtx)).Methods("POST")
	r.HandleFunc(fmt.Sprintf("/%s/balance", storeName), pylonsBalanceHandler(cdc, cliCtx)).Methods("GET")
	r.HandleFunc(fmt.Sprintf("/%s/send_pylons", storeName), pylonsSendHandler(cdc, cliCtx)).Methods("POST")
}

type getPylonsReq struct {
	BaseReq   rest.BaseReq `json:"base_req"`
	Requester string       `json:"requester"`
}

func getPylonsHandler(cdc *codec.Codec, cliCtx context.CLIContext) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		var req getPylonsReq

		if !rest.ReadRESTReq(w, r, cdc, &req) {
			rest.WriteErrorResponse(w, http.StatusBadRequest, "failed to parse request")
			return
		}

		baseReq := req.BaseReq.Sanitize()
		if !baseReq.ValidateBasic(w) {
			return
		}

		addr, err := sdk.AccAddressFromBech32(req.Requester)
		if err != nil {
			rest.WriteErrorResponse(w, http.StatusBadRequest, err.Error())
			return
		}

		// create the message
		msg := msgs.NewMsgGetPylons(types.NewPylon(DefaultCoinPerRequest), addr)
		err = msg.ValidateBasic()
		if err != nil {
			rest.WriteErrorResponse(w, http.StatusBadRequest, err.Error())
			return
		}
		clientrest.WriteGenerateStdTxResponse(w, cdc, cliCtx, baseReq, []sdk.Msg{msg})
	}
}

type pylonsBalanceReq struct {
	BaseReq   rest.BaseReq `json:"base_req"`
	Requester string       `json:"requester"`
}

func pylonsBalanceHandler(cdc *codec.Codec, cliCtx context.CLIContext) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		var req getPylonsReq

		if !rest.ReadRESTReq(w, r, cdc, &req) {
			rest.WriteErrorResponse(w, http.StatusBadRequest, "failed to parse request")
			return
		}

		baseReq := req.BaseReq.Sanitize()
		if !baseReq.ValidateBasic(w) {
			return
		}

		addr, err := sdk.AccAddressFromBech32(req.Requester)
		if err != nil {
			rest.WriteErrorResponse(w, http.StatusBadRequest, err.Error())
			return
		}

		// create the message
		msg := msgs.NewMsgGetPylons(types.NewPylon(DefaultCoinPerRequest), addr)
		err = msg.ValidateBasic()
		if err != nil {
			rest.WriteErrorResponse(w, http.StatusBadRequest, err.Error())
			return
		}
		clientrest.WriteGenerateStdTxResponse(w, cdc, cliCtx, baseReq, []sdk.Msg{msg})
	}
}

type sendPylonsReq struct {
	BaseReq  rest.BaseReq `json:"base_req"`
	Sender   string       `json:"sender"`
	Receiver string       `json:"receiver"`
	Amount   int64        `json:"amount"`
}

func pylonsSendHandler(cdc *codec.Codec, cliCtx context.CLIContext) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		var req sendPylonsReq

		if !rest.ReadRESTReq(w, r, cdc, &req) {
			rest.WriteErrorResponse(w, http.StatusBadRequest, "failed to parse request")
			return
		}

		baseReq := req.BaseReq.Sanitize()
		if !baseReq.ValidateBasic(w) {
			return
		}

		senderAddr, err := sdk.AccAddressFromBech32(req.Sender)
		if err != nil {
			rest.WriteErrorResponse(w, http.StatusBadRequest, err.Error())
			return
		}

		receiverAddr, err := sdk.AccAddressFromBech32(req.Receiver)
		if err != nil {
			rest.WriteErrorResponse(w, http.StatusBadRequest, err.Error())
			return
		}

		msg := msgs.NewMsgSendPylons(types.NewPylon(int64(req.Amount)), senderAddr, receiverAddr)
		err = msg.ValidateBasic()
		if err != nil {
			rest.WriteErrorResponse(w, http.StatusBadRequest, err.Error())
			return
		}
		clientrest.WriteGenerateStdTxResponse(w, cdc, cliCtx, baseReq, []sdk.Msg{msg})

	}
}
