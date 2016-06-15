# Graph
There are two kinds of graphs, directed and undirected. Since we are specifying
the directions of edges (i.e. inward and outward,) we are talking about
directed graphs here. But we can always generalize the data structure to be
undirected. Edges are helpful when we need to store information of their path cost.

## Implementation
``` ruby
class Vertex
  attr_accessor :in_edges, :out_edges, :value

  def initialize(value)
    @value = value
    @in_edges = []
    @out_edges = []
  end

  def delete_in_edge(edge)
    @in_edges.each_index do |idx|
      if @in_edges[idx] == edge
        @in_edges.delete_at(idx)
      end
    end
  end

  def delete_out_edge(edge)
    @out_edges.each_index do |idx|
      if @out_edges[idx] == edge
        @out_edges.delete_at(idx)
      end
    end
  end
end

class Edge
  attr_reader :source, :destination, :cost
  def initialize(source, destination, cost = 1)
    @source = source
    @destination = destination
    @cost = cost
    @source.out_edges << self
    @destination.in_edges << self
  end

  def destroy!
    @source.delete_out_edge(self)
    @destination.delete_in_edge(self)
    @source = nil
    @destination = nil
  end
end
```
## Adjacency List
For each vertex i, store an array of adjacent vertices to it. We typically
have an array of adjacency lists; each vertex gets a list (of neighbors.) We can also use a hash.

Example:

![graph][graph]
[graph]:./img/graph.png

```
i
0 - Calvin => [Matt, Steven]
1 - Matt => [Calvin, Steven]
2 - Steven => [Calvin, Matt, Loki]
3 - Loki => [Steven]
```
## Adjacency Matrix
We can also use a matrix to represent the neighboring relationship above. The matrix should be symmetric for undirected graphs.
```
matrix =
_ 0 1 2 3  
0 * 1 1 0
1 1 * 1 0
2 1 1 * 1
3 0 0 1 *

matrix[0][1] => connect from 0 to 1, in this case it's Calvin to Matt. If such connection exists, set matrix[0][1] = 1.

matrix[0][0] is self connection, just give it any symbol. I used *
```

## Density
Density: 2|E|/(|V| |V - 1|)

If density is close to 1, it's a very dense graph. Use adjacency matrix for dense graphs and use adjacency list for sparse graphs.
