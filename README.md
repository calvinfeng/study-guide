# Study Guide for Technical Interviews
By now it should be week 14 for those who are reading this guide. This study
guide outlines the major data structures and algorithms needed to succeed in
technical interviews. The official guide was first written by Haseeb Qureshi,
titled [How To Break Into The Tech Industry - a Guide to Job Hunting and Interviews][haseeb]
on his personal blog site. This guide focuses on time management and examples of
implementation details of the materials. However, please read Haseeb's guide at least
once and follow his advice. I simply took his suggestions and added more details to
them, just so I can get the practice from writing them.
[haseeb]: http://haseebq.com/#general-study

This study guide is more tailored toward companies who ask abstract algorithmic
problems. Small startups tend to ask you to build a small project or try to debug
their production code. For those cases, I think AppAcademy has prepared you well.
If you are still not confident, go out and build more JavaScript games or another
Rails project.

## Key Resources
* Cracking the Coding Interview 6th Edition
* Effective JavaScript
* Coursera - Princeton Lectures on Algorithms (1 & 2)
* Algorithm Design Manual

### Optional Resources (Podcast & Blog)
* [Software Engineering Daily][daily]
* [The Bike Shed][bikeshed]
* [Hacker News][hacker]
* [High Scalability][scale]

[bikeshed]: http://bikeshed.fm/
[daily]: http://softwareengineeringdaily.com/
[scale]:http://highscalability.com/all-time-favorites/
[hacker]: https://news.ycombinator.com/

## Data Structures
- [x] [Stack & Queue][stack_and_queue]
- [x] [LinkedList][linked_list]
- [x] [HashMap][hash_map]
- [x] [LRU Cache (Using LinkedList & HashMap)][lru]
- [x] [Dynamic Array (Ring Buffer)][dynamic_array]
- [x] [Binary Heap (Without decrease-key)][binary_heap]
- [x] [Binary Search Tree][bst]
  - [x] Optional: AVL, 2-3 Tree, Red-Black Tree
- [x] [Directed & Undirected Graphs][graph]
- [x] [Tries][trie]
- [ ] Suffix Tree

AppAcademy had you implemented them in Ruby. For those who are interested in front-end role,
implement these data structures in JavaScript at least once for each.

## Algorithms

### Search
- [x] [Binary Search][binary_search]
- [x] [Breadth-first Search][bfs]
- [x] [Depth-first Search][dfs]

### Sorting
- [x] [Quick Sort (Partition Subroutine)][quick_sort]
- [x] [Merge Sort][merge_sort]
- [x] [Radix Sort][radix]
- [x] Heap Sort

### Graphs
- [x] [Tree Traversals (Pre-order, In-order, Post-order)][tree_traversal]
- [x] [Objected-oriented Adjacency List][graph]
- [x] [Adjacency Matrix][graph]
- [x] [Topological Sort (Kahn's Algorithm)][topo]
- [x] Topological Sort (Tarjan's Algorithm)
- [x] [Dijkstra's Algorithm (Use PriorityQueue without decrease-key)][dijkstra]

### Dynamic Programming & Recursion
- [x] [Longest Common Subsequence(Use matrices)][dynamic]
- [x] [Fibonacci Sequence][dynamic]
- [ ] Knapsack Problem

## Timeline

### Week 1
The first week of independent study, which is week 14 in a/A's calendar
Start watching Algorithm Part 1 on Coursera for Stacks & Queues, Elementary Sorts,
Merge Sort, and Quick Sort. Go 2x speed.

#### Topics
- [Dynamic Array or ArrayList(Java)][dynamic_array]
- [Stack and Queue][stack_and_queue]
- [StackQueue][stack_queue]
- [LinkedList][linked_list]
- [HashMap][hash_map]
- [LRU Cache][lru]
- [Binary Search][binary_search]
- [Quick Sort][quick_sort]
- [Merge Sort][merge_sort]

### Week 2
The tree week
#### Topics
- [Binary Heap][binary_heap]
- Heap Sort
- [Binary Search Tree][bst]
- [Graph, Adjacency List, and Adjacency Matrix][graph]
- [Breadth-first Search][bfs]
- [Depth-first Search][dfs]
- [Tree Traversals][tree_traversal]
- [Topological Sort][topo]

### Week 3
#### Topics
- [Dijkstra's Algorithm][dijkstra]
- [Suffix Tree]
- [Trie or Prefix Tree][trie]
- [Radix][radix]
- [Dynamic Programming][dynamic]


[bfs]: ./doc/breadth_first_search.md
[binary_heap]: ./doc/binary_heap.md
[binary_search]: ./doc/binary_search.md
[bst]: ./doc/binary_search_tree.md
[dfs]: ./doc/depth_first_search.md
[dijkstra]: ./doc/dijsktra.md
[dynamic_array]: ./doc/dynamic_array.md
[dynamic]: ./doc/dynamic_programming.md
[graph]: ./doc/graph.md
[hash_map]: ./doc/hash_map.md
[linked_list]: ./doc/linked_list.md
[lru]: ./doc/lru.md
[merge_sort]: ./doc/merge_sort.md
[quick_sort]: ./doc/quick_sort.md
[radix]: ./doc/radix.md
[stack_and_queue]: ./doc/stack_and_queue.md
[stack_queue]: ./doc/stack_queue.md
[tree_traversal]: ./doc/tree_traversal.md
[trie]: ./doc/trie.md
[topo]: ./doc/topological_sort.md
