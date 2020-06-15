package fixturetest

import (
	"flag"
	"testing"

	fixturetestSDK "github.com/Pylons-tech/pylons_sdk/cmd/fixtures_test"
	inttestSDK "github.com/Pylons-tech/pylons_sdk/cmd/test"
)

var runSerialMode bool = false
var useRest bool = false

func init() {
	flag.BoolVar(&runSerialMode, "runserial", false, "true/false value to check if test will be running in parallel")
	flag.BoolVar(&useRest, "userest", false, "use rest endpoint for Tx send")
}

func TestFixturesViaCLI(t *testing.T) {
	flag.Parse()
	fixturetestSDK.FixtureTestOpts.CreateNewCookbook = true
	fixturetestSDK.FixtureTestOpts.IsParallel = !runSerialMode
	if useRest {
		inttestSDK.CLIOpts.RestEndpoint = "http://localhost:1317"
	}
	inttestSDK.CLIOpts.MaxWaitBlock = 50
	fixturetestSDK.RegisterDefaultActionRunners()
	fixturetestSDK.RunTestScenarios("scenarios", t)
}
