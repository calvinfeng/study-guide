# Dijkstra's Algorithm
Dijkstra's algorithm is an algorithm for finding minimum distance between any
two vertices on an directed weighted graph. The algorithm starts with initializing
two data variable, a `considered_paths`/`locked_in_paths` that holds the minimum
cost to each node from a source, a `frontiers` to hold nodes that are going
to be considered/checked.

The `frontiers` is usually implemented with a priority queue because through
each iteration, we are only looking at node that has the lowest cost to reach
to. An extract from a priority queue implemented with MinHeap will serve this
purpose well.

We start by putting source into the frontiers, and iterate while the frontier
queue is not empty. Every time we extract node from the queue, we check its neighbors
to update their path cost and put them in queue. Once finished checking, the node
will go into the `considered_paths`/`locked_in_paths` and indicate that
it's been visited. Once all nodes have been visited, the computation is finished.
Return the `locked_in_paths`.

## Implementation
This is the algorithm, using `frontiers` as a queue and extract elements
in every round of iteration. This implementation did not use __PriorityQueue__,
it used hash map for frontiers for the sake of simplicity.
``` ruby
def dijkstra(source)
  considered_paths = {}
  frontiers = {
    source => {cost: 0, last_edge: nil}
  }
  until frontiers.empty?
    vertex = select_frontier(frontiers)
    considered_paths[vertex] = frontiers[vertex]
    frontiers.delete(vertex)
    update_frontiers(vertex, considered_paths, frontiers)
  end
  considered_paths
end
```
For the lack of __PriorityQueue__, one must iterate through the hash through
enumerable method and find the vertex with minimum cost. This is O(|V|) time.
``` ruby
def select_frontier(frontiers)
  vertex, data = frontiers.min_by do |vertex, data|
    data[:cost]
  end
  vertex
end
```
This will look at a vertex's out going edges and find the reachable vertices.
`extended_path_cost` is the cost to reach to vertex plus the cost of the edge
to reach a neighbor. For example, we are looking at vertex A, and vertex B is
A's neighbor. If the cost to reach B from A is lower than any other path, the
path cost will be updated and B will go into the queue. But if B is already
in the queue, and the cost to reach B is lower through other vertices, do nothing
and move on.
``` ruby
def update_frontiers(vertex, considered_paths, frontiers)
  path_to_vertex_cost = considered_paths[vertex][:cost]
  vertex.out_edges.each do |edge|
    neighbor = edge.to_vertex
    next if considered_paths.has_key?(neighbor)
    extended_path_cost = path_to_vertex_cost + edge.cost
    if frontiers.has_key?(neighbor) && frontiers[neighbor][:cost] <= extended_path_cost
      next
    else
      frontiers[neighbor] = {cost: extended_path_cost, last_edge: edge}
    end
  end
end
```

## Example
Notes
* __yellow__: frontiers
* __gray__: locked_in nodes

![example][dijkstra]
[dijkstra]: ./img/dijkstra.png
Here are the steps
1. `frontiers` => {A: 0}
2. `frontiers` => {B: 2, C: 5}, `locked` => {A: 0}
  * Pick out `B` from frontiers and check its neighbors
3. `frontiers` => {C: 5, D: 7, E: 12}, `locked` => {A: 0, B: 2}
  * Pick out `C` from frontiers and check its neighbors
4. `frontiers` => {D: 7, E: 12}, `locked` => {A: 0, B: 2, C: 5}
  * Pick out `D` from frontiers and check its neighbors
  * Update `E` because it is cheaper to reach E from A -> B -> D -> E than
  from A -> B -> E
5. `frontiers` => {E: 10}, `locked` => {A: 0, B: 2, C: 5, D: 7}
  * Take `E` out and there is no neighbors, iteration ends
6. Final result {A: 0, B: 2, C: 5, D: 7, E: 10}
