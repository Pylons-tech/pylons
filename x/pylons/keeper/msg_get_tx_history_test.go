package keeper_test

import (
	"github.com/Pylons-tech/pylons/x/pylons/keeper"
	"github.com/Pylons-tech/pylons/x/pylons/types/v1beta1"
	sdkTypes "github.com/cosmos/cosmos-sdk/types"
)

func (suite *IntegrationTestSuite) TestGetTxHistorySuccess() {
	block := []*sdkTypes.TxResponse{
		{
			Logs: sdkTypes.ABCIMessageLogs{
				{
					Events: sdkTypes.StringEvents{
						sdkTypes.StringEvent{
							Type: v1beta1.CreateItemKey,
							Attributes: []sdkTypes.Attribute{
								{
									Key:   v1beta1.KeyAmount,
									Value: COMMON_AMOUNT,
								},
								{
									Key:   v1beta1.KeyCookbookID,
									Value: COMMON_COOKBOOKID,
								},
								{
									Key:   v1beta1.KeyRecipeID,
									Value: COMMON_RECIPEID,
								},
								{
									Key:   v1beta1.KeyReceiver,
									Value: COMMON_RECIPEID,
								},
								{
									Key:   v1beta1.KeySender,
									Value: COMMON_SENDER,
								},
							},
						},
						sdkTypes.StringEvent{
							Type: v1beta1.TransferEventKey,
							Attributes: []sdkTypes.Attribute{
								{
									Key:   v1beta1.KeyAmount,
									Value: COMMON_AMOUNT,
								},
								{
									Key:   v1beta1.KeySender,
									Value: COMMON_SENDER,
								},
								{
									Key:   v1beta1.KeyRecipient,
									Value: COMMON_RECIPIENT,
								},
							},
						},
					},
				},
			},
		},
	}
	userHistory := keeper.QueryEventSender(block)
	suite.Require().Equal(1, len(userHistory))
	userHistory = keeper.QueryEventRecipientBank(block)
	suite.Require().Equal(1, len(userHistory))
	userHistory = keeper.QueryEventNFTSell(block)
	suite.Require().Equal(1, len(userHistory))
}

func (suite *IntegrationTestSuite) TestGetTxHistoryWithoutNFT() {
	block := []*sdkTypes.TxResponse{
		{
			Logs: sdkTypes.ABCIMessageLogs{
				{
					Events: sdkTypes.StringEvents{
						sdkTypes.StringEvent{
							Type: v1beta1.TransferEventKey,
							Attributes: []sdkTypes.Attribute{
								{
									Key:   v1beta1.KeyAmount,
									Value: COMMON_AMOUNT,
								},
								{
									Key:   v1beta1.KeySender,
									Value: COMMON_SENDER,
								},
								{
									Key:   v1beta1.KeyRecipient,
									Value: COMMON_RECIPIENT,
								},
							},
						},
					},
				},
			},
		},
	}
	userHistory := keeper.QueryEventSender(block)
	suite.Require().Equal(1, len(userHistory))
	userHistory = keeper.QueryEventRecipientBank(block)
	suite.Require().Equal(1, len(userHistory))
	userHistory = keeper.QueryEventNFTSell(block)
	suite.Require().Equal(0, len(userHistory))
}

func (suite *IntegrationTestSuite) TestGetTxHistoryNoRecordFound() {
	block := []*sdkTypes.TxResponse{
		{
			Logs: sdkTypes.ABCIMessageLogs{
				{
					Events: sdkTypes.StringEvents{},
				},
			},
		},
	}
	userHistory := keeper.QueryEventSender(block)
	suite.Require().Equal(0, len(userHistory))
	userHistory = keeper.QueryEventRecipientBank(block)
	suite.Require().Equal(0, len(userHistory))
	userHistory = keeper.QueryEventNFTSell(block)
	suite.Require().Equal(0, len(userHistory))
}
