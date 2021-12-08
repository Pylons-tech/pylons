package keeper_test

import (
	"encoding/base64"
	"fmt"

	"github.com/cosmos/cosmos-sdk/crypto/keys/ed25519"
	cryptotypes "github.com/cosmos/cosmos-sdk/crypto/types"
	sdk "github.com/cosmos/cosmos-sdk/types"


	"github.com/Pylons-tech/pylons/x/pylons/keeper"
	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (suite *IntegrationTestSuite) TestBurnDebtToken(){

	k := suite.k
	ctx := suite.ctx
	require := suite.Require()
	srv := keeper.NewMsgServerImpl(k)
	privKey := ed25519.GenPrivKey()
	addr1 := privKey.PubKey().Address()
	sdkCtk := sdk.WrapSDKContext(ctx)
	processorName := types.DefaultPaymentProcessors[0].Name

	msgBurnDebtToken := types.MsgBurnDebtToken{
		Creator:    addr1.String(),
		RedeemInfo: types.RedeemInfo{
			ID:            "testProductID",
			ProcessorName: processorName,
			Address:       addr1.String(),
			Amount:        sdk.NewInt(1_000_000_000),
			Signature:     genTestPaymentInfoSignature("TestProcessorName", addr1.String(), "testProductID", sdk.NewInt(1_000_000_000), privKey),
		},
	}
	resp,err := srv.BurnDebtToken(sdkCtk,&msgBurnDebtToken)
	require.NoError(err)
	require.NotNil(resp)

}

// genTestPaymentInfoSignature generates a signed PaymentInfo message using privKey
func genTestPaymentInfoSignature(purchaseID, address, productID string, amount sdk.Int, privKey cryptotypes.PrivKey) string {
	msg := fmt.Sprintf("{\"purchaseID\":\"%s\",\"address\":\"%s\",\"amount\":\"%s\",\"productID\":\"%s\"}", purchaseID, address, amount.String(), productID)
	msgBytes := []byte(msg)
	signedMsg, err := privKey.Sign(msgBytes)
	if err != nil {
		panic(err)
	}
	return base64.StdEncoding.EncodeToString(signedMsg)
}