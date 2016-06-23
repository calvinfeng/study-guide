# Heap
Heap is typically built on top of a binary tree. It is a *complete tree* which means it completes each level before it moves onto to build the next level. A *full tree* is a tree with every level completely filled.

Heap invariant: any node's parent must be less than or equal to the node itself (minHeap). If it's a maxHeap, then any node's parent must be greater than or equal to the node itself.

Primary APIs
* #find_mid or #find_max
* #insert
* #extract
* #count

## Implementation: MinHeap
``` ruby
class BinaryMinHeap
  def initialize(&prc)
    @store = []
  end

  def count
    @store.length
  end

  def extract
    temp = @store[0]
    @store[0] = @store[-1]
    @store[-1] = temp
    extracted_val = @store.pop
    BinaryMinHeap.heapify_down(@store, 0)
    extracted_val
  end

  def peek
  end

  def push(val)
    @store.push(val)
    BinaryMinHeap.heapify_up(@store, @store.length - 1)
  end

  protected
  attr_accessor :prc, :store

  public
  def self.child_indices(len, parent_index)
    children = []
    first_child = parent_index*2 + 1
    children << first_child if first_child < len
    second_child = parent_index*2 + 2
    children << second_child if second_child < len
    children
  end

  def self.parent_index(child_index)
    raise "root has no parent" if child_index == 0
    (child_index - 1)/2x
  end

  def self.heapify_down(array, parent_idx, len = array.length, &prc)
    unless prc
      prc = Proc.new {|parent, child| parent <=> child}
    end

    children = BinaryMinHeap.child_indices(len, parent_idx)
    return array if children.length == 0

    case children.length
    when 0
      return array
    when 1
      if prc.call(array[parent_idx], array[children[0]]) == 1
        temp = array[parent_idx]
        array[parent_idx] = array[children[0]]
        array[children[0]] = temp
      end
    when 2
      if prc.call(array[parent_idx],array[children[0]]) == 1 || prc.call(array[parent_idx],array[children[1]]) == 1
        if prc.call(array[children[0]],array[children[1]]) == -1
          temp = array[parent_idx]
          array[parent_idx] = array[children[0]]
          array[children[0]] = temp
        else
          temp = array[parent_idx]
          array[parent_idx] = array[children[1]]
          array[children[1]] = temp
        end
      end
    end
    BinaryMinHeap.heapify_down(array, children[0], &prc)
    BinaryMinHeap.heapify_down(array, children[1], &prc) if children.length == 2
  end

  def self.heapify_up(array, child_idx, len = array.length, &prc)
    unless prc
      prc = Proc.new {|parent, child| parent <=> child}
    end
    # base case
    return array if child_idx == 0;

    parent_idx = BinaryMinHeap.parent_index(child_idx)
    if prc.call(array[parent_idx], array[child_idx]) == 1
      temp = array[parent_idx]
      array[parent_idx] = array[child_idx]
      array[child_idx] = temp
    end
    child_idx = parent_idx
    BinaryMinHeap.heapify_up(array, child_idx, &prc)
  end
end
```

## Insertion & Extraction
Insertion and extraction requires O(log(n)) time because the heap needs to
restructure itself to maintain heap invariant.

For example,
![heapify_up][heapify_up]
[heapify_up]: ../img/heapify_up.png
