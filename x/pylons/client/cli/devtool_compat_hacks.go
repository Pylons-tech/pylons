package cli

import (
	"errors"

	"github.com/cosmos/cosmos-sdk/client"
	"github.com/spf13/cobra"
)

var altContext *client.Context

var ForceSkipConfirm = false

func GetAlternativeContext() *client.Context {
	return altContext
}

func HandleAlternativeContextForCommand(cmd *cobra.Command) (*client.Context, error) {
	altCtx := GetAlternativeContext()
	if altCtx != nil {
		if altCtx != nil {
			c := altCtx.WithSkipConfirmation(ForceSkipConfirm)
			return &c, nil
		}
		return nil, errors.New("no alternative context set")

	}
	c, err := client.GetClientTxContext(cmd)
	return &c, err
}

func SetAlternativeContext(ctx client.Context) {
	altContext = &ctx
}
