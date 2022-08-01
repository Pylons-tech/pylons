package v1beta1

import (
	"testing"

	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/stretchr/testify/require"
)

func TestValidateEmail(t *testing.T) {
	for _, tc := range []struct {
		desc  string
		email string
		err   error
	}{
		{desc: "ValidEmail", email: "test@email.valid"},
		{desc: "InvalidEmail1", email: "inv alid@test.email", err: ErrInvalidRequestField},
		{desc: "InvalidEmail2", email: "xyz", err: ErrInvalidRequestField},
		{desc: "InvalidEmail3", email: "inv&alid@test.email", err: ErrInvalidRequestField},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			err := ValidateEmail(tc.email)
			if tc.err != nil {
				require.ErrorIs(t, err, tc.err)
			} else {
				require.NoError(t, err)
			}
		})
	}
}

func TestValidateVersion(t *testing.T) {
	for _, tc := range []struct {
		desc    string
		version string
		err     error
	}{
		{desc: "ValidVersion", version: "v1.0.0"},
		{desc: "ValidVersion1", version: "v0.1.0-alpha"},
		{desc: "InvalidVersion1", version: "xyz", err: ErrInvalidRequestField},
		{desc: "InvalidVersion2", version: "1.0", err: ErrInvalidRequestField},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			err := ValidateVersion(tc.version)
			if tc.err != nil {
				require.ErrorIs(t, err, tc.err)
			} else {
				require.NoError(t, err)
			}
		})
	}
}

func TestValidateID(t *testing.T) {
	for _, tc := range []struct {
		desc string
		id   string
		err  error
	}{
		{desc: "ValidID", id: "test"},
		{desc: "ValidID1", id: "_test123test"},
		{desc: "InvalidID1", id: "1test", err: ErrInvalidRequestField},
		{desc: "InvalidID2", id: "test id", err: ErrInvalidRequestField},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			err := ValidateID(tc.id)
			if tc.err != nil {
				require.ErrorIs(t, err, tc.err)
			} else {
				require.NoError(t, err)
			}
		})
	}
}

func TestValidateUsername(t *testing.T) {
	cosmosAddr := GenTestBech32List(1)[0]

	for _, tc := range []struct {
		desc     string
		username string
		err      error
	}{
		{desc: "ValidUsername1", username: "UserName", err: nil},
		{desc: "ValidUsername2", username: "U_s_e_r_N_a_m_e", err: nil},
		{desc: "ValidUsername3", username: "A-B-C-D-E", err: nil},
		{desc: "ValidUsername4", username: "A-B_C-D_E", err: nil},
		{desc: "InvalidCosmosAddr", username: cosmosAddr, err: ErrInvalidRequestField},
		{desc: "InvalidHypens1", username: "__A", err: ErrInvalidRequestField},
		{desc: "InvalidHypens2", username: "A__", err: ErrInvalidRequestField},
		{desc: "InvalidHypens3", username: "a__b", err: ErrInvalidRequestField},
		{desc: "InvalidDash1", username: "--A", err: ErrInvalidRequestField},
		{desc: "InvalidDash2", username: "A--", err: ErrInvalidRequestField},
		{desc: "InvalidDash3", username: "a--b", err: ErrInvalidRequestField},
		{desc: "InvalidMixed1", username: "-_-A", err: ErrInvalidRequestField},
		{desc: "InvalidMixed2", username: "A-_", err: ErrInvalidRequestField},
		{desc: "InvalidMixed3", username: "a-_b", err: ErrInvalidRequestField},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			err := ValidateUsername(tc.username)
			if tc.err != nil {
				require.ErrorIs(t, err, tc.err)
			} else {
				require.NoError(t, err)
			}
		})
	}
}

