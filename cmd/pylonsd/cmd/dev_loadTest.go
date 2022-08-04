package cmd

import (
	"encoding/csv"
	"fmt"
	"log"
	"os"
	"strconv"
	"sync"
	"time"

	pylonsApp "github.com/Pylons-tech/pylons/app"
	pb "github.com/Pylons-tech/pylons/x/pylons/types"
	"github.com/aliirns/cosmos-transaction-go/transaction"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	"github.com/spf13/cobra"

	// 	"github.com/Pylons-tech/pylons/x/pylons/types
	"github.com/cosmos/cosmos-sdk/client/flags"
	//"github.com/olekukonko/tablewriter"
	"go.uber.org/atomic"
)

const (
	grpcURL     = "127.0.0.1:9090"
	chainID     = "pylons-testnet-1"
	_KEYNAME    = 0
	_ADDRESS    = 1
	_PRIVATEKEY = 2
)

var wg sync.WaitGroup

func DevLoadTest() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "load-test [users]",
		Short: "Simulate a load test given the number of users",
		Long:  "Simulate a load test given the number of users, the provided number of user accounts will be created and used to perform transactions via GRPC",
		Args:  cobra.ExactArgs(1),
		RunE: func(cmd *cobra.Command, args []string) error {

			Users, err := strconv.Atoi(args[0])

			f, _ := cmd.Flags().GetString("accounts-file")

			if err != nil {
				return sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, "invalid number of users ", args[0])
			}

			var failureCount atomic.Uint32

			csvFile := readCsvFile(f)

			t1 := time.Now()

			wg.Add(Users)

			for i := 0; i < Users; i++ {
				msg := pb.MsgExecuteRecipe{Creator: csvFile[i][_ADDRESS], CookbookId: "cb130", RecipeId: "LOUDGetCharactercb130", CoinInputsIndex: 0, ItemIds: []string{}, PaymentInfos: []pb.PaymentInfo{}}
				go threadedLoadTest(csvFile[i][_KEYNAME], csvFile[i][_ADDRESS], csvFile[i][_PRIVATEKEY], &msg, &failureCount)
			}

			wg.Wait()

			elapsed := time.Since(t1)

			TPS := float64(Users) / (elapsed.Seconds())
			fmt.Println("Summary of LoadTest")
			fmt.Printf(" %v Concurrent transactions were performed\n %v transactions failed \n time taken : %v\n TPS Achieved : %v \n", Users, failureCount.String(), elapsed, TPS)

			return nil
		},
	}
	cmd.Flags().String(flags.FlagKeyringBackend, flags.DefaultKeyringBackend, "Select keyring's backend (os|file|kwallet|pass|test)")
	cmd.Flags().String("accounts-file", "", "csv file containing test accounts dump")
	return cmd
}

func readCsvFile(filePath string) [][]string {
	f, err := os.Open(filePath)
	if err != nil {
		log.Fatal("Unable to read input file "+filePath, err)
	}
	defer f.Close()

	csvReader := csv.NewReader(f)
	records, err := csvReader.ReadAll()
	if err != nil {
		log.Fatal("Unable to parse file as CSV for "+filePath, err)
	}

	return records
}

func threadedLoadTest(myKey string, myaddress string, myprivateKey string, m sdk.Msg, counter *atomic.Uint32) {
	defer wg.Done()
	config := pylonsApp.DefaultConfig()
	res, err := transaction.CosmosTx(myaddress, myprivateKey, grpcURL, m, chainID, config)
	if err != nil {
		counter.Add(1)
		return
	}
	if res.TxResponse.Code != 0 {
		counter.Add(1)
		return
	}
	return

}
