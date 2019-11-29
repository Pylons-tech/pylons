package fixtureTest

import (
	"testing"

	intTest "github.com/MikeSofaer/pylons/cmd/test"
)

type Status int

const (
	NOT_STARTED = iota
	IN_PROGRESS
	DONE
)

type FixtureTestQueueItem struct {
	fixtureFileName string
	idx             int
	stepID          string
	status          Status // NOT_STARTED | IN_PROGRESS | DONE
}

var workQueues []FixtureTestQueueItem

func GetQueueID(file string, idx int, stepID string) int {
	for i, work := range workQueues {
		if work.fixtureFileName == file && work.stepID == stepID {
			return i
		}
	}
	return -1
}

func GoodToGoForStep(file string, idx int, step FixtureStep, t *testing.T) bool {
	for _, condition := range step.RunAfter.PreCondition {
		queID := GetQueueID(file, idx, condition)
		if queID == -1 {
			t.Fatal("No WorkQueue found from specified param ID=", condition, "idx=", idx, "file=", file, workQueues)
		}
		work := workQueues[queID]
		if work.status != DONE {
			return false
		}
	}
	return true
}

func UpdateWorkQueueStatus(file string, idx int, step FixtureStep, targetStatus Status, t *testing.T) {
	queID := GetQueueID(file, idx, step.ID)
	if queID == -1 {
		t.Fatal("No WorkQueue found from specified param ID=", step.ID, "idx=", idx, "file=", file, workQueues)
	}
	workQueues[queID].status = targetStatus
}

func WaitForCondition(file string, idx int, step FixtureStep, t *testing.T) {
	if GoodToGoForStep(file, idx, step, t) {
		intTest.WaitForBlockInterval(step.RunAfter.BlockWait)
	} else {
		intTest.WaitForNextBlock()
		WaitForCondition(file, idx, step, t)
	}
}
