package fixturetest

import (
	"flag"
	"strings"
	"testing"

	fixturetestSDK "github.com/Pylons-tech/pylons/test/fixture_utils"
)

var scenarios = ""
var accounts = ""

func init() {
	flag.StringVar(&scenarios, "scenarios", "", "custom scenario file names")
	flag.StringVar(&accounts, "accounts", "", "custom account names")
}

func TestFixtures(t *testing.T) {
	flag.Parse()
	fixturetestSDK.FixtureTestOpts.IsParallel = false
	fixturetestSDK.FixtureTestOpts.BaseDirectory = "../../cmd/fixtures_test"

	fixturetestSDK.RegisterDefaultActionRunners()
	// Register custom action runners
	// fixturetestSDK.RegisterActionRunner("custom_action", CustomActionRunner)
	scenarioFileNames := []string{}
	if len(scenarios) > 0 {
		scenarioFileNames = strings.Split(scenarios, ",")
	}
	fixturetestSDK.FixtureTestOpts.AccountNames = []string{}
	if len(accounts) > 0 {
		fixturetestSDK.FixtureTestOpts.AccountNames = strings.Split(accounts, ",")
	}
	fixturetestSDK.RunTestScenarios("scenarios", scenarioFileNames, t)
}
