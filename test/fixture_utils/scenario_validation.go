package fixturetest

import (
	"sync"

	testing "github.com/Pylons-tech/pylons_sdk/cmd/evtesting"
)

// Algorithm link geeksforgeeks.org/detect-cycle-in-a-graph/

// DependencyGraph is a struct to manage dependency graph
type DependencyGraph struct {
	VMap      map[string]int
	VMapMutex sync.Mutex
	NV        int
	adj       [][]int
}

var g = DependencyGraph{
	VMap:      make(map[string]int), // StepID to GraphID mapper
	VMapMutex: sync.Mutex{},
	NV:        0, // Number of steps
}

// AddVertice is to convert string to into for circular check algorithm
func (g *DependencyGraph) AddVertice(VSID string) bool {
	if _, ok := g.VMap[VSID]; !ok {
		g.VMap[VSID] = g.NV
		if g.NV == 0 {
			g.adj = make([][]int, 1)
			g.adj[0] = make([]int, 0)
		} else {
			g.adj = append(g.adj, make([]int, 0))
		}
		g.NV = g.NV + 1
		return true
	}
	return false
}

// AddEdge function is to add an edge to graph
func (g *DependencyGraph) AddEdge(VSID, WSID string) bool {
	if _, ok := g.VMap[VSID]; !ok {
		return false
	}
	if _, ok := g.VMap[WSID]; !ok {
		return false
	}
	v := g.VMap[VSID]
	w := g.VMap[WSID]

	g.adj[v] = append(g.adj[v], w)

	return true
}

// isCyclicUtil function is a variation of DFSUtil() in https://www.geeksforgeeks.org/archives/18212
func (g *DependencyGraph) isCyclicUtil(v int, visited []bool, recStack []bool) bool {
	if !visited[v] {
		// Mark the current node as visited and part of recursion stack
		visited[v] = true
		recStack[v] = true

		// Recur for all the vertices adjacent to this vertex
		for _, w := range g.adj[v] {
			if !visited[w] && g.isCyclicUtil(w, visited, recStack) {
				return true
			} else if recStack[w] {
				return true
			}
		}

	}
	recStack[v] = false // remove the vertex from recursion stack
	return false
}

// IsCyclic function is a variation of DFS() in https://www.geeksforgeeks.org/archives/18212
// Returns true if the graph contains a cycle, else false.
func (g *DependencyGraph) IsCyclic() bool {
	// Mark all the vertices as not visited and not part of recursion
	// stack

	var visited []bool
	var recStack []bool

	for i := 0; i < g.NV; i++ {
		visited = append(visited, false)
		recStack = append(recStack, false)
	}

	// Call the recursive helper function to detect cycle in different
	// DFS trees
	for i := 0; i < g.NV; i++ {
		if g.isCyclicUtil(i, visited, recStack) {
			return true
		}
	}

	return false
}

// CheckSteps checks cylic dependency of steps
func CheckSteps(steps []FixtureStep, t *testing.T) {
	g.VMapMutex.Lock()
	defer g.VMapMutex.Unlock()
	for _, step := range steps {
		if len(step.ID) == 0 {
			t.Fatal("please add ID field for all steps")
		}
		if ok := g.AddVertice(step.ID); !ok {
			t.WithFields(testing.Fields{
				"stepID": step.ID,
			}).Fatal("same stepID is available")
		}
	}
	for _, step := range steps {
		for _, pd := range step.RunAfter.PreCondition {
			if ok := g.AddEdge(pd, step.ID); !ok {
				t.WithFields(testing.Fields{
					"precondition": pd,
				}).Fatal("ID is not available which is referring to.")
			}
		}
	}
	if g.IsCyclic() {
		t.Fatal("cyclic dependency is available")
	}
}
