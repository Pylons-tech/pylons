package keeper

import (
	"context"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

func (k msgServer) AppleIap(goCtx context.Context, msg *types.MsgAppleIap) (*types.MsgAppleIapResponse, error) {
	ctx := sdk.UnwrapSDKContext(goCtx)

	receipt, err := types.ValidateApplePay(msg)
	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "invalid receipt")
	}

	if receipt.PurchaseId != msg.PurchaseId {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "invalid transaction token")
	}
	if receipt.ProductId != msg.ProductId {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "invalid product id")
	}

	if k.HasAppleIAPOrder(ctx, receipt.PurchaseId) {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "the Apple IAP order ID is already being used")
	}

	var coinIssuer types.CoinIssuer
	var iapPackage types.GoogleInAppPurchasePackage
CoinIssuersLoop:
	for _, ci := range types.DefaultCoinIssuers {
		for _, p := range ci.Packages {
			if p.ProductId == receipt.ProductId {
				coinIssuer = ci
				iapPackage = p
				break CoinIssuersLoop
			}
		}
	}

	if len(coinIssuer.CoinDenom) == 0 {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "invalid product id")
	}

	receipt.Creator = msg.Creator
	k.SetAppleIAPOrder(ctx, *receipt)
	// if address is invalid, it will already fail before the message handling gets here
	addr, _ := sdk.AccAddressFromBech32(msg.Creator)

	amt := sdk.NewCoins(sdk.NewCoin(coinIssuer.CoinDenom, iapPackage.Amount))
	err = k.MintCoinsToAddr(ctx, addr, amt)
	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	_ = ctx.EventManager().EmitTypedEvent(&types.EventApplePurchase{
		Creator:           msg.Creator,
		ProductId:         receipt.ProductId,
		TransactionId:     receipt.PurchaseId,
		ReceiptDataBase64: msg.ReceiptDataBase64,
	})

	return &types.MsgAppleIapResponse{}, nil
}
