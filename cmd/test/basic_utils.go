package intTest

import (
	"fmt"
	"flag"
	"errors"
	"io/ioutil"
	"os"
	"os/exec"
	"path"
	"sync"
	"time"
	"math/rand"

	testing "github.com/Pylons-tech/pylons/cmd/fixtures_test/evtesting"

	"strings"

	"github.com/Pylons-tech/pylons/app"
	"github.com/cosmos/cosmos-sdk/x/auth"
	amino "github.com/tendermint/go-amino"
	ctypes "github.com/tendermint/tendermint/rpc/core/types"
)

type CLIOptions struct {
	CustomNode   string
	RestEndpoint string
}

var CLIOpts CLIOptions
var cliMux sync.Mutex

func init() {
	flag.StringVar(&CLIOpts.CustomNode, "node", "tcp://localhost:26657", "custom node url")
}

func ReadFile(fileURL string, t *testing.T) []byte {
	jsonFile, err := os.Open(fileURL)
	if err != nil {
		t.Fatalf("%+v", err)
	}

	defer jsonFile.Close()

	byteValue, _ := ioutil.ReadAll(jsonFile)
	return byteValue
}

func GetAminoCdc() *amino.Codec {
	return app.MakeCodec()
}

func RunPylonsCli(args []string, stdinInput string) ([]byte, error, string) { // run pylonscli with specific params : helper function
	if len(CLIOpts.CustomNode) > 0 {
		if args[0] == "query" || args[0] == "tx" || args[0] == "status" {
			customNodes := strings.Split(CLIOpts.CustomNode, ",")
			randNodeIndex := rand.Intn(len(customNodes))
			randNode := customNodes[randNodeIndex]
			args = append(args, "--node", randNode)
		}
	}
	cliMux.Lock()
	cmd := exec.Command(path.Join(os.Getenv("GOPATH"), "/bin/pylonscli"), args...)
	cmd.Stdin = strings.NewReader(stdinInput)
	res, err := cmd.CombinedOutput()
	cliMux.Unlock()
	return res, err, fmt.Sprintf("cmd is \"pylonscli %s\", result is \"%s\"", strings.Join(args, " "), string(res))
}

func GetAccountAddr(account string, t *testing.T) string {
	addrBytes, err, logstr := RunPylonsCli([]string{"keys", "show", account, "-a", "--keyring-backend", "test"}, "")
	addr := strings.Trim(string(addrBytes), "\n ")
	if t != nil && err != nil {
		t.Fatalf("error getting account address, account=%s, err=%+v, logstr=%s", account, err, logstr)
	}
	return addr
}

func GetAccountInfoFromAddr(addr string, t *testing.T) auth.BaseAccount {
	accBytes, err, logstr := RunPylonsCli([]string{"query", "account", addr}, "")
	if t != nil && err != nil {
		t.Fatalf("error getting account info addr=%s err=%+v, logstr=%s", addr, err, logstr)
	}
	var accInfo auth.BaseAccount
	GetAminoCdc().UnmarshalJSON(accBytes, &accInfo)
	// t.Log("GetAccountInfo", accInfo)
	return accInfo
}

func GetAccountInfoFromName(account string, t *testing.T) auth.BaseAccount {
	addr := GetAccountAddr(account, t)
	return GetAccountInfoFromAddr(addr, t)
}

func GetDaemonStatus() (*ctypes.ResultStatus, error, string) {
	var ds ctypes.ResultStatus

	dsBytes, err, logstr := RunPylonsCli([]string{"status"}, "")

	if err != nil {
		return nil, err, logstr
	}
	err = GetAminoCdc().UnmarshalJSON(dsBytes, &ds)

	if err != nil {
		return nil, err, logstr
	}
	return &ds, nil, logstr
}

func WaitForNextBlock() error {
	return WaitForBlockInterval(1)
}

func WaitForBlockInterval(interval int64) error {
	ds, err, _ := GetDaemonStatus()
	if err != nil {
		return err // couldn't get daemon status.
	}
	currentBlock := ds.SyncInfo.LatestBlockHeight

	var counter int64
	counter = 1
	for counter < 300*interval {
		ds, err, _ = GetDaemonStatus()
		if ds.SyncInfo.LatestBlockHeight >= currentBlock+interval {
			return nil
		}
		time.Sleep(100 * time.Millisecond)
		counter += 1
	}
	return errors.New("You are waiting too long time which is 30s")
}

func CleanFile(filePath string, t *testing.T) {
	err := os.Remove(filePath)
	ErrValidation(t, "error removing raw tx file json %+v", err)
}

func ErrValidation(t *testing.T, format string, err error) {
	if err != nil {
		t.Fatalf(format, err)
	}
}

func ErrValidationWithOutputLog(t *testing.T, format string, bytes []byte, err error) {
	if err != nil {
		t.Fatalf(format, string(bytes), err)
	}
}
