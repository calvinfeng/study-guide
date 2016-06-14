## Linked List
``` ruby
class Link
  attr_accessor :key, :val, :next, :prev

  def initialize(key = nil, val = nil)
    @key = key
    @val = val
    @next = nil
    @prev = nil
  end

  def to_s
    "#{@key}: #{@val}"
  end
end

class LinkedList
  include Enumerable

  def initialize
    @head = Link.new
    @tail = Link.new
    @head.next = @tail
    @tail.prev = @head
  end

  def [](i)
    each_with_index { |link, j| return link if i == j }
    nil
  end

  def first
    empty? ? nil : @head.next
  end

  def last
    empty? ? nil : @tail.prev
  end

  def empty?
    @head.next == @tail
  end

  def get(key)
    each { |link| return link.val if link.key == key }
    nil
  end

  def include?(key)
    any? { |link| link.key == key }
  end

  def insert(key, val)
    each { |link| return link.val = val if link.key == key }

    new_link = Link.new(key, val)
    current_last = @tail.prev

    current_last.next = new_link
    new_link.prev = current_last
    new_link.next = @tail
    @tail.prev = new_link

    new_link
  end

  def remove(key)
    each do |link|
      if link.key == key
        link.prev.next = link.next
        link.next.prev = link.prev
        link.next, link.prev = nil, nil
        return link.val
      end
    end

    nil
  end

  def each
    current_link = @head.next
    until current_link == @tail
      yield current_link
      current_link = current_link.next
    end
  end

  def to_s
    inject([]) { |acc, link| acc << "[#{link.key}, #{link.val}]" }.join(", ")
  end
end
```

## Interview Problems
`remove_dups` - write code to remove duplicates from an unsorted linked list
How would you solve this problem if a temporary buffer is not allowed?
``` ruby
def remove_dups(linked_list)
  curr_link = linked_list.head
  record = Hash.new
  until curr_link == linked_list.tail
    if record[curr_link.value]
      curr_link.prev.next = curr_link.next
      curr_link.next.prev = curr_link.prev
    else
      record[curr_link.value] = true
    end
    curr_link = curr_link.next
  end
  linked_list
end

# If hash is not allowed, use an O(N^2) approach
# For every iteration of current link, create a runner_link that checks the
# subsequent links for duplicates
```

`return_kth_to_last` - implement an algorithm to find the kth to last element
of a singly linked list
``` ruby
# Assume that we don't know the size of the linked list. First compute its size
# by going through the list. Then find the k-th element.
```

`delete_middle_node` - implement an algorithm to delete a node in the middle
(i.e. any node but the first and last node, not necessarily the exact middle)
of a singly linked list, gien
