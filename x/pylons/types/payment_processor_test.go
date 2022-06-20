package types

import (
	"encoding/base64"
	"fmt"
	"testing"

	"github.com/cosmos/cosmos-sdk/crypto/keys/ed25519"
	cryptotypes "github.com/cosmos/cosmos-sdk/crypto/types"
	"github.com/cosmos/cosmos-sdk/types"
)

// genTestPaymentInfoSignature generates a signed PaymentInfo message using privKey
func genTestPaymentInfoSignature(purchaseID, address, productID string, amount types.Int, privKey cryptotypes.PrivKey) string {
	msg := fmt.Sprintf("{\"purchase_id\":\"%s\",\"address\":\"%s\",\"amount\":\"%s\",\"product_id\":\"%s\"}", purchaseID, address, amount.String(), productID)
	msgBytes := []byte(msg)
	signedMsg, err := privKey.Sign(msgBytes)
	if err != nil {
		panic(err)
	}
	return base64.StdEncoding.EncodeToString(signedMsg)
}

// genTestRedeemInfoSignature generates a signed RedeemInfo message using privKey
func genTestRedeemInfoSignature(payoutID, address string, amount types.Int, privKey cryptotypes.PrivKey) string {
	msg := fmt.Sprintf("{\"payout_id\":\"%s\",\"address\":\"%s\",\"amount\":\"%s\"}", payoutID, address, amount.String())
	msgBytes := []byte(msg)
	signedMsg, err := privKey.Sign(msgBytes)
	if err != nil {
		panic(err)
	}
	return base64.StdEncoding.EncodeToString(signedMsg)
}

func TestPaymentProcessor_ValidatePaymentInfo(t *testing.T) {
	privKey := ed25519.GenPrivKey()
	type fields struct {
		CoinDenom            string
		PubKey               string
		ProcessorPercentange types.Dec
		ValidatorsPercentage types.Dec
		Name                 string
	}
	type args struct {
		pi PaymentInfo
	}
	tests := []struct {
		name    string
		fields  fields
		args    args
		wantErr bool
	}{
		{
			name: "Valid",
			fields: fields{
				CoinDenom:            "ustripeusd",
				PubKey:               base64.StdEncoding.EncodeToString(privKey.PubKey().Bytes()),
				ProcessorPercentange: DefaultProcessorPercentage,
				ValidatorsPercentage: DefaultValidatorsPercentage,
				Name:                 "Pylons_Inc",
			},
			args: args{
				pi: PaymentInfo{
					PurchaseId:    "testPurchaseId",
					ProcessorName: "Pylons_Inc",
					PayerAddr:     GenTestBech32FromString("test"),
					Amount:        types.NewInt(1_000_000_000), // 1000stripeusd
					ProductId:     "testProductId",
					Signature:     genTestPaymentInfoSignature("testPurchaseId", GenTestBech32FromString("test"), "testProductId", types.NewInt(1_000_000_000), privKey),
				},
			},
			wantErr: false,
		},
		{
			name: "InvalidSignature",
			fields: fields{
				CoinDenom:            "ustripeusd",
				PubKey:               base64.StdEncoding.EncodeToString(privKey.PubKey().Bytes()),
				ProcessorPercentange: DefaultProcessorPercentage,
				ValidatorsPercentage: DefaultValidatorsPercentage,
				Name:                 "Pylons_Inc",
			},
			args: args{
				pi: PaymentInfo{
					PurchaseId:    "testPurchaseId",
					ProcessorName: "Pylons_Inc",
					PayerAddr:     GenTestBech32FromString("test"),
					Amount:        types.NewInt(1_000_000_000), // 1000stripeusd
					ProductId:     "testProductId",
					Signature:     "INVALID_SIGNATURE",
				},
			},
			wantErr: true,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			pp := PaymentProcessor{
				CoinDenom:            tt.fields.CoinDenom,
				PubKey:               tt.fields.PubKey,
				ProcessorPercentage:  tt.fields.ProcessorPercentange,
				ValidatorsPercentage: tt.fields.ValidatorsPercentage,
				Name:                 tt.fields.Name,
			}
			if err := pp.ValidatePaymentInfo(tt.args.pi); (err != nil) != tt.wantErr {
				t.Errorf("ValidatePaymentInfo() error = %v, wantErr %v", err, tt.wantErr)
			}
		})
	}
}

func TestPaymentProcessor_ValidateRedeemInfo(t *testing.T) {
	privKey := ed25519.GenPrivKey()
	type fields struct {
		CoinDenom            string
		PubKey               string
		ProcessorPercentange types.Dec
		ValidatorsPercentage types.Dec
		Name                 string
	}
	type args struct {
		ri RedeemInfo
	}
	tests := []struct {
		name    string
		fields  fields
		args    args
		wantErr bool
	}{
		{
			name: "Valid",
			fields: fields{
				CoinDenom:            "ustripeusd",
				PubKey:               base64.StdEncoding.EncodeToString(privKey.PubKey().Bytes()),
				ProcessorPercentange: DefaultProcessorPercentage,
				ValidatorsPercentage: DefaultValidatorsPercentage,
				Name:                 "Pylons_Inc",
			},
			args: args{
				ri: RedeemInfo{
					Id:            "testRedeemID",
					ProcessorName: "Pylons_Inc",
					Address:       GenTestBech32FromString("test"),
					Amount:        types.NewInt(1_000_000_000), // 1000stripeusd
					Signature:     genTestRedeemInfoSignature("testRedeemID", GenTestBech32FromString("test"), types.NewInt(1_000_000_000), privKey),
				},
			},
			wantErr: false,
		},
		{
			name: "InvalidSignature",
			fields: fields{
				CoinDenom:            "ustripeusd",
				PubKey:               base64.StdEncoding.EncodeToString(privKey.PubKey().Bytes()),
				ProcessorPercentange: DefaultProcessorPercentage,
				ValidatorsPercentage: DefaultValidatorsPercentage,
				Name:                 "Pylons_Inc",
			},
			args: args{
				ri: RedeemInfo{
					Id:            "testRedeemID",
					ProcessorName: "Pylons_Inc",
					Address:       GenTestBech32FromString("test"),
					Amount:        types.NewInt(1_000_000_000), // 1000stripeusd
					Signature:     "INVALID_SIGNATURE",
				},
			},
			wantErr: true,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			pp := PaymentProcessor{
				CoinDenom:            tt.fields.CoinDenom,
				PubKey:               tt.fields.PubKey,
				ProcessorPercentage:  tt.fields.ProcessorPercentange,
				ValidatorsPercentage: tt.fields.ValidatorsPercentage,
				Name:                 tt.fields.Name,
			}
			if err := pp.ValidateRedeemInfo(tt.args.ri); (err != nil) != tt.wantErr {
				t.Errorf("ValidateRedeemInfo() error = %v, wantErr %v", err, tt.wantErr)
			}
		})
	}
}
