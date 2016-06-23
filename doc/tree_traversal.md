# Tree Traversal
There are three types depth-first of tree traversal
* Pre-order
* In-order
* Post-order

While breadth-first traversal is just level order (using a queue)

Using a binary search tree as example, the traversals can be described as
* Pre-order => [root] [left] [right]
* In-order => [left] [root] [right]
* Post-order => [left] [right] [root]

Using binary search tree as an example

![binary_tree][binary_tree]
[binary_tree]: ./img/binary_tree.png

## Pre-order
``` ruby
def BinarySearchTree.preorder!(node)
  return [] unless node
  arr = [node.value]
  arr += BinarySearchTree.preorder!(node.left)
  arr += BinarySearchTree.preorder!(node.right)
  arr
end
```
1. First call will hit the root, 5
2. We have 5(left)(right)
3. Next call will be root of the left subtree which is 4
4. 5(4(left)(right))(right)
5. Keep going, hit the root of the left subtree of 4.
6. Then we have 5(4(2(left)(right))(right)))(right)
7. The subtrees of 2 are 1 and 3.
8. 5(4(213)(right))(right), right subtree of 4 is empty so we have 54213(right)
9. Hit the root of the right subtree, that is 8. We have 54213(8(left)(right))
10. 54213(8(76)(910))
11. Final answer: 54213876910

## In-order
``` ruby
def BinarySearchTree.inorder!(node)
  return [] unless node
  arr = []
  arr += BinarySearchTree.inorder!(node.left)
  arr << node.value
  arr += BinarySearchTree.inorder!(node.right)
  arr
end
```
We will use similar process here to show that in-order traversal for a binary search tree will yield sorted output.

1. First call stack leads to (left)5(right)
2. The left subtree of 5 is (left)4(empty)
3. ((left)4)5(right)
4. The left subtree of 4 will give 123
5. (1234)5(right)
6. The right subtree of 5 is (left)8(right)
7. Left subtree of 8 will give 67
8. Right subtree of 8 will give 910
9. (1234)5(678910)
10. Final answer: 12345678910

## Post-order
``` ruby
def BinarySearchTree.postorder!(node)
  return [] unless node
  arr = []
  arr += BinarySearchTree.postorder!(node.left)
  arr += BinarySearchTree.postorder!(node.right)
  arr << node.value
  arr
end
```
Just as above,

1. (left)(right)5
2. ((left)(empty)4)(right)5
3. ((132)(empty)4)(right)5
4. 1324((left)(right)8)5
5. 1324((67)(109)8)5
6. 13246710985
