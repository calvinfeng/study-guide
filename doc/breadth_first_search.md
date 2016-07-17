# Breadth First Search (Tree & Graph)

## Implementation
Breadth first search requires a queue. The first step is to insert the root
into the queue and start the while loop. While the queue is not empty, pop
the element off (i.e. shift) from beginning of the queue and examine its value.
Then push its children/neighbors into the queue.
``` ruby
def bfs(root, target)
  queue = [root]
  until queue.empty?
    probe = queue.shift
    return probe if probe.value == target
    probe.children.each do |child|
      queue << child
    end
  end
  nil
end
```

## Implementation (Graph)
The graph implementation requires marking the node as visited to prevent
infinite recursion
#### Ruby
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
```

#### JavaScript
``` javascript
//Graphs
class Vertex {
  constructor(value) {
    this.value = value;
    this.inEdges = [];
    this.outEdges = [];
    this.visited = false;
  }

  visit() {
    this.visited = true;
  }

  deleteOutEdge(outEdge) {
    for (let i = 0; i < this.outEdges.length; i++) {
      if (this.outEdges[i] === outEdge) {
        this.outEdges.splice(i, 1);
        break;
      }
    }
  }

  deleteInEdge(inEdge) {
    for (let i = 0; i < this.inEdges.length; i++) {
      if (this.inEdges[i] === inEdge) {
        this.inEdges.splice(i, 1);
        break;
      }
    }
  }
}

class Edge {
  constructor(fromVertex, toVertex, cost) {
    this.fromVertex = fromVertex;
    this.toVertex = toVertex;
    this.cost = cost || 1;
    fromVertex.outEdges.push(this);
    toVertex.inEdges.push(this);
  }

  destroy() {
    this.toVertex.deleteInEdge(this);
    this.fromVertex.deleteOutEdge(this);
    this.toVertex = undefined;
    this.fromVertex = undefined;
  }
}

function breadthFirstSearch(vertex, target) {
  let queue = [vertex];
  while (queue.length > 0) {
    let probeVertex = queue.shift();
    probeVertex.visit();
    if (probeVertex.value === target) {
      return probeVertex;
    } else {
      probeVertex.outEdges.forEach((outEdge) => {
        let neighborVertex = outEdge.toVertex;
        if (!neighborVertex.visit()) {
          queue.push(neighborVertex);
        }
      });
    }
  }
  return null;
}
```
