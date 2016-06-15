require_relative 'graph'
require_relative 'priority_map'

# O(|V| + |E|*log(|V|)).
def dijkstra2(source)
  locked_in_paths = {}
  possible_paths = PriorityMap.new do |data1, data2|
    data1[:cost] <=> data2[:cost]
  end
  possible_paths[source] = { cost: 0, last_edge: nil}

  # O(|V|) times, we need to run through all vertices
  until possible_paths.empty?
    #O(log(|V|)) for heapifying
    vertex, data = possible_paths.extract
    locked_in_paths[vertex] = data
    update_possible_paths(vertex, locked_in_paths, possible_paths)
  end
  locked_in_paths
end

def update_possible_paths(vertex, locked_in_paths, possible_paths)
  path_to_vertex_cost = locked_in_paths[vertex][:cost]
  # O(|E|)
  vertex.out_edges.each do |edge|
    neighbor = edge.to_vertex
    next if locked_in_paths.has_key?(neighbor)

    extended_path_cost = path_to_vertex_cost + edge.cost
    if possible_paths.has_key?(neighbor) && possible_paths[neighbor][:cost] <= extended_path_cost
      next
    else
      # O(log(|V|))
      possible_paths[neighbor] = {
        cost: extended_path_cost,
        last_edge: edge
      }
    end
  end
end
