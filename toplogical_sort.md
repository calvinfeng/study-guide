# Topological Sort & Directed Graphs

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
