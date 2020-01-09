package fixtureTest

import (
	"os"
	"path/filepath"

	originT "testing"

	testing "github.com/MikeSofaer/pylons/cmd/fixtures_test/evtesting"
)

func TestFixturesViaCLI(t *originT.T) {
	newT := testing.NewT(t)
	newT.AddEventListener("FAIL", func() {
		workQueueFailed = true
	})

	var files []string

	scenario_directory := "scenarios"
	err := filepath.Walk(scenario_directory, func(path string, info os.FileInfo, err error) error {
		files = append(files, path)
		return nil
	})
	if err != nil {
		t.Fatal(err)
	}
	for _, file := range files {
		if filepath.Ext(file) != ".json" {
			continue
		}
		t.Log("Running scenario path=", file)
		RunSingleFixtureTest(file, &newT)
	}
}
