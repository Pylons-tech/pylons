package main

import (
	"testing"

	"github.com/MikeSofaer/pylons/x/pylons/msgs"
	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/stretchr/testify/require"
)

type CreateCookbookMsgValueModel struct {
	Description  string
	Developer    string
	Level        string
	Name         string
	Sender       string
	SupportEmail string
	Version      string
}

func TestCreateCookbookViaCLI(t *testing.T) {
	// TODO if we find a way to sign using sequence number between same blocks, this wait can be removed
	WaitForNextBlock()

	tests := []struct {
		name   string
		cbName string
	}{
		{
			"basic flow test",
			"TESTCB_CreateCookbook_001",
		},
	}

	for _, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			eugenAddr := GetAccountAddr("eugen", t)
			sdkAddr, err := sdk.AccAddressFromBech32(eugenAddr)

			require.True(t, err == nil)
			TestTxWithMsg(t, msgs.NewMsgCreateCookbook(
				tc.cbName,
				"this has to meet character limits lol",
				"SketchyCo",
				"1.0.0",
				"example@example.com",
				0,
				msgs.DefaultCostPerBlock,
				sdkAddr))
			// TestTxWithMsg(t, CreateCookbookMsgValueModel{
			// 	Description:  "this has to meet character limits lol",
			// 	Developer:    "SketchyCo",
			// 	Level:        "0",
			// 	Name:         tc.cbName,
			// 	Sender:       eugenAddr,
			// 	SupportEmail: "example@example.com",
			// 	Version:      "1.0.0",
			// }, "pylons/CreateCookbook")
		})
	}
}
