package cli

import (
	"github.com/cosmos/cosmos-sdk/client"
)

var altContext *client.Context

var ForceSkipConfirm = false

func GetAltenativeContext() *client.Context {
	return altContext
}

func SetAlternativeContext(ctx client.Context) {
	altContext = &ctx
}
