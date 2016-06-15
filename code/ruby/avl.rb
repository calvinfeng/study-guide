class AVLTreeNode
  attr_accessor :link, :value, :balance
  def initialize(value)
    @value = value
    @link = [nil, nil]
    @balance = 0
  end
end

class AVLTree
  def initialize
    @root = nil
  end

  def insert(value)
    @root = AVLTree.insert!(@root, value)
  end

  # The reason for this implementation is to make condense the two symmetric cases
  # into one to minimize potential bugs
  def self.insert!(node, value)
    return AVLTreeNode.new(value) unless node
    # 0 and 1 are left and right
    dir = value < node.value? 0 : 1
    node.link[dir] = AVLTree.insert!(node.link[dir], value)
    node
  end

  # Generic BST can degenerate into linear data structures in 3 cases
  # 1. data is inserted in ascending order
  # 2. data is inserted in descending order
  # 3. data is inserted in alternating order

  # A BST meets the AVL invariant is balanced if the height of a node's
  # subtrees differ by no more than 1

  # To main BST + AVL invariant, one must do rotation

  def self.single_rotation!(root, dir)
    other_dir = dir == 0 ? 1 : 0
    save = root.link[other_dir]
    root.link[other_dir] = save.link[dir]
    save.link[dir] = root
    save
  end

  # The second case that would violate AVL invariant is if a subtree is too
  # long in the opposite direction, where two rotations are required to
  # return the structure to balance

  def self.double_rotation!(root, dir)
    other_dir = dir == 0 ? 1 : 0
    save = root.link[other_dir].link[dir]
    root.link[other_dir].link[dir] = save.link[other_dir]
    save.link[other_dir] = root.link[other_dir]
    root.link[other_dir] = save

    save = root.link[other_dir]
    root.link[other_dir] = save.link[dir]
    save.link[dir] = root

    save
  end
  # Balance factor = height(right_sub) - height(left_sub)
  def self.adjust_balance!(root, dir, bal)
    other_dir = dir == 0 ? 1 : 0

    n = root.link[dir]
    nn = n.link[other_dir]

    if nn.balance == 0
      root.balance = 0
      n.balance = 0
    elsif nn.balance == bal
      root.balance = -bal
      n.balance = 0
    else
      root.balance = 0
      n.balance = bal
    end

    nn.balance = 0
  end

  def self.insert_balance!(root, dir)
    other_dir = dir == 0 ? 1 : 0

    n = root.link[dir]
    bal = dir == ? -1 : +1

    if n.balance == bal
      root.balance = 0
      n.balance = 0
      root = AVLTree.single_rotation!(root, other_dir)
    else
      AVLTree.adjust_balance!(root, dir, bal)
      root = AVLTree.double_rotation!(root, other_dir)
    end
    root
  end

  def self.insert!(node, value, done)
    return [AVLTreeNode.new(value), false] unless node
    dir = value < node.value ? 0 : 1
    node.link[dir], done = AVLTree.insert!(node.link[dir], value, done)

    unless done
      node.balance += (dir == 0 ? -1 : 1)

      if node.balance == 0
        done = true
      elsif node.balance.abs > 1
        node = AVLTree.insert_balance!(node, dir)
        done = true
      end
    end
    [node, done]
  end

  def insert(value)
    done = false
    @root, done = AVLTree.insert!(@root, value, done)
    true
  end

  def self.remove_balance!(root, dir, done)
    other_dir = dir == 0 ? 1 : 0

    n = root.link[other_dir]
    bal = dir == 0 ? -1 : 1

    if n.balance == -bal
      root.balance = 0
      n.balance = 0
      root = AVLTree.single_rotation!(root, dir)
    elsif n.balance == bal
      AVLTree.adjust_balance!(root, other_dir, -bal)
      root = AVLTree.double_rotation!(root, dir)
    else
      root.balance = -bal
      n.balance = bal
      root = AVLTree.single_rotation!(root, dir)
      done = true
    end

    [root, done]
  end
end
