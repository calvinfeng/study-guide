# Binary Search tree
Primary API:
* #insert - O(log n)
* #find - O(log n)
* #delete - O(log n)
* #max
* #min
* #height
* #inorder
* #postorder
* #pre-order

## Implementation
``` ruby
class BSTNode
  attr_accessor :left, :right
  attr_reader :value

  def initialize(value)
    @value = value
    @left = nil
    @right = nil
  end
end

class BinarySearchTree
  def initialize
    @root_node = nil
  end

  def insert(value)
    if @root_node
      BinarySearchTree.insert!(@root_node, value)
    else
      @root_node = BSTNode.new(value)
    end
  end

  def find(value)
    BinarySearchTree.find!(@root_node, value)
  end

  def inorder
    BinarySearchTree.inorder!(@root_node)
  end

  def postorder
    BinarySearchTree.postorder!(@root_node)
  end

  def preorder
    BinarySearchTree.preorder!(@root_node)
  end

  def height
    BinarySearchTree.height!(@root_node)
  end

  def min
    BinarySearchTree.min(@root_node)
  end

  def max
    BinarySearchTree.max(@root_node)
  end

  def delete(value)
    BinarySearchTree.delete!(@root_node, value)
  end

  def self.insert!(node, value)
    # Base case is when node.left or node.right is nil
    if node
      if value <= node.value
        node.left = BinarySearchTree.insert!(node.left, value)
      elsif value > node.value
        node.right = BinarySearchTree.insert!(node.right, value)
      end
      node
    else
      BSTNode.new(value)
    end
  end

  def self.max(node)
    if node
      return node if node.right.nil?
      BinarySearchTree.max(node.right)
    else
      nil
    end
  end

  def self.min(node)
    if node
      return node if node.left.nil?
      BinarySearchTree.min(node.left)
    else
      nil
    end
  end

  def self.find!(node, value)
    if node
      if value < node.value
        BinarySearchTree.find!(node.left, value)
      elsif node.value < value
        BinarySearchTree.find!(node.right, value)
      else
        node
      end
    else
      nil
    end
  end

  def self.inorder!(node)
    return [] unless node
    arr = []
    arr += BinarySearchTree.inorder!(node.left)
    arr << node.value
    arr += BinarySearchTree.inorder!(node.right)
    arr
  end

  def self.preorder!(node)
    return [] unless node
    arr = [node.value]
    arr += BinarySearchTree.preorder!(node.left)
    arr += BinarySearchTree.preorder!(node.right)
    arr
  end

  def self.postorder!(node)
    return [] unless node
    arr = []
    arr += BinarySearchTree.postorder!(node.left)
    arr += BinarySearchTree.postorder!(node.right)
    arr << node.value
    arr
  end

  def self.height!(node)
    if node
      return 0 if node.left.nil? && node.right.nil?

      depth = []
      if node.left
        depth << 1 + BinarySearchTree.height!(node.left)
      end
      if node.right
        depth << 1 + BinarySearchTree.height!(node.right)
      end
      depth.max
    else
      -1
    end
  end

  def self.delete_min!(node)
    return nil if node.nil?
    if node.left
      node.left = BinarySearchTree.delete_min!(node.left)
      node
    else
      node.right
    end
  end

  # Known as Hubbard Deletion
  # Either delete and replace with the minimum of the right subtree
  # or with the maximum of the left subtree
  def self.delete!(node, value)
    return nil if node.nil?

    if value < node.value
      node.left = BinarySearchTree.delete!(node.left, value)
    elsif node.value < value
      node.right = BinarySearchTree.delete!(node.right, value)
    else
      return node.left if node.right.nil?
      return node.right if node.left.nil?
      # What is it trying to do?
      t = node
      node = t.right.min
      node.right = BinarySearchTree.delete_min!(t.right)
      node.left = t.left
    end
  end
end
```
## Interview Problems
__Symmetric Tree__: Write a function to check whether a binary search tree is mirrored
``` ruby
def isMirrored(left, right)
  return (left == nil && right == nil) if left == nil || right == nil
  left.value == right.value && isMirrored(left.left, right.right) && isMirrored(left.right, right.left)
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

``` ruby
# O(n log n)
def getHeight(root_node)
  return -1 if root_node.nil?
  [getHeight(root_node.left), getHeight(root_node.right)].max + 1
end

def is_balanced?(root_node)
  return true if root_node.nil?
  height_diff = getHeight(root.left) - getHeight(root.right)
  if height_diff.abs > 1
    false
  else
    is_balanced?(root.left) && is_balanced?(root.right)
  end
end
```
``` ruby
# O(n) with space O(Height)
def check_height(root)
  return -1 if root.nil?
  left_height = check_height(root.left)
  return false unless left_height
  right_height = check_height(root.right)
  return false unless right_height

  height_diff = left_height - right_height
  if height_diff > 1
    false
  else
    [left_height, right_height].max + 1
  end
end

def is_balanced?(root_node)
  !!check_height(root_node)
end
```

__Validate BST__: Implement a function to check if a binary tree is binary
search tree

If the tree does not have duplicate value, do an in-order traversal and
see if the elements are sorted, if not, it's not a valid BST. But let's say
we need a solution that allows duplicates. Then this is the approach:
``` javascript
/*
  This approach is using the fact that the maximum of left subtree must be
less than or equal to the root node and the minimum of right subtree must be
greater than the root node.
*/
function validateBST(root) {
  if (root.left && root.right) {
    return (BSTree.max(root.left).value <= root.value &&
      BSTree.max(root.right).value > root.value) &&
        (validateBST(root.left) && validateBST(root.right));
  } else if (root.left) {
    return (BSTree.max(root.left).value <= root.value) &&
      validateBST(root.left);
  } else if (root.right) {
    return (BSTree.max(root.right).value > root.value) &&
      validateBST(root.right);
  } else {
    return true;
  }
}
```

__Successor__: Write an algorithm to find the "next" node (i.e. in-order
successor) of a given node in a binary search tree. You may assume that
each node has a link to its parent.

This problem is easy if we choose the root of the tree or any node that
has a right subtree because the next node has to be the left-most node of
the right subtree. What if a node does not have a right subtree?
``` ruby
# If the maximum of the left sub-tree of the root is chosen, then it has no
# right subtree. It has to traverse upward to find the successor
def successor(node)
  if node.right
    BinarySearchTree.left_most(node.right)
  else
    current_node = node
    parent_node = current_node.parent
    while !parent_node.nil? && parent_node.right == current_node
      # Traverse upward until current_node finds itself to be the left child
      current_node = parent_node
      parent_node = current_node.parent
    end  
    current_node.parent
  end
end

def BinarySearchTree.left_most(node)
  return nil if node.nil?
  until node.left.nil?
    node = node.left
  end
  node
end
```
