package fixturetest

import (
	testing "github.com/Pylons-tech/pylons_sdk/cmd/evtesting"
	fixturetestSDK "github.com/Pylons-tech/pylons_sdk/cmd/fixture_utils"
)

// ActFunc describes the type of function used for action running test
type ActFunc func(fixturetestSDK.FixtureStep, *testing.T)

var actFuncs = make(map[string]ActFunc)

// RegisterActionRunner registers action runner function
func RegisterActionRunner(action string, fn ActFunc) {
	actFuncs[action] = fn
}

// GetActionRunner get registered action runner function
func GetActionRunner(action string) ActFunc {
	return actFuncs[action]
}

// RunActionRunner execute registered action runner function
func RunActionRunner(action string, step fixturetestSDK.FixtureStep, t *testing.T) {
	fn := GetActionRunner(action)
	t.WithFields(testing.Fields{
		"action": step.Action,
	}).MustTrue(fn != nil, "step with unrecognizable action found")
	fn(step, t)
}

// RegisterDefaultActionRunners register default test functions
func RegisterDefaultActionRunners() {
	RegisterActionRunner("create_account", RunCreateAccount)
	RegisterActionRunner("get_pylons", RunGetPylons)
	RegisterActionRunner("google_iap_get_pylons", RunGoogleIAPGetPylons)
	RegisterActionRunner("mock_account", RunMockAccount) // create account + get pylons
	RegisterActionRunner("send_coins", RunSendCoins)
	RegisterActionRunner("fiat_item", RunFiatItem)
	RegisterActionRunner("update_item_string", RunUpdateItemString)
	RegisterActionRunner("send_items", RunSendItems)
	RegisterActionRunner("create_cookbook", RunCreateCookbook)
	RegisterActionRunner("update_cookbook", RunUpdateCookbook)
	RegisterActionRunner("mock_cookbook", RunMockCookbook) // mock_account + create_cookbook
	RegisterActionRunner("create_recipe", RunCreateRecipe)
	RegisterActionRunner("update_recipe", RunUpdateRecipe)
	RegisterActionRunner("enable_recipe", RunEnableRecipe)
	RegisterActionRunner("disable_recipe", RunDisableRecipe)
	RegisterActionRunner("execute_recipe", RunExecuteRecipe)
	RegisterActionRunner("check_execution", RunCheckExecution)
	RegisterActionRunner("create_trade", RunCreateTrade)
	RegisterActionRunner("fulfill_trade", RunFulfillTrade)
	RegisterActionRunner("disable_trade", RunDisableTrade)
	RegisterActionRunner("enable_trade", RunEnableTrade)
	RegisterActionRunner("multi_msg_tx", RunMultiMsgTx)
}
