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
	tests := []struct {
		name string
	}{
		{
			"basic flow test",
		},
	}

	for _, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			eugenAddr := GetAccountAddr("eugen", t)
			TestTxWithMsg(t, CreateCookbookMsgValueModel{
				Description:  "this has to meet character limits lol",
				Developer:    "SketchyCo",
				Level:        "0",
				Name:         "Morethan8Name",
				Sender:       eugenAddr,
				SupportEmail: "example@example.com",
				Version:      "1.0.0",
			}, "pylons/CreateCookbook")
		})
	}
}
