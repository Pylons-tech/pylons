package fixtureTest

import (
	testing "github.com/Pylons-tech/pylons/cmd/fixtures_test/evtesting"
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
var workQueueFailed = false

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

func UpdateWorkQueueStatus(file string, idx int, fixtureSteps []FixtureStep, targetStatus Status, t *testing.T) {
	step := fixtureSteps[idx]
	queID := GetQueueID(file, idx, step.ID)
	if queID == -1 {
		t.Fatal("No WorkQueue found from specified param ID=", step.ID, "idx=", idx, "file=", file, workQueues)
	}
	switch targetStatus {
	case IN_PROGRESS:
		if GoodToGoForStep(file, idx, step, t) { // status can move forward only when previous condtions are met
			workQueues[queID].status = IN_PROGRESS
			ProcessSingleFixtureQueueItem(file, idx, fixtureSteps, t)
		}
	case DONE:
		workQueues[queID].status = DONE
		for sidx, sstep := range fixtureSteps {
			squeID := GetQueueID(file, sidx, sstep.ID)
			if workQueues[squeID].status == NOT_STARTED {
				UpdateWorkQueueStatus(file, sidx, fixtureSteps, IN_PROGRESS, t)
			}
		}
	}
}