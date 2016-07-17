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
    self.to_vertex.in_edges.delete(self)
    self.to_vertex = nil
    self.from_vertex.out_edges.delete(self)
    self.from_vertex = nil
  end
end

def bfs(node, target)
  queue = [node]
  until queue.empty?
    probe = queue.shift
    probe.visit!
    return probe if probe.value == target
    probe.out_edges.each do |edge|
      queue << edge.to_vertex unless edge.to_vertex.visited?
    end
  end
  nil
end

v1 = Vertex.new("Calvin")
v2 = Vertex.new("Steven")
v3 = Vertex.new("Matt")
v4 = Vertex.new("Loki")
e1 = Edge.new(v1, v2)
e6 = Edge.new(v1, v3)
e2 = Edge.new(v2, v4)
e4 = Edge.new(v4, v1)
e5 = Edge.new(v4, v2)

result = bfs(v1, "Loki")
p result.value
p v1.visited?
p v2.visited?
p v3.visited?
p v4.visited?
# def bfs(root, target)
#   queue = [root]
#   until queue.empty?
#     probe = queue.shift
#     return probe if probe.value == target
#     probe.children.each do |child|
#       queue << child
#     end
#   end
#   nil
# end
