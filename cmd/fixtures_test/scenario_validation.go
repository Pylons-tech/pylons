package fixtureTest

import (
	"sync"

	testing "github.com/MikeSofaer/pylons/cmd/fixtures_test/evtesting"
)

// Algorithm link geeksforgeeks.org/detect-cycle-in-a-graph/

var VMap map[string]int = make(map[string]int) // StepID to GraphID mapper
var VMapMutex = sync.Mutex{}
var NV = 0 // Number of steps
var adj [][]int

// This is to convert string to into for circular check algorithm
func AddVertice(VSID string) bool {
	if _, ok := VMap[VSID]; !ok {
		VMap[VSID] = NV
		if NV == 0 {
			adj = make([][]int, 1)
			adj[0] = make([]int, 0)
		} else {
			adj = append(adj, make([]int, 0))
		}
		NV = NV + 1
		return true
	}
	return false
}

func AddEdge(VSID, WSID string) bool {
	if _, ok := VMap[VSID]; !ok {
		return false
	}
	if _, ok := VMap[WSID]; !ok {
		return false
	}
	v := VMap[VSID]
	w := VMap[WSID]

	adj[v] = append(adj[v], w)

	return true
}

// This function is a variation of DFSUtil() in https://www.geeksforgeeks.org/archives/18212
func isCyclicUtil(v int, visited []bool, recStack []bool) bool {
	if visited[v] == false {
		// Mark the current node as visited and part of recursion stack
		visited[v] = true
		recStack[v] = true

		// Recur for all the vertices adjacent to this vertex
		for _, w := range adj[v] {
			if !visited[w] && isCyclicUtil(w, visited, recStack) {
				return true
			} else if recStack[w] {
				return true
			}
		}

	}
	recStack[v] = false // remove the vertex from recursion stack
	return false
}

// Returns true if the graph contains a cycle, else false.
// This function is a variation of DFS() in https://www.geeksforgeeks.org/archives/18212
func IsCyclic() bool {
	// Mark all the vertices as not visited and not part of recursion
	// stack

	var visited []bool
	var recStack []bool

	for i := 0; i < NV; i++ {
		visited = append(visited, false)
		recStack = append(recStack, false)
	}

	// Call the recursive helper function to detect cycle in different
	// DFS trees
	for i := 0; i < NV; i++ {
		if isCyclicUtil(i, visited, recStack) {
			return true
		}
	}

	return false
}

func CheckSteps(steps []FixtureStep, t *testing.T) {
	VMapMutex.Lock()
	for _, step := range steps {
		if len(step.ID) == 0 {
			t.Fatal("please add ID field for all steps")
		}
		if ok := AddVertice(step.ID); !ok {
			t.Fatal("same ID is available for stepID=", step.ID)
		}
	}
	for _, step := range steps {
		for _, pd := range step.RunAfter.PreCondition {
			if ok := AddEdge(pd, step.ID); !ok {
				t.Fatal("ID is not available which is refering as precondition pd=", pd)
			}
		}
	}
	VMapMutex.Unlock()
	if IsCyclic() {
		t.Fatal("cyclic dependency is available")
	}
}
