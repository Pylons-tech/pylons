package app

import (
	"fmt"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	authsigning "github.com/cosmos/cosmos-sdk/x/auth/signing"
	banktypes "github.com/cosmos/cosmos-sdk/x/bank/types"
)

type AnteSpamMigitationDecorator struct {
	pk PylonsKeeper
}

type AnteRestrictUbedrockDecorator struct {
	pk PylonsKeeper
}

func NewSpamMigitationAnteDecorator(pylonsmodulekeeper PylonsKeeper) AnteSpamMigitationDecorator {
	return AnteSpamMigitationDecorator{
		pk: pylonsmodulekeeper,
	}
}

func NewRestrictUbedrockAnteDecorator(pylonsmodulekeeper PylonsKeeper) AnteRestrictUbedrockDecorator {
	return AnteRestrictUbedrockDecorator{
		pk: pylonsmodulekeeper,
	}
}

// AnteDecorator
func (ad AnteSpamMigitationDecorator) AnteHandle(ctx sdk.Context, tx sdk.Tx, simulate bool, next sdk.AnteHandler) (sdk.Context, error) {
	if (ctx.IsCheckTx() || ctx.IsReCheckTx()) && !simulate {
		sigTx, ok := tx.(authsigning.SigVerifiableTx)
		if !ok {
			return ctx, sdkerrors.Wrap(sdkerrors.ErrTxDecode, "invalid transaction type")
		}

		// get max txs in a block, default is 20
		params := ad.pk.GetParams(ctx)
		maxTxs := params.MaxTxsInBlock

		// increment sequence of all signers
		for _, addr := range sigTx.GetSigners() {
			AccountTrack[addr.String()]++
			if AccountTrack[addr.String()] > maxTxs {
				panic(fmt.Sprintf("maximum txs in block is %d ", maxTxs))
			}
		}
	}

	return next(ctx, tx, simulate)
}

const (
	//------------------- FAKE ADDRESS -------------------//
	Address1 = "pylo1sv27mzddvum3kr7yrvptt8smyurwezzkr7psaj"
	Address2 = "pylo1qfy4qtkgshcuzlds5z8l4mxqxc5ytdcdgr0sq7"
	Address3 = "pylo1r84qxl40smy5tkzjhx0w6xe758qkhtgs44u5ft"
	Address4 = "pylo1yhd2wvh4nfg4e3htzvhsq09d8wyg6eme6nte7p"
	Address5 = "pylo1c5j57tx5m340kfn6sn99y694c5n3swjddn2rax"
	Address6 = "pylo1hr0k73dxc53fmexxmg84qvjeva5674hkrpcs7h"
	Address7 = "pylo12ul2m8k52clrah6r09zcrvvu0wtwkwuatmufgd"
	Address8 = "pylo1edtuu739j3q794uwgffddehx84yhhyxd7wsjly"
	//------------------- FAKE ADDRESS -------------------//
)

var (
	Accounts = []string{
		Address1,
		Address2,
		Address3,
		Address4,
		Address5,
		Address6,
		Address7,
		Address8,
	}
)

// AnteDecorator for restrict ubedrock denom used by unallowed address
func (ad AnteRestrictUbedrockDecorator) AnteHandle(ctx sdk.Context, tx sdk.Tx, simulate bool, next sdk.AnteHandler) (sdk.Context, error) {
	if (ctx.IsCheckTx() || ctx.IsReCheckTx()) && !simulate {
		sigTx, ok := tx.(authsigning.SigVerifiableTx)
		if !ok {
			return ctx, sdkerrors.Wrap(sdkerrors.ErrTxDecode, "invalid transaction type")
		}

		messages := sigTx.GetMsgs()
		if len(messages) > 0 {
			for _, message := range messages {
				msgSend, ok := message.(*banktypes.MsgSend)
				if ok {
					sendAddr := msgSend.FromAddress
					toAddr := msgSend.ToAddress
					_, sendAddr_found := ad.pk.GetPylonsKYC(ctx, sendAddr)
					_, toAddr_found := ad.pk.GetPylonsKYC(ctx, toAddr)

					if ok, _ = msgSend.Amount.Find("ubedrock"); ok {
						for _, acc := range Accounts {
							if (sendAddr != acc || toAddr != acc) && (sendAddr_found == false || toAddr_found == false) {
								panic("'ubedrock' should only be transfer among allowed address")
							}
						}
					}
				}
			}
		}
	}
	return next(ctx, tx, simulate)
}
