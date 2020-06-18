package fixturetest

import (
	"flag"
	"strings"
	"testing"

	fixturetestSDK "github.com/Pylons-tech/pylons_sdk/cmd/fixtures_test"
	inttestSDK "github.com/Pylons-tech/pylons_sdk/cmd/test"
)

var runSerialMode bool = false
var useRest bool = false
var useKnownCookbook = false
var scenarios = ""

func init() {
	flag.BoolVar(&runSerialMode, "runserial", false, "true/false value to check if test will be running in parallel")
	flag.BoolVar(&useRest, "userest", false, "use rest endpoint for Tx send")
	flag.BoolVar(&useKnownCookbook, "use-known-cookbook", false, "use existing cookbook or not")
	flag.StringVar(&scenarios, "scenarios", "", "custom scenario file names")
}

func TestFixturesViaCLI(t *testing.T) {
	flag.Parse()
	fixturetestSDK.FixtureTestOpts.IsParallel = !runSerialMode
	fixturetestSDK.FixtureTestOpts.CreateNewCookbook = !useKnownCookbook
	if useRest {
		inttestSDK.CLIOpts.RestEndpoint = "http://localhost:1317"
	}
	inttestSDK.CLIOpts.MaxBroadcast = 50
	fixturetestSDK.RegisterDefaultActionRunners()
	// Register custom action runners
	// fixturetestSDK.RegisterActionRunner("custom_action", CustomActionRunner)
	scenarioFileNames := []string{}
	if len(scenarios) > 0 {
		scenarioFileNames = strings.Split(scenarios, ",")
	}
	fixturetestSDK.RunTestScenarios("scenarios", scenarioFileNames, t)
}
