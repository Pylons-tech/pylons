package fixtureTest

import (
	"testing"
)

func TestFixturesViaCLI(t *testing.T) {
	RunTestScenarios("scenarios", t)
}
