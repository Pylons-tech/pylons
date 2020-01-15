package queriers

import (
	"fmt"
	"testing"

	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	"github.com/stretchr/testify/require"
	abci "github.com/tendermint/tendermint/abci/types"
)

func TestAddrFromPubKeyFromAfti(t *testing.T) {
	input := keep.SetupTestCoinInput()
	pubKey := "0283e197461d60d77d3b40e854646583ffebdcb12fa7f0327c4cd1c68b316e80f5"
	expectedBech32Addr := "cosmos1q5zytcjpvpsg39pt3tjq8hljlmc9tjcv5arnjg"
	req := abci.RequestQuery{
		Path: fmt.Sprintf("custom/%s/%s/%s", types.Pylon, KeyAddrFromPubKey, pubKey),
		Data: []byte{},
	}

	addrRespBytes, err := AddrFromPubKey(input.Ctx,
		[]string{pubKey},
		req,
		input.PlnK,
	)

	if err != nil {
		t.Fatal(err)
	}

	var addrResp AddrResp

	err2 := input.Cdc.UnmarshalJSON(addrRespBytes, &addrResp)

	if err2 != nil {
		t.Fatal(err2.Error())
	}

	require.Equal(t, addrResp.Bech32Addr, expectedBech32Addr)

}
func TestAddrFromPubKeyFromGirish(t *testing.T) {
	input := keep.SetupTestCoinInput()
	pubKey := "03DD07C1359668F47FF060805A5E2DD3190A2BB5A50577D7E90DB851DA0E6C00A2"
	expectedBech32Addr := "cosmos16567xlv4hwwu9aak0up7h3428mcqe0adtx5lpc"

	req := abci.RequestQuery{
		Path: fmt.Sprintf("custom/%s/%s/%s", types.Pylon, KeyAddrFromPubKey, pubKey),
		Data: []byte{},
	}

	addrRespBytes, err := AddrFromPubKey(input.Ctx,
		[]string{pubKey},
		req,
		input.PlnK,
	)

	if err != nil {
		t.Fatal(err)
	}

	var addrResp AddrResp

	err2 := input.Cdc.UnmarshalJSON(addrRespBytes, &addrResp)

	if err2 != nil {
		t.Fatal(err2.Error())
	}

	require.Equal(t, addrResp.Bech32Addr, expectedBech32Addr)
}
