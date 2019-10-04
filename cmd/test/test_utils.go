package main

import (
	// "flag"
	// "io/ioutil"
	"os"
	"os/exec"
	"path"
	"testing"

	// "path/filepath"
	// "runtime"
	"strings"
)

func RunPylonsCli(args []string, stdinInput string) ([]byte, error) { // run pylonscli with specific params : helper function
	cmd := exec.Command(path.Join(os.Getenv("GOPATH"), "/bin/pylonscli"), args...)
	cmd.Stdin = strings.NewReader(stdinInput)
	return cmd.CombinedOutput()
}

func GetAccountAddr(account string, t *testing.T) string {
	addrBytes, err := RunPylonsCli([]string{"keys", "show", account, "-a"}, "")
	addr := strings.Trim(string(addrBytes), "\n ")
	if t != nil && err != nil {
		t.Fatal(err)
	}
	return addr
}

func BroadcastTx() {

}

func CleanGeneratedFiles() { // remove signed transaction json files

}

func SetupChainAndAccounts() {
	// RunPylonsCli([]string{"keys", "add", "eugen"}, "11111111\n11111111\n")
	// eugenAddr := GetAccountAddr("eugen", nil)
	// pylonsd add-genesis-account $(pylonscli keys show aaa -a) 100pylon,1000alicecoin
	// # Copy the `Address` output here and save it for later use
	// # [optional] add "--ledger" at the end to use a Ledger Nano S
	// pylonscli keys add jack

	// # Copy the `Address` output here and save it for later use
	// pylonscli keys add alice

	// # Add both accounts, with coins to the genesis file
	// pylonsd add-genesis-account $(pylonscli keys show jack -a) 100pylon,1000jackcoin
	// pylonsd add-genesis-account $(pylonscli keys show alice -a) 100pylon,1000alicecoin

	// # Configure your CLI to eliminate need for chain-id flag
	// pylonscli config chain-id pylonschain
	// pylonscli config output json
	// pylonscli config indent true
	// pylonscli config trust-node true
}
