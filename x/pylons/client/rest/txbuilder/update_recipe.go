package txbuilder

// this module provides the fixtures to build a transaction

import (
	"net/http"

	"github.com/MikeSofaer/pylons/x/pylons/msgs"
	"github.com/MikeSofaer/pylons/x/pylons/types"

	// "github.com/MikeSofaer/pylons/x/pylons/types"
	"github.com/cosmos/cosmos-sdk/client/context"
	"github.com/cosmos/cosmos-sdk/client/utils"
	"github.com/cosmos/cosmos-sdk/codec"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/rest"
	authtxb "github.com/cosmos/cosmos-sdk/x/auth/client/txbuilder"
)

// UpdateRecipeTxBuilder returns the fixtures which can be used to create a create cookbook transaction
func UpdateRecipeTxBuilder(cdc *codec.Codec, cliCtx context.CLIContext, storeName string) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		// vars := mux.Vars(r)
		// requester := vars[TxGPRequesterKey]
		sender, err := sdk.AccAddressFromBech32("cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337")

		txBldr := authtxb.NewTxBuilderFromCLI().WithTxEncoder(utils.GetTxEncoder(cdc))

		msg := msgs.NewMsgUpdateRecipe("recipeName", "name", "id001", "this has to meet character limits lol",
			types.CoinInputList{
				types.CoinInput{
					Coin:  "wood",
					Count: 5,
				},
			},
			types.CoinOutputList{
				types.CoinOutput{
					Coin:  "chair",
					Count: 1,
				},
			},
			types.ItemInputList{
				types.ItemInput{
					types.DoubleInputParamMap{"endurance": types.DoubleInputParam{"0.7", "1"}},
					types.LongInputParamMap{"HP": types.LongInputParam{100, 140}},
					types.StringInputParamMap{"Name": types.StringInputParam{"Raichu"}},
				},
			},
			types.ItemOutputList{
				types.ItemOutput{
					types.DoubleParamMap{"endurance": types.DoubleParam{"0.7", "1", "1"}},
					types.LongParamMap{"HP": types.LongParam{100, 140, "1"}},
					types.StringParamMap{"Name": types.StringParam{"Raichu", "1"}},
				},
			}, sender)

		signMsg, err := txBldr.BuildSignMsg([]sdk.Msg{msg})

		if err != nil {
			rest.WriteErrorResponse(w, http.StatusBadRequest, err.Error())
		}

		rest.PostProcessResponse(w, cdc, signMsg.Bytes(), cliCtx.Indent)
	}
}
