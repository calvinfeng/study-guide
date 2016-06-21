# Graph
There are two kinds of graphs, directed and undirected. Since we are specifying
the directions of edges (i.e. inward and outward,) we are talking about
directed graphs here. But we can always generalize the data structure to be
undirected by making sure the edges go both ways. However, topological sort
requires directed acyclic graphs.

Two vertices are *connected* if there is a path between them. The edge typically
carries information of the cost or distance of the path.

## Graph API
* `#initialize(num_of_vertices)`
* `#addEdge` - add connection between any two vertices
* `#eachVertex` - takes in a block, iterate through all vertices

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
## Graph Representation
### Adjacency List
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

Example of Java implementation
``` java
public class Graph
{
  private final int V;
  private Bag<Integer>[] adjList;

  public Graph(int V)
  {
    this.V = V;
    adjList = (Bag<Integer>[]) new Bag[V];
    for (int v = 0; v < V; v++) {
      adjList[v] = new Bag<Integer>();
    }
  }

  public void addEdge(int v, int w)
  {
    adjList[v].add(w);
    adjList[w].add(v);
  }
}
```

### Adjacency Matrix
We can also use a matrix to represent the neighboring relationship above.
The matrix should be symmetric for undirected graphs.
```
matrix =
_ 0 1 2 3  
0 * 1 1 0
1 1 * 1 0
2 1 1 * 1
3 0 0 1 *

matrix[0][1] => connect from 0 to 1, in this case it's Calvin to Matt.
If such connection exists, set matrix[0][1] = 1.

matrix[0][0] is self connection, just give it any symbol; I used *
```

### Density
Density: 2|E|/(|V| |V - 1|)

If density is close to 1, it's a dense graph. Use adjacency matrix for dense graphs and use adjacency list for sparse graphs.

## Connected Component
Vertices v and w are connected if there is a path between them.

### Properties
The relation "is connected to" is an equivalence relation:
* Reflexive: *v* is connected to *v*
* Symmetric: if *v* is connected to *w*, then *w* is connected to *v*
* Transitive: if *v* connected to *w* and *w* connected to *x*, then *v* is
connected to *x*


 A *connected component* is a maximal set of connected vertices

 The goal is to partition a set of vertices into connected component, we
 will achieve this in linear time by iterating through all the vertices
 contained in a graph.

### Approach
1. Initialize all vertices as unmarked
2. For each unmarked vertex *v*, run DFS to identity all vertices discovered as
part of the same component
3. Create a hash map, using vertex as the key, and assign an ID number as value,
then mark the vertex as visited
4. ID number begins at 1, it should stay at 1 for the whole DFS search.
5. Upon completion of the first DFS search, ID should increment.
6. Iterate to next vertex, if it's visited, skip. Once we find an unvisited
node, we fire DFS again but now ID = 2.

``` ruby
class ConnectedComponent
  def initialize(graph)
    @components = Hash.new
    @graph = graph
    mapConnectedComponents
  end

  def mapConnectedComponents
    id = 1
    @graph.vertices.each do |vertex|
      unless vertex.visited?
        dfs(vertex, id)
        id += 1
      end
    end
    @count = id
  end

  def count
    @count
  end

  def dfs(vertex, id)
    # should be something like...
    @components[vertex] = id
    vertex.visit!
    vertex.out_edges.each do |edge|
      dfs(edge.to_vertex, id)
    end
  end
end
```

## Interivew Problems
__Route Between Nodes__: Given a directed graph, design an algorithm to find out
whether there is a route between two nodes
``` ruby
def is_there_route?(source, dest)
  dfs(source, dest) == dest
end

def dfs(node, target)
  return nil if node.nil? || node.visit?
  node.visit!
  return node if node == target
  node.out_edges.each do |out_edge|
    search_result = dfs(out_edge.to_vertex, target)
    return search_result unless search_result.nil?
  end
  nil
end
```

__Minimal Tree__: Given a sorted (increasing order) array with unique
integer elements, write an algorithm to create a binary search tree with
minimal height.
``` ruby
def minimal_insert(bstree, arr)
  if arr.length == 1
    bstree.insert(arr[0])
  elsif arr.length == 0
    # do nothing
  else
    mid_idx = arr.length/2
    bstree.insert(arr[mid_idx])
    # Recurse on left sub-array
    minimal_insert(bstree, arr.take(mid_idx))
    # Recurse on right sub-array
    minimal_insert(bstree, arr.drop(mid_idx + 1))
  end
end
```

__List of Depths__: Given a binary tree, design an algorithm which creates a
linked list of all the nodes at each depth(e.g. if you have a tree with depth D,
you will have D linked lists)
``` ruby
def depth_lists(root)
  # Begin with inserting root into the first LinkedList
  linkedlist_arr = []
  current_list = LinkedList.new
  current_list.insert(root.value, root) unless root.nil?
  until current_list.empty?
    # Push the previous level into the array
    linkedlist_arr << current_list
    # The links from previous level are the parent nodes
    parents = current_list
    # Re-assign current list to an en empty list
    current_list = LinkedList.new
    # Go through each parent and insert their children into current list
    parents.each do |parent|
      parentNode = parent.val
      current_list.insert(parentNode.left.value, parentNode.left) unless parentNode.left.nil?
      current_list.insert(parentNode.right.value, parentNode.right) unless parentNode.right.nil?
    end
    # Go back to top
  end
  linkedlist_arr
end
```

__Check Balanced__: Implement a function to check if a binary tree is balanced.
For the purposes of this question, a balanced tree is defined to be a tree
such that the heights of the two subtrees of any node never differ by more
than one.
