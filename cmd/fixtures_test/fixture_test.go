package fixtureTest

import (
	"testing"
)

func TestFixturesViaCLI(t *testing.T) {
	// FixtureTestOpts.IsParallel = false
	RunTestScenarios("scenarios", t)
}
