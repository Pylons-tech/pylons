package queriers

import (
	"fmt"
	"testing"

	"github.com/MikeSofaer/pylons/x/pylons/types"
	"github.com/stretchr/testify/require"
	abci "github.com/tendermint/tendermint/abci/types"
)

func TestAddrFromPubKeyFromAfti(t *testing.T) {
	input := setupTestInput()
	pubKey := "0283e197461d60d77d3b40e854646583ffebdcb12fa7f0327c4cd1c68b316e80f5"
	req := abci.RequestQuery{
		Path: fmt.Sprintf("custom/%s/%s/%s", types.Pylon, KeyAddrFromPubKey, pubKey),
		Data: []byte{},
	}

	addrRespBytes, err := AddrFromPubKey(input.ctx,
		[]string{pubKey},
		req,
		input.keeper,
	)

	if err != nil {
		t.Fatal(err)
	}

	var addrResp AddrResp

	err2 := input.cdc.UnmarshalJSON(addrRespBytes, &addrResp)

	if err2 != nil {
		t.Fatal(err2.Error())
	}

}
func TestAddrFromPubKeyFromGirish(t *testing.T) {
	input := setupTestInput()
	pubKey := "03DD07C1359668F47FF060805A5E2DD3190A2BB5A50577D7E90DB851DA0E6C00A2"
	expectedBech32Key := "cosmos16567xlv4hwwu9aak0up7h3428mcqe0adtx5lpc"
	req := abci.RequestQuery{
		Path: fmt.Sprintf("custom/%s/%s/%s", types.Pylon, KeyAddrFromPubKey, pubKey),
		Data: []byte{},
	}

	addrRespBytes, err := AddrFromPubKey(input.ctx,
		[]string{pubKey},
		req,
		input.keeper,
	)

	if err != nil {
		t.Fatal(err)
	}

	var addrResp AddrResp

	err2 := input.cdc.UnmarshalJSON(addrRespBytes, &addrResp)

	if err2 != nil {
		t.Fatal(err2.Error())
	}

	require.Equal(t, addrResp.Bech32Addr, expectedBech32Key)
}
