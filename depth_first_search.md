# Depth First Search (Tree & Graph)

## Implementation (Tree)
This is the tree version. The search begins at the root and then traverse
down to its children. When leaf node is reached, there is no children, the
recursive step will terminate. It will return early once target is found.
``` ruby
def dfs(root, target)
  return nil if root.nil?
  root.children.each do |child|
    search_result = dfs(child, target)
    return search_result unless search_result.nil?
  end
  nil
end
```

## Implementation (Graph)
This is the graph version, which is just a slight modification of the tree
version
``` ruby
class Vertex
  attr_accessor :value, :in_edges, :out_edges
  def initialize(value)
    @value, @in_edges, @out_edges = value, [], []
    @visited = false
  end

  def visited?
    @visited
  end

  def visit!
    @visited = true
  end
end

class Edge
  attr_accessor :to_vertex, :from_vertex, :cost
  def initialize(from_vertex, to_vertex, cost = 1)
    self.from_vertex = from_vertex
    self.to_vertex = to_vertex
    self.cost = cost

    to_vertex.in_edges << self
    from_vertex.out_edges << self
  end

  def destroy!
    self.to_vertex.out_edges.delete(self)
    self.to_vertex = nil
    self.from_vertex.in_edges.delete(self)
    self.from_vertex = nil
  end
end

def dfs(node, target)
  return nil if node.nil? || node.visited?
  node.visit!
  return node if node.value == target

  node.out_edges.each do |out_edge|
    search_result = dfs(out_edge.to_vertex, target)
    return search_result unless search_result.nil?
  end

  nil
end
```