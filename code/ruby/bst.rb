require 'byebug'

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

root = BSTNode.new(5)
tree = BinarySearchTree.new
BinarySearchTree.insert!(root, 1)
BinarySearchTree.insert!(root, 2)
BinarySearchTree.insert!(root, 3)
BinarySearchTree.insert!(root, 4)
console.log(tree.inorder();
