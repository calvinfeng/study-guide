class Vertex
  attr_reader :in_edges, :out_edges, :value

  def initialize(value)
    @value = value
    @in_edges = []
    @out_edges = []
  end

  def add_in_edge(edge)
    @in_edges << edge
  end

  def remove_in_edge(edge)
    @in_edges.each_index do |idx|
      if @in_edges[idx] == edge
        @in_edges.delete_at(idx)
      end
    end
  end

  def add_out_edge(edge)
    @out_edges << edge
  end

  def remove_out_edge(edge)
    @out_edges.each_index do |idx|
      if @out_edges[idx] == edge
        @out_edges.delete_at(idx)
      end
    end
  end

end

class Edge
  attr_reader :from_vertex, :to_vertex, :cost

  def initialize(from_vertex, to_vertex, cost = 1)
    @from_vertex = from_vertex
    @to_vertex = to_vertex
    @cost = cost
    from_vertex.add_out_edge(self)
    to_vertex.add_in_edge(self)
  end

  def destroy!
    @from_vertex.remove_out_edge(self)
    @from_vertex = nil
    @to_vertex.remove_in_edge(self)
    @to_vertex = nil
  end
end
