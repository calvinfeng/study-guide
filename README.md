# Study Guide for Technical Interviews
By now it should be week 14 for those who are reading this guide. This study
guide outlines the major data structures and algorithms needed to succeed in
technical interviews. The official guide was first written by Haseeb Qureshi,
titled [How To Break Into The Tech Industry - a Guide to Job Hunting and Interviews][haseeb]
on his personal blog site. This guide focuses on time management and examples of
implementation details of the materials. However, please read Haseeb's guide at least
once and follow his advice. I simply took his suggestions and added more details to
them, just so I can get the practice from writing them.

This study guide is more tailored toward companies who ask abstract algorithmic
problems. Small startups tend to ask you to build a small project or try to debug
their production code. For those cases, I think AppAcademy has prepared you well.
If you are still not confident, go out and build more JavaScript games or another
Rails project.

[haseeb]: http://haseebq.com/#general-study

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
- [x] Stack & Queue
- [x] LinkedList
- [x] HashMap
- [x] LRU Cache (Using LinkedList & HashMap)
- [x] Dynamic Array (Ring Buffer)
- [x] Binary Heap (Without decrease-key)
- [x] Binary Search Tree
  - [x] Optional: AVL, 2-3 Tree, Red-Black Tree
- [ ] Prefix Tree
- [ ] Suffix Tree
- [x] Directed & Undirected Graphs

AppAcademy had you implemented them in Ruby. For those who are interested in front-end role,
implement these data structures in JavaScript at least once for each.

## Algorithms

### Search
- [ ] Binary Search
- [ ] Breadth-first Search
- [ ] Depth-first Search

### Sorting
- [ ] Quick Sort (Partition Subroutine)
- [ ] Merge Sort
- [x] Heap Sort

### Graphs
- [x] Tree Traversals (Pre-order, In-order, Post-order)
- [x] Objected-oriented Adjacency List
- [x] Adjacency Matrix
- [x] Topological Sort (Kahn's Algorithm)
- [x] Topological Sort (Tarjan's Algorithm)
- [x] Dijkstra's Algorithm (Use PriorityQueue without decrease-key)

### Dynamic Programming & Recursion
- [ ] Longest Common Subsequence (Use matrices)
- [ ] Knapsack Problem
- [ ] Fibonacci Sequence

## Timeline

### Week 13
I suggest you to apply as many as you can before you start studying for interviews.
I personally find it distracting to apply and study. Apply and finish the 150 applications,
the phone screens will come, technical Interviews will soon follow. After every technical
phone screen or on-site interview ended, keep a detailed documentation of the interview
problems/questions and solutions. By now, you should have most of the algorithms covered through
a/A's algorithm homework from week 12 and week 13.

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
- Binary Search
- Quick Sort
- Merge Sort

[linked_list]: ./linked_list.md
[stack_and_queue]: ./stack_and_queue.md
[stack_queue]: ./stack_queue.md
[hash_map]: ./hash_map.md
[lru]: ./lru.md
[dynamic_array]: ./dynamic_array.md

### Week 2
The tree week
#### Topics
- Binary Heap
- Heap Sort
- Binary Search Tree
- Graph
- Breadth-first Search
- Depth-first Search
- Tree Traversals
- Adjacency List
- Adjacency Matrix
- Topological Sort
- Dijkstra's Algorithm

### Week 3
#### Topics
- Prefix Tree
- Suffix Tree
- Dynamic Programming