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
					Doubles: types.DoubleInputParamMap{"endurance": types.DoubleInputParam{MinValue: "0.7", MaxValue: "1"}},
					Longs: types.LongInputParamMap{"HP": types.LongInputParam{WeightTable: types.WeightTable{WeightRanges: []types.WeightRange{
						types.WeightRange{
							Lower:  100,
							Upper:  500,
							Weight: 6,
						},
						types.WeightRange{
							Lower:  501,
							Upper:  800,
							Weight: 2,
						},
					}}}},
					Strings: types.StringInputParamMap{"Name": types.StringInputParam{Value: "Raichu"}},
				},
			},
			types.ItemOutputList{
				types.ItemOutput{
					Doubles: types.DoubleParamMap{"endurance": types.DoubleParam{MinValue: "0.7", MaxValue: "1", Rate: "1"}},
					Longs: types.LongParamMap{"HP": types.LongParam{WeightTable: types.WeightTable{WeightRanges: []types.WeightRange{
						types.WeightRange{
							Lower:  100,
							Upper:  500,
							Weight: 6,
						},
						types.WeightRange{
							Lower:  501,
							Upper:  800,
							Weight: 2,
						},
					}}}},
					Strings: types.StringParamMap{"Name": types.StringParam{Value: "Raichu", Rate: "1"}},
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
