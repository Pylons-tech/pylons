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

	sender1, sender2, sender3 := keep.SetupTestAccounts(t, tci, types.NewPylon(10000000), types.NewPylon(10000000), types.NewPylon(10))

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
	item6 := keep.GenItem(cbData.CookbookID, sender2, "bow2")
	item7 := keep.GenItem(cbData.CookbookID, sender2, "bow3")

	item2.OwnerRecipeID = "????????"

	item3.AdditionalItemSendFee = 700
	item4.AdditionalItemSendFee = 700

	item6.AdditionalItemSendFee = 342
	item7.AdditionalItemSendFee = 887

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

	err = tci.PlnK.SetItem(tci.Ctx, *item6)
	require.True(t, err == nil)

	err = tci.PlnK.SetItem(tci.Ctx, *item7)
	require.True(t, err == nil)

	cases := map[string]struct {
		itemIDs         []string
		fromAddress     sdk.AccAddress
		toAddress       sdk.AccAddress
		desiredError    string
		showError       bool
		differSender    int64
		differPylonsLLC int64
		differCBOwner   int64
	}{
		"successful check": {
			itemIDs:         []string{item3.ID, item4.ID},
			fromAddress:     sender2,
			toAddress:       sender1,
			desiredError:    "",
			showError:       false,
			differSender:    2000,
			differPylonsLLC: 200,
			differCBOwner:   1800,
		},
		"successful check1": {
			itemIDs:         []string{item6.ID, item7.ID},
			fromAddress:     sender2,
			toAddress:       sender1,
			desiredError:    "",
			showError:       false,
			differSender:    1827, // differSender = differPylonsLLC + differCBOwner = 182 + 1645 = 1827
			differPylonsLLC: 182,  // differPylonsLLC = (basicSendItemsFee + item6.AdditionalItemSendFee) * pylonsLLCSendIemsPercent / 100 + ...(item7) = (300 + 342) * 10 / 100 + (300 + 887) * 10 / 100 = 64 + 118 = 182
			differCBOwner:   1645, // differPylonsLLC = (basicSendItemsFee + item6.AdditionalItemSendFee) * cbOwnerSendIemsPercent / 100 + ...(item7) = (300 + 342) * 90 / 100 + (300 + 887) * 90 / 100 = 577 + 1068 = 1645
		},
		"not enough coins for fee check": {
			itemIDs:         []string{item5.ID},
			fromAddress:     sender3,
			toAddress:       sender2,
			desiredError:    "Sender does not have enough coins for fees",
			showError:       true,
			differSender:    0,
			differPylonsLLC: 0,
			differCBOwner:   0,
		},
		"empty item id check": {
			itemIDs:         []string{item1.ID, item2.ID, ""},
			fromAddress:     sender1,
			toAddress:       sender2,
			desiredError:    "ItemID is invalid",
			showError:       true,
			differSender:    0,
			differPylonsLLC: 0,
			differCBOwner:   0,
		},
		"same sender and receiver check": {
			itemIDs:         []string{item1.ID, item2.ID},
			fromAddress:     sender1,
			toAddress:       sender1,
			desiredError:    "Sender and receiver should be different",
			showError:       true,
			differSender:    0,
			differPylonsLLC: 0,
			differCBOwner:   0,
		},
		"wrong item sender check": {
			itemIDs:         []string{item1.ID},
			fromAddress:     sender2,
			toAddress:       sender1,
			desiredError:    "Item is not the sender's one",
			showError:       true,
			differSender:    0,
			differPylonsLLC: 0,
			differCBOwner:   0,
		},
		"owner recipe id check": {
			itemIDs:         []string{item2.ID},
			fromAddress:     sender1,
			toAddress:       sender2,
			desiredError:    "Item is owned by a recipe",
			showError:       true,
			differSender:    0,
			differPylonsLLC: 0,
			differCBOwner:   0,
		},
		"duplicated items check": {
			itemIDs:         []string{item1.ID, item1.ID},
			fromAddress:     sender1,
			toAddress:       sender2,
			desiredError:    "Duplicated items in items trasfer",
			showError:       true,
			differSender:    0,
			differPylonsLLC: 0,
			differCBOwner:   0,
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			msg := msgs.NewMsgSendItems(tc.itemIDs, tc.fromAddress, tc.toAddress)

			pylonsLLCAddress, err := sdk.AccAddressFromBech32(config.Config.Validators.PylonsLLC)

			require.True(t, err == nil)

			coinsSenderBefore := tci.PlnK.CoinKeeper.GetCoins(tci.Ctx, tc.fromAddress)
			coinsPylonsLLCBefore := tci.PlnK.CoinKeeper.GetCoins(tci.Ctx, pylonsLLCAddress)
			coinsCBOwnerBefore := tci.PlnK.CoinKeeper.GetCoins(tci.Ctx, cookbook.Sender)

			_, err = HandlerMsgSendItems(tci.Ctx, tci.PlnK, msg)

			coinsSenderAfter := tci.PlnK.CoinKeeper.GetCoins(tci.Ctx, tc.fromAddress)
			coinsPylonsLLCAfter := tci.PlnK.CoinKeeper.GetCoins(tci.Ctx, pylonsLLCAddress)
			coinsCBOwnerAfter := tci.PlnK.CoinKeeper.GetCoins(tci.Ctx, cookbook.Sender)

			if !tc.showError {
				for _, itemID := range tc.itemIDs {
					item, err := tci.PlnK.GetItem(tci.Ctx, itemID)
					require.True(t, err == nil)
					require.True(t, item.Sender.String() == tc.toAddress.String())
				}

				differSender := coinsSenderBefore.AmountOf(types.Pylon).Int64() - coinsSenderAfter.AmountOf(types.Pylon).Int64()
				differPylonsLLC := coinsPylonsLLCAfter.AmountOf(types.Pylon).Int64() - coinsPylonsLLCBefore.AmountOf(types.Pylon).Int64()
				differCBOwner := coinsCBOwnerAfter.AmountOf(types.Pylon).Int64() - coinsCBOwnerBefore.AmountOf(types.Pylon).Int64()

				require.True(t, differSender == tc.differSender)
				require.True(t, differPylonsLLC == tc.differPylonsLLC)
				require.True(t, differCBOwner == tc.differCBOwner)
			} else {
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			}
		})
	}
}
