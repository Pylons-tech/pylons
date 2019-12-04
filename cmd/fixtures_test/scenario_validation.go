package fixtureTest

// Algorithm link geeksforgeeks.org/detect-cycle-in-a-graph/

var VMap map[string]int  // StepID to GraphID mapper
var NV = 0					// Number of steps
var adj [][]int 					// array containing adjacency lists 

// This is to convert string to into for circular check algorithm
func AddVertice(VID string) int {
	// TODO check if it is not defined ID
	VMap[VID] = NV
	NV = NV + 1
}

func AddEdge(VID, WID string) {
	// TODO check if it is not defined ID
	v := VMap[VID]
	w := VMap[WID]
	adj[v] = append(adj[v], w)
}

// This function is a variation of DFSUtil() in https://www.geeksforgeeks.org/archives/18212 
func isCyclicUtil(v int, visited []bool, recStack []bool) bool {
    if visited[v] == false { 
        // Mark the current node as visited and part of recursion stack 
        visited[v] = true
        recStack[v] = true
  
        // Recur for all the vertices adjacent to this vertex 
        for _, w range adj[v] {
            if ( !visited[w] && isCyclicUtil(w, visited, recStack) ) 
                return true; 
            else if (recStack[w])
                return true; 
		}
  
    } 
    recStack[v] = false  // remove the vertex from recursion stack 
    return false
}

// Returns true if the graph contains a cycle, else false. 
// This function is a variation of DFS() in https://www.geeksforgeeks.org/archives/18212 
func IsCyclic() bool {
    // Mark all the vertices as not visited and not part of recursion 
	// stack 
	
    bool *visited = new bool[V]; 
    bool *recStack = new bool[V]; 
    for(int i = 0; i < V; i++) 
    { 
        visited[i] = false; 
        recStack[i] = false; 
    } 
  
    // Call the recursive helper function to detect cycle in different 
    // DFS trees 
    for(int i = 0; i < V; i++) 
        if (isCyclicUtil(i, visited, recStack)) 
            return true; 
  
    return false; 
}

func InitGraph() {
    // Create a graph from fixture steps
    // Graph g(4)
    // g.addEdge(0, 1)
    // g.addEdge(0, 2)
    // g.addEdge(1, 2)
    // g.addEdge(2, 0)
    // g.addEdge(2, 3)
    // g.addEdge(3, 3)
  
    // if(g.isCyclic()) 
    //     t.Log "Graph contains cycle"
    // else
    //     t.Log "Graph doesn't contain cycle"
    // return 0
}
