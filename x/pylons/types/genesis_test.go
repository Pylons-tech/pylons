package types

import (
	fmt "fmt"
	"testing"

	"github.com/stretchr/testify/require"
)

func TestValidateGenesis(t *testing.T) {
	for _, tc := range []struct {
		desc string
		req  *GenesisState
		err  error
	}{
		{
			desc: "Valid 1",
			req:  DefaultGenesis(),
		},
		{
			desc: "Valid 2",
			req:  NetworkTestGenesis(),
		},
		{
			desc: "Duplicate index of Redeminfo",
			req: &GenesisState{
				RedeemInfoList: []RedeemInfo{
					{Id: "test"},
					{Id: "test"},
				},
			},
			err: fmt.Errorf("duplicated index for redeemInfo"),
		},
		{
			desc: "Duplicate index of Redeminqo",
			req: &GenesisState{
				PaymentInfoList: []PaymentInfo{
					{PurchaseId: "test"},
					{PurchaseId: "test"},
				},
			},
			err: fmt.Errorf("duplicated index for paymentInfo"),
		},
		{
			desc: "Duplicate account",
			req: &GenesisState{
				AccountList: []UserMap{
					{AccountAddr: "test"},
					{AccountAddr: "test"},
					{Username: "test2"},
					{Username: "test3"},
				},
			},
			err: fmt.Errorf("duplicated account"),
		},
		{
			desc: "Duplicate username",
			req: &GenesisState{
				AccountList: []UserMap{
					{AccountAddr: "test2"},
					{AccountAddr: "test3"},
					{Username: "test"},
					{Username: "test"},
				},
			},
			err: fmt.Errorf("duplicated username" + ""),
		},
		{
			desc: "Duplicate id for trade",
			req: &GenesisState{
				TradeList: []Trade{
					{Id: uint64(1)},
					{Id: uint64(1)},
				},
			},
			err: fmt.Errorf("duplicated id for trade"),
		},
		{
			desc: "Duplicate purchaseToken for googleInAppPurchaseOrder",
			req: &GenesisState{
				GoogleInAppPurchaseOrderList: []GoogleInAppPurchaseOrder{
					{PurchaseToken: "test"},
					{PurchaseToken: "test"},
				},
			},
			err: fmt.Errorf("duplicated purchaseToken for googleInAppPurchaseOrder"),
		},
		{
			desc: "Duplicate id for pending execution",
			req: &GenesisState{
				PendingExecutionList: []Execution{
					{Id: "test"},
					{Id: "test"},
				},
			},
			err: fmt.Errorf("duplicated id for pending execution"),
		},
		{
			desc: "Duplicate id for execution",
			req: &GenesisState{
				ExecutionList: []Execution{
					{Id: "test"},
					{Id: "test"},
				},
			},
			err: fmt.Errorf("duplicated id for execution"),
		},
		{
			desc: "Duplicate index for item",
			req: &GenesisState{
				ItemList: []Item{
					{Id: "test"},
					{Id: "test"},
				},
			},
			err: fmt.Errorf("duplicated index for item"),
		},
		{
			desc: "Duplicate index for recipe",
			req: &GenesisState{
				RecipeList: []Recipe{
					{Id: "test"},
					{Id: "test"},
				},
			},
			err: fmt.Errorf("duplicated index for recipe"),
		},
		{
			desc: "Duplicate index for cookbook",
			req: &GenesisState{
				CookbookList: []Cookbook{
					{Id: "test"},
					{Id: "test"},
				},
			},
			err: fmt.Errorf("duplicated index for cookbook"),
		},
	} {
		err := tc.req.Validate()
		if err != nil {
			require.ErrorContains(t, err, fmt.Sprintf("%v", tc.err))
		} else {
			require.NoError(t, tc.err)
		}
	}
}
