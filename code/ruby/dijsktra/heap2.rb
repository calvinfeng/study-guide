# This is an advanced version of the heap code from before with a
# `reduce!` method. Effectively this just maintains an `index_map`
# that associates values with indices in the heap.

class BinaryMinHeap
  def initialize(&prc)
    self.store = []
    # Keeps track of the index a value is stored at.
    self.index_map = {}
    self.prc = prc || Proc.new { |el1, el2| el1 <=> el2 }
  end

  def count
    store.length
  end

  def empty?
    count == 0
  end

  def extract
    raise "no element to extract" if count == 0

    self.class.swap!(store, index_map, 0, self.count - 1)

    val = store.pop
    index_map.delete(val)

    unless empty?
      self.class.heapify_down(store, index_map, 0, &prc)
    end

    val
  end

  def peek
    raise "no element to peek" if count == 0
    store[0]
  end

  def push(val)
    store << val
    index_map[val] = (store.length - 1)
    self.class.heapify_up(store, index_map, self.count - 1, &prc)
  end

  def reduce!(val)
    index = index_map[val]
    self.class.heapify_up(store, index_map, index, &prc)
  end

  protected
  attr_accessor :index_map, :prc, :store

  public
  def self.child_indices(len, parent_index)
    # If `parent_index` is the parent of `child_index`:
    #
    # (1) There are `parent_index` previous nodes to
    # `parent_index`. Any children of `parent_index` needs to appear
    # after the children of all the nodes preceeding the parent.
    #
    # (2) Also, since the tree is full, every preceeding node will
    # have two children before the parent has any children. This means
    # there are `2 * parent_index` child nodes before the first child
    # of `parent_index`.
    #
    # (3) Lastly there is also the root node, which is not a child of
    # anyone. Therefore, there are a total of `2 * parent_index + 1`
    # nodes before the first child of `parent_index`.
    #
    # (4) Therefore, the children of parent live at `2 * parent_index
    # + 1` and `2 * parent_index + 2`.

    [2 * parent_index + 1, 2 * parent_index + 2].select do |idx|
      # Only keep those in range.
      idx < len
    end
  end

  def self.parent_index(child_index)
    # If child_index is odd: `child_index == 2 * parent_index + 1`
    # means `parent_index = (child_index - 1) / 2`.
    #
    # If child_index is even: `child_index == 2 * parent_index + 2`
    # means `parent_index = (child_index - 2) / 2`. Note that, because
    # of rounding, when child_index is even: `(child_index - 2) / 2 ==
    # (child_index - 1) / 2`.

    raise "root has no parent" if child_index == 0
    (child_index - 1) / 2
  end

  def self.heapify_down(array, index_map, parent_idx, len = array.length, &prc)
    prc ||= Proc.new { |el1, el2| el1 <=> el2 }

    l_child_idx, r_child_idx = child_indices(len, parent_idx)

    parent_val = array[parent_idx]

    children = []
    children << array[l_child_idx] if l_child_idx
    children << array[r_child_idx] if r_child_idx

    if children.all? { |child| prc.call(parent_val, child) <= 0 }
      # Leaf or both children_vals <= parent_val. As a convenience,
      # return the modified array.
      return array
    end

    # Choose smaller of two children.
    swap_idx = nil
    if children.length == 1
      swap_idx = l_child_idx
    else
      swap_idx =
        prc.call(children[0], children[1]) <= 0 ? l_child_idx : r_child_idx
    end

    swap!(array, index_map, parent_idx, swap_idx)
    heapify_down(array, index_map, swap_idx, len, &prc)
  end

  def self.heapify_up(array, index_map, child_idx, len = array.length, &prc)
    prc ||= Proc.new { |el1, el2| el1 <=> el2 }

    # As a convenience, return array
    return array if child_idx == 0

    parent_idx = parent_index(child_idx)
    child_val, parent_val = array[child_idx], array[parent_idx]
    if prc.call(child_val, parent_val) >= 0
      # Heap property valid!
      return array
    else
      swap!(array, index_map, parent_idx, child_idx)
      heapify_up(array, index_map , parent_idx, len, &prc)
    end
  end

  def self.swap!(array, index_map, parent_idx, child_idx)
    parent_val, child_val = array[parent_idx], array[child_idx]

    array[parent_idx], array[child_idx] = child_val, parent_val
    index_map[parent_val], index_map[child_val] = child_idx, parent_idx
  end
end

# TESTING
# Todo: Write RSpec tests!

class NumWrapper
  attr_accessor :value
  def initialize(value)
    self.value = value
  end
end

def main
  heap = BinaryMinHeap.new { |v1, v2| v1.value <=> v2.value }
  heap.push(NumWrapper.new(5))
  heap.push(NumWrapper.new(7))
  heap.push(NumWrapper.new(3))
  heap.push(NumWrapper.new(9))
  heap.push(NumWrapper.new(1))

  vals = (0...5).map { heap.extract.value }
  p vals
  fail unless vals == [1, 3, 5, 7, 9]

  heap = BinaryMinHeap.new { |v1, v2| v1.value <=> v2.value }
  heap.push(nw1 = NumWrapper.new(5))
  heap.push(nw2 = NumWrapper.new(7))
  heap.push(nw3 = NumWrapper.new(3))
  heap.push(nw4 = NumWrapper.new(9))
  heap.push(nw5 = NumWrapper.new(1))

  nw1.value = -1
  heap.reduce!(nw1)

  nw4.value = 4
  heap.reduce!(nw4)

  vals = (0...5).map { heap.extract.value }
  p vals
  fail unless vals == [-1, 1, 3, 4, 7]
end

main if __FILE__ == $PROGRAM_NAME
