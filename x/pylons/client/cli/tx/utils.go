package tx

import (
	"io/ioutil"
	"os"
)

const (
	// BroadcastBlock defines a tx broadcasting mode where the client waits for
	// the tx to be committed in a block.
	BroadcastBlock = "block"
	// BroadcastSync defines a tx broadcasting mode where the client waits for
	// a CheckTx execution response only.
	BroadcastSync = "sync"
	// BroadcastAsync defines a tx broadcasting mode where the client returns
	// immediately.
	BroadcastAsync = "async"
	FlagNode               = "node"
	FlagFrom               = "from"
	FlagBroadcastMode      = "broadcast-mode"
	FlagKeyringBackend     = "keyring-backend"
)

func ReadFile(fileURL string) ([]byte, error) {
	jsonFile, err := os.Open(fileURL)
	if err != nil {
		return []byte{}, err
	}

	defer jsonFile.Close()

	byteValue, _ := ioutil.ReadAll(jsonFile)
	return byteValue, nil
}