package handlers

import (
	"strings"
	"testing"

	"github.com/Pylons-tech/pylons/x/pylons/config"
	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	"github.com/Pylons-tech/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"
)

func TestHandlerMsgSendItems(t *testing.T) {
	tci := keep.SetupTestCoinInput()

	sender1, sender2, sender3 := keep.SetupTestAccountsWithCoins(t, tci, types.NewPylon(10000000), types.NewPylon(10000000), types.NewPylon(10))

	require.True(t, tci.PlnK.CoinKeeper.HasCoins(tci.Ctx, sender1, types.NewPylon(10000000)))
	require.True(t, tci.PlnK.CoinKeeper.HasCoins(tci.Ctx, sender2, types.NewPylon(10000000)))
	cbData := MockCookbook(tci, sender1)
	cookbook, err := tci.PlnK.GetCookbook(tci.Ctx, cbData.CookbookID)
	require.True(t, err == nil)

	item1 := keep.GenItem(cbData.CookbookID, sender1, "sword")
	item2 := keep.GenItem(cbData.CookbookID, sender1, "axe")
	item3 := keep.GenItem(cbData.CookbookID, sender2, "spear")
	item4 := keep.GenItem(cbData.CookbookID, sender2, "bow")
	item5 := keep.GenItem(cbData.CookbookID, sender3, "bow1")

	item2.OwnerRecipeID = "????????"

	item3.AdditionalTransferFee = 700
	item4.AdditionalTransferFee = 700

	err = tci.PlnK.SetItem(tci.Ctx, *item1)
	require.True(t, err == nil)

	err = tci.PlnK.SetItem(tci.Ctx, *item2)
	require.True(t, err == nil)

	err = tci.PlnK.SetItem(tci.Ctx, *item3)
	require.True(t, err == nil)

	err = tci.PlnK.SetItem(tci.Ctx, *item4)
	require.True(t, err == nil)

	err = tci.PlnK.SetItem(tci.Ctx, *item5)
	require.True(t, err == nil)

	cases := map[string]struct {
		itemIDs      []string
		fromAddress  sdk.AccAddress
		toAddress    sdk.AccAddress
		desiredError string
		showError    bool
	}{
		"successful check": {
			itemIDs:      []string{item3.ID, item4.ID},
			fromAddress:  sender2,
			toAddress:    sender1,
			desiredError: "",
			showError:    false,
		},
		"not enough coins for fee check": {
			itemIDs:      []string{item5.ID},
			fromAddress:  sender3,
			toAddress:    sender2,
			desiredError: "Sender does not have enough coins for fees",
			showError:    true,
		},
		"empty item id check": {
			itemIDs:      []string{item1.ID, item2.ID, ""},
			fromAddress:  sender1,
			toAddress:    sender2,
			desiredError: "ItemID is invalid",
			showError:    true,
		},
		"same sender and receiver check": {
			itemIDs:      []string{item1.ID, item2.ID},
			fromAddress:  sender1,
			toAddress:    sender1,
			desiredError: "Sender and receiver should be different",
			showError:    true,
		},
		"wrong item sender check": {
			itemIDs:      []string{item1.ID},
			fromAddress:  sender2,
			toAddress:    sender1,
			desiredError: "Item is not the sender's one",
			showError:    true,
		},
		"owner recipe id check": {
			itemIDs:      []string{item2.ID},
			fromAddress:  sender1,
			toAddress:    sender2,
			desiredError: "Item is owned by a recipe",
			showError:    true,
		},
		"duplicated items check": {
			itemIDs:      []string{item1.ID, item1.ID},
			fromAddress:  sender1,
			toAddress:    sender2,
			desiredError: "Duplicated items in items trasfer",
			showError:    true,
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			msg := msgs.NewMsgSendItems(tc.itemIDs, tc.fromAddress, tc.toAddress)

			pylonsLLCAddress, err := sdk.AccAddressFromBech32(config.Config.Validators.PylonsLLC)

			require.True(t, err == nil)

			coinsBefore := tci.PlnK.CoinKeeper.GetCoins(tci.Ctx, tc.fromAddress)
			coinsLLCBefore := tci.PlnK.CoinKeeper.GetCoins(tci.Ctx, pylonsLLCAddress)
			coinsCBBefore := tci.PlnK.CoinKeeper.GetCoins(tci.Ctx, cookbook.Sender)

			_, err = HandlerMsgSendItems(tci.Ctx, tci.PlnK, msg)

			coinsAfter := tci.PlnK.CoinKeeper.GetCoins(tci.Ctx, tc.fromAddress)
			coinsLLCAfter := tci.PlnK.CoinKeeper.GetCoins(tci.Ctx, pylonsLLCAddress)
			coinsCBAfter := tci.PlnK.CoinKeeper.GetCoins(tci.Ctx, cookbook.Sender)

			if !tc.showError {
				for _, itemID := range tc.itemIDs {
					item, err := tci.PlnK.GetItem(tci.Ctx, itemID)
					require.True(t, err == nil)
					require.True(t, item.Sender.String() == tc.toAddress.String())
				}

				differ := coinsBefore.AmountOf(types.Pylon).Int64() - coinsAfter.AmountOf(types.Pylon).Int64()
				differLLC := coinsLLCAfter.AmountOf(types.Pylon).Int64() - coinsLLCBefore.AmountOf(types.Pylon).Int64()
				differCB := coinsCBAfter.AmountOf(types.Pylon).Int64() - coinsCBBefore.AmountOf(types.Pylon).Int64()

				require.True(t, differ == 2000)
				require.True(t, differLLC == 200)
				require.True(t, differCB == 1800)
			} else {
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			}
		})
	}
}
