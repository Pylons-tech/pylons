package inttest

import (
	"fmt"
	originT "testing"
	"time"

	testing "github.com/Pylons-tech/pylons_sdk/cmd/evtesting"

	inttestSDK "github.com/Pylons-tech/pylons_sdk/cmd/test_utils"
)

func TestCreateAccountViaCLI(originT *originT.T) {
	t := testing.NewT(originT)
	t.Parallel()

	tests := []struct {
		name         string
		wrongSigner  bool
		genNewKey    bool
		desiredError string
	}{
		{
			name:      "successful account creation",
			genNewKey: true,
		},
		{
			name:        "account creation wrong signer",
			genNewKey:   true,
			wrongSigner: true,
		},
		{
			name:      "account creation existing account",
			genNewKey: false,
		},
	}

	for _, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			key := "eugen"
			if tc.genNewKey {
				key = fmt.Sprintf("car%d", time.Now().Unix())
				_, err := inttestSDK.AddNewLocalKey(key)
				t.MustNil(err)
			}
			result, logstr, err := inttestSDK.CreateChainAccount(key)
			t.WithFields(testing.Fields{
				"result": result,
				"logstr": logstr,
			}).MustNil(err, "error creating account on chain")

			err = inttestSDK.WaitForBlockInterval(2)
			t.MustNil(err, "error waiting for block interval")
			strAddr := inttestSDK.GetAccountAddr(key, t)
			inttestSDK.GetAccountInfoFromAddr(strAddr, t)
		})
	}
}
