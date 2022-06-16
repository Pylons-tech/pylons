package keeper_test

import (
	"github.com/Pylons-tech/pylons/x/pylons/keeper"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdkTypes "github.com/cosmos/cosmos-sdk/types"
)

func (suite *IntegrationTestSuite) TestGetTxHistorySuccess() {
	block := []*sdkTypes.TxResponse{
		{
			Logs: sdkTypes.ABCIMessageLogs{
				{
					Events: sdkTypes.StringEvents{
						sdkTypes.StringEvent{
							Type: types.CreateItemKey,
							Attributes: []sdkTypes.Attribute{
								{
									Key:   types.KeyAmount,
									Value: COMMON_AMOUNT,
								},
								{
									Key:   types.KeyCookbookID,
									Value: COMMON_COOKBOOKID,
								},
								{
									Key:   types.KeyRecipeID,
									Value: COMMON_RECIPEID,
								},
								{
									Key:   types.KeyReceiver,
									Value: COMMON_RECIPEID,
								},
								{
									Key:   types.KeySender,
									Value: COMMON_SENDER,
								},
							},
						},
						sdkTypes.StringEvent{
							Type: types.TransferEventKey,
							Attributes: []sdkTypes.Attribute{
								{
									Key:   types.KeyAmount,
									Value: COMMON_AMOUNT,
								},
								{
									Key:   types.KeySender,
									Value: COMMON_SENDER,
								},
								{
									Key:   types.KeyRecipient,
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
							Type: types.TransferEventKey,
							Attributes: []sdkTypes.Attribute{
								{
									Key:   types.KeyAmount,
									Value: COMMON_AMOUNT,
								},
								{
									Key:   types.KeySender,
									Value: COMMON_SENDER,
								},
								{
									Key:   types.KeyRecipient,
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
