package fixtures

import (
	"encoding/json"
	"io/ioutil"
	"os"
	"testing"
)

func ReadFile(fileURL string, t *testing.T) []byte {
	jsonFile, err := os.Open(fileURL)
	if err != nil {
		t.Errorf("%+v", err)
	}
	t.Log("Successfully Opened", fileURL)

	defer jsonFile.Close()

	byteValue, _ := ioutil.ReadAll(jsonFile)
	return byteValue
}

func RunCreateCookbook(step FixtureStep) {
	if step.ParamsRef != "" {

	}
}
func TestFixturesViaCLI(t *testing.T) {

	var fixtureSteps []FixtureStep
	byteValue := ReadFile("scenario.json", t)
	json.Unmarshal([]byte(byteValue), &fixtureSteps)
	t.Log("read steps:", fixtureSteps)

	for _, step := range fixtureSteps {
		switch step.Action {
		case "create_cookbook":
			RunCreateCookbook(step)
		default:
			t.Errorf("step with unrecognizable action found %s", step.Action)
		}
	}
}
