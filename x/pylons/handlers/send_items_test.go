package handlers

import (
	"fmt"
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
	tci.PlnH = NewMsgServerImpl(tci.PlnK)

	sender1, sender2, sender3, _ := keep.SetupTestAccounts(t, tci, types.NewPylon(10000000), types.NewPylon(10000000), types.NewPylon(10), nil)

	require.True(t, keep.HasCoins(tci.PlnK, tci.Ctx, sender1, types.NewPylon(10000000)))
	require.True(t, keep.HasCoins(tci.PlnK, tci.Ctx, sender2, types.NewPylon(10000000)))
	cbData := MockCookbook(tci, sender1)
	cookbook, err := tci.PlnK.GetCookbook(tci.Ctx, cbData.CookbookID)
	require.NoError(t, err)

	item1 := keep.GenItem(cbData.CookbookID, sender1, "sword")
	item2 := keep.GenItem(cbData.CookbookID, sender1, "axe")
	item3 := keep.GenItem(cbData.CookbookID, sender2, "spear")
	item4 := keep.GenItem(cbData.CookbookID, sender2, "bow")
	item5 := keep.GenItem(cbData.CookbookID, sender3, "bow1")
	item6 := keep.GenItem(cbData.CookbookID, sender2, "bow2")
	item7 := keep.GenItem(cbData.CookbookID, sender2, "bow3")
	item8 := keep.GenItem(cbData.CookbookID, sender1, "bow4")

	item2.OwnerRecipeID = "????????"
	item8.OwnerTradeID = "????????"

	item3.SetTransferFee(1000)
	item4.SetTransferFee(1000)
	item5.SetTransferFee(300)

	item6.SetTransferFee(642)
	item7.SetTransferFee(1187)

	err = tci.PlnK.SetItem(tci.Ctx, item1)
	require.NoError(t, err)

	err = tci.PlnK.SetItem(tci.Ctx, item2)
	require.NoError(t, err)

	err = tci.PlnK.SetItem(tci.Ctx, item3)
	require.NoError(t, err)

	err = tci.PlnK.SetItem(tci.Ctx, item4)
	require.NoError(t, err)

	err = tci.PlnK.SetItem(tci.Ctx, item5)
	require.NoError(t, err)

	err = tci.PlnK.SetItem(tci.Ctx, item6)
	require.NoError(t, err)

	err = tci.PlnK.SetItem(tci.Ctx, item7)
	require.NoError(t, err)

	err = tci.PlnK.SetItem(tci.Ctx, item8)
	require.NoError(t, err)

	cases := map[string]struct {
		itemIDs         []string
		fromAddress     sdk.AccAddress
		toAddress       sdk.AccAddress
		desiredError    string
		showError       bool
		differSender    int64
		differCBOwner   int64
		differPylonsLLC int64
	}{
		"successful check": {
			itemIDs:         []string{item3.ID, item4.ID},
			fromAddress:     sender2,
			toAddress:       sender1,
			desiredError:    "",
			showError:       false,
			differSender:    2000, // differSender = item6.TransferFee + item7.TransferFee = 1000 + 1000 = 2000
			differCBOwner:   1800, // differCBOwner = 1000 * 0.9 + 1000 * 0.9 = 1800
			differPylonsLLC: 200,  // differPylonsLLC = differSender - differCBOwner = 2000 - 1800 = 200
		},
		"non divide fully case successful check": {
			itemIDs:         []string{item6.ID, item7.ID},
			fromAddress:     sender2,
			toAddress:       sender1,
			desiredError:    "",
			showError:       false,
			differSender:    1829, // differSender = item6.TransferFee + item7.TransferFee = 642 + 1187 = 1829
			differCBOwner:   1645, // differCBOwner = 642 * 0.9 + 1187 * 0.9 = 577 + 1068 = 1645
			differPylonsLLC: 184,  // differPylonsLLC = differSender - differCBOwner = 1829 - 1645 = 184
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
		"owner trade id check": {
			itemIDs:         []string{item8.ID},
			fromAddress:     sender1,
			toAddress:       sender2,
			desiredError:    "Item is owned by a trade",
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

			require.NoError(t, err)

			coinsSenderBefore := tci.PlnK.CoinKeeper.GetAllBalances(tci.Ctx, tc.fromAddress)
			coinsPylonsLLCBefore := tci.PlnK.CoinKeeper.GetAllBalances(tci.Ctx, pylonsLLCAddress)
			coinsCBOwnerBefore := tci.PlnK.CoinKeeper.GetAllBalances(tci.Ctx, cookbook.Sender)

			_, err = tci.PlnH.SendItems(sdk.WrapSDKContext(tci.Ctx), &msg)

			coinsSenderAfter := tci.PlnK.CoinKeeper.GetAllBalances(tci.Ctx, tc.fromAddress)
			coinsPylonsLLCAfter := tci.PlnK.CoinKeeper.GetAllBalances(tci.Ctx, pylonsLLCAddress)
			coinsCBOwnerAfter := tci.PlnK.CoinKeeper.GetAllBalances(tci.Ctx, cookbook.Sender)

			if !tc.showError {
				for _, itemID := range tc.itemIDs {
					item, err := tci.PlnK.GetItem(tci.Ctx, itemID)
					require.NoError(t, err)
					require.True(t, item.Sender == tc.toAddress.String())
				}

				differSender := coinsSenderBefore.AmountOf(types.Pylon).Int64() - coinsSenderAfter.AmountOf(types.Pylon).Int64()
				differPylonsLLC := coinsPylonsLLCAfter.AmountOf(types.Pylon).Int64() - coinsPylonsLLCBefore.AmountOf(types.Pylon).Int64()
				differCBOwner := coinsCBOwnerAfter.AmountOf(types.Pylon).Int64() - coinsCBOwnerBefore.AmountOf(types.Pylon).Int64()

				require.True(t, differSender == tc.differSender, fmt.Sprintln(differSender, "!=", tc.differSender))
				require.True(t, differPylonsLLC == tc.differPylonsLLC, fmt.Sprintln(differPylonsLLC, "!=", tc.differPylonsLLC))
				require.True(t, differCBOwner == tc.differCBOwner, fmt.Sprintln(differCBOwner, "!=", tc.differCBOwner))
			} else {
				require.True(t, err != nil)
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			}
		})
	}
}
