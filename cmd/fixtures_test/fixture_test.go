package fixturetest

import (
	"flag"
	"strings"
	"testing"

	fixturetestSDK "github.com/Pylons-tech/pylons_sdk/cmd/fixture_utils"
	inttestSDK "github.com/Pylons-tech/pylons_sdk/cmd/test_utils"
)

var runSerialMode = false
var useRest = false
var useKnownCookbook = false
var verifyOnly = false
var scenarios = ""
var accounts = ""

func init() {
	flag.BoolVar(&runSerialMode, "runserial", false, "true/false value to check if test will be running in parallel")
	flag.BoolVar(&useRest, "userest", false, "use rest endpoint for Tx send")
	flag.BoolVar(&useKnownCookbook, "use-known-cookbook", false, "use existing cookbook or not")
	flag.BoolVar(&verifyOnly, "verify-only", false, "use this flag to only verify")
	flag.StringVar(&scenarios, "scenarios", "", "custom scenario file names")
	flag.StringVar(&accounts, "accounts", "", "custom account names")
}

func TestFixturesViaCLI(t *testing.T) {
	flag.Parse()
	fixturetestSDK.FixtureTestOpts.IsParallel = !runSerialMode
	fixturetestSDK.FixtureTestOpts.CreateNewCookbook = !useKnownCookbook
	fixturetestSDK.FixtureTestOpts.VerifyOnly = verifyOnly
	if useRest {
		inttestSDK.CLIOpts.RestEndpoint = "http://localhost:1317"
	}
	inttestSDK.CLIOpts.MaxBroadcast = 5
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
