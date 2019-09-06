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

// CreateRecipeTxBuilder returns the fixtures which can be used to create a create cookbook transaction
func CreateRecipeTxBuilder(cdc *codec.Codec, cliCtx context.CLIContext, storeName string) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		// vars := mux.Vars(r)
		// requester := vars[TxGPRequesterKey]
		sender, err := sdk.AccAddressFromBech32("cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337")

		txBldr := authtxb.NewTxBuilderFromCLI().WithTxEncoder(utils.GetTxEncoder(cdc))

		msg := msgs.NewMsgCreateRecipe("name", "id001", "this has to meet character limits lol",
			types.CoinInputList{
				types.CoinInput{
					Coin:  "Wood",
					Count: 5,
				},
			},
			types.CoinOutputList{
				types.CoinOutput{
					Coin:  "Chair",
					Count: 1,
				},
			},
			types.ItemInputList{
				types.ItemInput{
					Item: types.NewItem("id001", map[string]float64{"endurance": 0.75},
						map[string]int{"HP": 100}, map[string]string{"Name": "Pikachu"}, sender,
					),
				},
			},
			types.ItemOutputList{
				types.ItemOutput{
					types.DoubleParamMap{"endurance": types.DoubleParam{0.70, 1.0, 1.0}}, types.LongParamMap{"HP": types.LongParam{100, 140, 1.0}}, 
						types.StringParamMap{"Name": types.StringParam{"Raichu", 1.0}},
				},
			}, sender,
		)

		signMsg, err := txBldr.BuildSignMsg([]sdk.Msg{msg})

		if err != nil {
			rest.WriteErrorResponse(w, http.StatusBadRequest, err.Error())
		}

		rest.PostProcessResponse(w, cdc, signMsg.Bytes(), cliCtx.Indent)
	}
}
