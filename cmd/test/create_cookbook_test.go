package main

import (
	"testing"
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
			TestTxWithMsg(t, CreateCookbookMsgValueModel{
				Description:  "this has to meet character limits lol",
				Developer:    "SketchyCo",
				Level:        "0",
				Name:         tc.cbName,
				Sender:       eugenAddr,
				SupportEmail: "example@example.com",
				Version:      "1.0.0",
			}, "pylons/CreateCookbook")
		})
	}
}
