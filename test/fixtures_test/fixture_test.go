package fixturetest

import (
	"flag"
	"strings"
	"testing"

	fixturetestSDK "github.com/Pylons-tech/pylons/test/fixture_utils"
)

var scenarios = ""

func init() {
	flag.StringVar(&scenarios, "scenarios", "", "custom scenario file names")
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
	fixturetestSDK.FixtureTestOpts.AccountNames = []string{"genesis1", "genesis2", "genesis3", "genesis4"}
	fixturetestSDK.RunTestScenarios("scenarios", scenarioFileNames, t)
}
