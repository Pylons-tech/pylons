package simapp

import (
	"encoding/json"
	"time"

	"github.com/cosmos/cosmos-sdk/simapp"
	abci "github.com/tendermint/tendermint/abci/types"
	"github.com/tendermint/tendermint/libs/log"
	tmproto "github.com/tendermint/tendermint/proto/tendermint/types"
	tmtypes "github.com/tendermint/tendermint/types"
	tmdb "github.com/tendermint/tm-db"

	"github.com/Pylons-tech/pylons/app"
)

// New creates application instance with in-memory database and disabled logging.
func New(dir string) app.PylonApp {
	db := tmdb.NewMemDB()
	logger := log.NewNopLogger()

	encoding := app.MakeEncodingConfig()

	pylonsApp := app.New(logger, db, nil, true, map[int64]bool{}, dir, 0, encoding,
		simapp.EmptyAppOptions{})

	genesisState := app.ModuleBasics.DefaultGenesis(encoding.Codec)
	stateBytes, err := json.MarshalIndent(genesisState, "", " ")
	if err != nil {
		panic(err)
	}

	// InitChain updates deliverState which is required when app.NewContext is called
	pylonsApp.InitChain(abci.RequestInitChain{
		ConsensusParams: defaultConsensusParams,
		AppStateBytes:   stateBytes,
	})
	return *pylonsApp
}

var defaultConsensusParams = &abci.ConsensusParams{
	Block: &abci.BlockParams{
		MaxBytes: 200000,
		MaxGas:   2000000,
	},
	Evidence: &tmproto.EvidenceParams{
		MaxAgeNumBlocks: 302400,
		MaxAgeDuration:  504 * time.Hour, // 3 weeks is the max duration
		MaxBytes:        10000,
	},
	Validator: &tmproto.ValidatorParams{
		PubKeyTypes: []string{
			tmtypes.ABCIPubKeyTypeEd25519,
		},
	},
}
