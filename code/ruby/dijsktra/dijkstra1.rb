require_relative 'graph'

# O(|V|**2 + |E|).
def dijkstra1(source)
  locked_in_paths = {}
  possible_paths = {
    source => {cost: 0, last_edge: nil}
  }
  # O(|V|) times, it considers all vertices
  until possible_paths.empty?
    # Find the vertex with minimum cost
    vertex = select_possible_path(possible_paths)
    locked_in_paths[vertex] = possible_paths[vertex]
    # Remove the current vertex from considerations
    possible_paths.delete(vertex)
    # Update the cost to reach other nodes
    update_possible_paths(vertex, locked_in_paths, possible_paths)
  end
  locked_in_paths
end

# O(|V|) times, it considers all the vertices
def select_possible_path(possible_paths)
  vertex, data = possible_paths.min_by do |vertex, data|
    data[:cost]
  end
  vertex
end

# O(|E|) times overall
def update_possible_paths(vertex, locked_in_paths, possible_paths)
  # vertex refers to the vertex that we are currently looking at
  path_to_vertex_cost = locked_in_paths[vertex][:cost]
  vertex.out_edges.each do | edge |
    neighbor = edge.to_vertex
    #Skip if we have already looked at the neighbor
    next if locked_in_paths.has_key?(neighbor)

    extended_path_cost = path_to_vertex_cost + edge.cost
    if possible_paths.has_key?(neighbor) &&
      possible_paths[neighbor][:cost] <= extended_path_cost
      next
    else
      possible_paths[neighbor] = {
        cost: extended_path_cost,
        last_edge: edge
      }
    end
  end
end
