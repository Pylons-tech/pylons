package intTest

import (
	"errors"
	"io/ioutil"
	"os"
	"os/exec"
	"path"
	"testing"
	"time"

	"strings"

	"github.com/MikeSofaer/pylons/app"
	"github.com/cosmos/cosmos-sdk/x/auth"
	amino "github.com/tendermint/go-amino"
	ctypes "github.com/tendermint/tendermint/rpc/core/types"
)

func ReadFile(fileURL string, t *testing.T) []byte {
	jsonFile, err := os.Open(fileURL)
	if err != nil {
		t.Errorf("%+v", err)
	}
	// t.Log("Successfully Opened", fileURL)

	defer jsonFile.Close()

	byteValue, _ := ioutil.ReadAll(jsonFile)
	return byteValue
}

func GetAminoCdc() *amino.Codec {
	return app.MakeCodec()
}

func RunPylonsCli(args []string, stdinInput string) ([]byte, error) { // run pylonscli with specific params : helper function
	cmd := exec.Command(path.Join(os.Getenv("GOPATH"), "/bin/pylonscli"), args...)
	cmd.Stdin = strings.NewReader(stdinInput)
	return cmd.CombinedOutput()
}

func GetAccountAddr(account string, t *testing.T) string {
	addrBytes, err := RunPylonsCli([]string{"keys", "show", account, "-a"}, "")
	addr := strings.Trim(string(addrBytes), "\n ")
	if t != nil && err != nil {
		t.Errorf("error getting account address %+v, account=%s", err, account)
	}
	return addr
}

func GetAccountInfoFromAddr(addr string, t *testing.T) auth.BaseAccount {
	accBytes, err := RunPylonsCli([]string{"query", "account", addr}, "")
	if t != nil && err != nil {
		t.Errorf("error getting account info addr=%+v err=%+v", addr, err)
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

func GetDaemonStatus() (*ctypes.ResultStatus, error) {
	var ds ctypes.ResultStatus

	dsBytes, err := RunPylonsCli([]string{"status"}, "")

	if err != nil {
		return nil, err
	}
	err = GetAminoCdc().UnmarshalJSON(dsBytes, &ds)

	if err != nil {
		return nil, err
	}
	return &ds, nil
}

func WaitForNextBlock() error {
	return WaitForBlockInterval(1)
}

func WaitForBlockInterval(interval int64) error {
	ds, err := GetDaemonStatus()
	if err != nil {
		return err // couldn't get daemon status.
	}
	currentBlock := ds.SyncInfo.LatestBlockHeight

	var counter int64
	counter = 1
	for counter < 300*interval {
		ds, err = GetDaemonStatus()
		if ds.SyncInfo.LatestBlockHeight >= currentBlock+interval {
			return nil
		}
		time.Sleep(100 * time.Millisecond)
		counter += 1
	}
	return errors.New("No new block found though waited for 30s x interval")
}

func CleanFile(filePath string, t *testing.T) {
	err := os.Remove(filePath)
	ErrValidation(t, "error removing raw tx file json %+v", err)
}

func ErrValidation(t *testing.T, format string, err error) {
	if err != nil {
		t.Errorf(format, err)
		t.Fatal(err)
	}
}

func ErrValidationWithOutputLog(t *testing.T, format string, bytes []byte, err error) {
	if err != nil {
		t.Errorf(format, string(bytes), err)
		t.Fatal(err)
	}
}
