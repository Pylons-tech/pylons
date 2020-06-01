package fixtureTest

import (
	"flag"
	"testing"

	fixtureTestSDK "github.com/Pylons-tech/pylons_sdk/cmd/fixtures_test"
	intTestSDK "github.com/Pylons-tech/pylons_sdk/cmd/test"
)

var runSerialMode bool = false
var useRest bool = false

func init() {
	flag.BoolVar(&runSerialMode, "runserial", false, "true/false value to check if test will be running in parallel")
	flag.BoolVar(&useRest, "userest", false, "use rest endpoint for Tx send")
}

func TestFixturesViaCLI(t *testing.T) {
	flag.Parse()
	fixtureTestSDK.FixtureTestOpts.CreateNewCookbook = true
	fixtureTestSDK.FixtureTestOpts.IsParallel = !runSerialMode
	if useRest {
		intTestSDK.CLIOpts.RestEndpoint = "http://localhost:1317"
	}
	fixtureTestSDK.RunTestScenarios("scenarios", t)
}
