package fixtureTest

import (
	"flag"
	"testing"

	intTest "github.com/Pylons-tech/pylons/cmd/test"
)

var runSerialMode bool = false
var useRest bool = false

func init() {
	flag.BoolVar(&runSerialMode, "runserial", false, "true/false value to check if test will be running in parallel")
	flag.BoolVar(&useRest, "userest", false, "use rest endpoint for Tx send")
}

func TestFixturesViaCLI(t *testing.T) {
	flag.Parse()
	FixtureTestOpts.IsParallel = !runSerialMode
	if useRest {
		intTest.CLIOpts.RestEndpoint = "http://localhost:1317"
	}
	RunTestScenarios("scenarios", t)
}
