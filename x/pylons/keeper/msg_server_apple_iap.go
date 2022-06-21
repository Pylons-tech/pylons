package keeper

import (
	"context"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

func (k msgServer) AppleIap(goCtx context.Context, msg *types.MsgAppleIap) (*types.MsgAppleIapResponse, error) {
	ctx := sdk.UnwrapSDKContext(goCtx)

	// TODO: Handling the message
	receipt, err := types.ValidateApplePay(msg)
	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "invalid receipt")
	}

	if k.HasAppleIAPOrder(ctx, receipt.TransactionID) {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "the Apple IAP order ID is already being used")
	}

	var coinIssuer types.CoinIssuer
	var iapPackage types.GoogleInAppPurchasePackage
CoinIssuersLoop:
	for _, ci := range types.DefaultCoinIssuers {
		for _, p := range ci.Packages {
			if p.ProductID == receipt.ProductID {
				coinIssuer = ci
				iapPackage = p
				break CoinIssuersLoop
			}
		}
	}

	if len(coinIssuer.CoinDenom) == 0 {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "invalid product id")
	}

	iap := types.AppleInAppPurchaseOrder{
		Quantity:      receipt.Quantity,
		ProductID:     receipt.ProductID,
		TransactionID: receipt.TransactionID,
		PurchaseDate:  receipt.PurchaseDate,
		Creator:       msg.Creator,
	}
	k.SetAppleIAPOrder(ctx, iap)
	// if address is invalid, it will already fail before the message handling gets here
	addr, _ := sdk.AccAddressFromBech32(msg.Creator)

	amt := sdk.NewCoins(sdk.NewCoin(coinIssuer.CoinDenom, iapPackage.Amount))
	err = k.MintCoinsToAddr(ctx, addr, amt)
	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	_ = ctx.EventManager().EmitTypedEvent(&types.EventApplePurchase{
		Creator:           msg.Creator,
		ProductID:         receipt.ProductID,
		TransactionID:     receipt.TransactionID,
		ReceiptDataBase64: msg.Data,
	})

	return &types.MsgAppleIapResponse{}, nil
}
