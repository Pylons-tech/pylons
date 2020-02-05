package fixtureTest

import (
	"flag"
	"testing"
)

var runSerialMode bool = false

func init() {
	flag.BoolVar(&runSerialMode, "runserial", false, "true/false value to check if test will be running in parallel")
}

func TestFixturesViaCLI(t *testing.T) {
	flag.Parse()
	FixtureTestOpts.IsParallel = !runSerialMode
	RunTestScenarios("scenarios", t)
}
