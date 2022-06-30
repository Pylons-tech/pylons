package cli

import (
	"errors"

	"github.com/cosmos/cosmos-sdk/client"
)

var altContext *client.Context

var ForceSkipConfirm = false

func GetAltenativeContext() *client.Context {
	return altContext
}

func SetAlternativeContext(ctx client.Context) error {
	if altContext != nil {
		return errors.New("alternative context already set - should not be trying to set it again")
	}
	altContext = &ctx
	return nil
}
