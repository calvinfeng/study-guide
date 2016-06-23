# Topological Sort & Directed Graphs

## Directed Graphs API
* `#initialize(num_of_vertices)` - create an empty diagraph with numbers of
vertices
* `#addEdge(v, w)` - connect two nodes/vertices together with direction,
from v -> w
* `#adjList(v)` - return vertices pointing from v
* `#v_count` - return number of vertices
* `#e_count` - return number of edges

## DFS Topological Sort
Coming soon...

## Kahn's Algorithm
A zero degree vertex is a vertex that has no dependency. It's like taking
classes in college. If a course has no pre-requisite, it has zero degree of
dependency. The algorithm works by calculating the number of dependency for
every single vertex and store them in a hash map. If a vertex/node has no
dependency, it gets push into the queue.

Once the queue starts running, every "completed" or visited node will get
push into the sorted list, as a way of saying we will complete these tasks
first. Then the algorithm looks at the out edges of the node and decrement
their dependency because we have completed one pre-requisite, so one less
requirement/dependency. Repeat the process and eventually everything will
be sorted topologically.

``` ruby
def topological_sort(vertices)
  sorted_vertices = []
  zero_in_degree_queue = []
  in_edge_count = Hash.new

  # O(|V|)
  vertices.each do |vertex|
    in_edge_count[vertex] = vertex.in_edges.length
    if vertex.in_edges.length == 0
      zero_in_degree_queue << vertex
    end
  end

  # O(|V| + |E|)
  # goes through all the nodes and edges
  while zero_in_degree_queue.length > 0
    node = zero_in_degree_queue.shift
    node.out_edges.each do |edge|
      neighbor = edge.to_vertex
      # edge.destroy!
      in_edge_count[neighbor] -= 1
      if in_edge_count[neighbor] == 0
        zero_in_degree_queue << neighbor
      end
    end
    sorted_vertices << node
  end
  sorted_vertices
end
```
## Strongly Connected
The idea of strongly connected component is unique to digraphs. A single
directed connection between two vertices is not enough to constitute a
strong connection, that makes a connection (or connected component) but not
a strongly connected component

Definition: *v* and *w* are strongly connected if there is a directed path
from *v* to *v* and a directed path

![strongly_connected][scc]
[scc]: ../img/strongly_connected.png

A-B-C are strongly connected components because A can get to B, B can get to A, B can get to C and C can get to B, and etc...

However, A-B-C can get to D-E-F-G but D-E-F-G can't get back to A-B-C so they are not strongly connected.

## Kosaraju-Sharir Algorithm
* Reverse graph: strong components in G are the same as in G reversed
* Kernal DAG: contract each strong component into a single vertex
* Idea:
  * compute topological order (reverse postorder) in kernel DAG
  * run DFS, considering vertices in reverse topological order

Phase 1: run DFS on reversed G to compute reverse postorder

Phase 2: run DFS on original G, considering vertices in order given by
first DFS from Phase 1.
