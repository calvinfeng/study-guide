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

v1 = Vertex.new("Calvin")
v2 = Vertex.new("Steven")
v3 = Vertex.new("Matt")
v4 = Vertex.new("Loki")
e1 = Edge.new(v1, v2)
e6 = Edge.new(v1, v4)
e2 = Edge.new(v2, v3)
e3 = Edge.new(v2, v1)
e4 = Edge.new(v3, v1)
e5 = Edge.new(v3, v4)

result = dfs(v1, "Loki")
p result.value
p v1.visited?
p v2.visited?
p v3.visited?
p v4.visited?
