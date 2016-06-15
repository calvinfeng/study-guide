require_relative 'graph'
require 'byebug'
# Implementing topological sort using both Khan's and Tarian's algorithms

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