func TestValidatePaymentInfo(t *testing.T) {
	for _, tc := range []struct {
		desc string
		obj  PaymentInfo
		err  error
	}{
		{desc: "Valid", obj: PaymentInfo{
			PurchaseId:    "test",
			ProcessorName: "test",
			PayerAddr:     GenTestBech32FromString("test"),
			Amount:        sdk.OneInt(),
			ProductId:     "test",
			Signature:     "test",
		}},
		{desc: "InvalidPurchaseID", obj: PaymentInfo{
			PurchaseId:    "",
			ProcessorName: "test",
			PayerAddr:     GenTestBech32FromString("test"),
			Amount:        sdk.OneInt(),
			ProductId:     "test",
			Signature:     "test",
		}, err: ErrInvalidRequestField},
		{desc: "InvalidProductID", obj: PaymentInfo{
			PurchaseId:    "test",
			ProcessorName: "test",
			PayerAddr:     GenTestBech32FromString("test"),
			Amount:        sdk.OneInt(),
			ProductId:     "",
			Signature:     "test",
		}, err: ErrInvalidRequestField},
		{desc: "InvalidSignature", obj: PaymentInfo{
			PurchaseId:    "test",
			ProcessorName: "test",
			PayerAddr:     GenTestBech32FromString("test"),
			Amount:        sdk.OneInt(),
			ProductId:     "test",
			Signature:     "",
		}, err: ErrInvalidRequestField},
		{desc: "InvalidAmount", obj: PaymentInfo{
			PurchaseId:    "test",
			ProcessorName: "test",
			PayerAddr:     GenTestBech32FromString("test"),
			Amount:        sdk.ZeroInt(),
			ProductId:     "test",
			Signature:     "test",
		}, err: ErrInvalidRequestField},
		{desc: "InvalidAddress", obj: PaymentInfo{
			PurchaseId:    "test",
			ProcessorName: "test",
			PayerAddr:     "test",
			Amount:        sdk.OneInt(),
			ProductId:     "test",
			Signature:     "test",
		}, err: ErrInvalidRequestField},
		{desc: "InvalidProcessorName", obj: PaymentInfo{
			PurchaseId:    "test",
			ProcessorName: "",
			PayerAddr:     GenTestBech32FromString("test"),
			Amount:        sdk.OneInt(),
			ProductId:     "test",
			Signature:     "test",
		}, err: ErrInvalidRequestField},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			err := ValidatePaymentInfo(tc.obj)
			if tc.err != nil {
				require.ErrorIs(t, err, tc.err)
			} else {
				require.NoError(t, err)
			}
		})
	}
}

func TestValidateRedeemInfo(t *testing.T) {
	for _, tc := range []struct {
		desc string
		obj  RedeemInfo
		err  error
	}{
		{desc: "Valid", obj: RedeemInfo{
			Id:            "test",
			ProcessorName: "test",
			Address:       GenTestBech32FromString("test"),
			Amount:        sdk.OneInt(),
			Signature:     "test",
		}},
		{desc: "InvalidID", obj: RedeemInfo{
			Id:            "",
			ProcessorName: "test",
			Address:       GenTestBech32FromString("test"),
			Amount:        sdk.OneInt(),
			Signature:     "test",
		}, err: ErrInvalidRequestField},
		{desc: "InvalidSignature", obj: RedeemInfo{
			Id:            "test",
			ProcessorName: "test",
			Address:       GenTestBech32FromString("test"),
			Amount:        sdk.OneInt(),
			Signature:     "",
		}, err: ErrInvalidRequestField},
		{desc: "InvalidAmount", obj: RedeemInfo{
			Id:            "test",
			ProcessorName: "test",
			Address:       GenTestBech32FromString("test"),
			Amount:        sdk.ZeroInt(),
			Signature:     "test",
		}, err: ErrInvalidRequestField},
		{desc: "InvalidAddress", obj: RedeemInfo{
			Id:            "test",
			ProcessorName: "test",
			Address:       "test",
			Amount:        sdk.OneInt(),
			Signature:     "test",
		}, err: ErrInvalidRequestField},
		{desc: "InvalidProcessorName", obj: RedeemInfo{
			Id:            "test",
			ProcessorName: "",
			Address:       GenTestBech32FromString("test"),
			Amount:        sdk.OneInt(),
			Signature:     "test",
		}, err: ErrInvalidRequestField},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			err := ValidateRedeemInfo(tc.obj)
			if tc.err != nil {
				require.ErrorIs(t, err, tc.err)
			} else {
				require.NoError(t, err)
			}
		})
	}
}
