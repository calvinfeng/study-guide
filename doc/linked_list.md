# Linked List
LinkedList is ideal for fast insertion/deletion. It may not offer an efficient
lookup like indexing into an array but if items are constantly removed/added, then
it's better to use LinkedList instead of an array. Inserting into middle of an array
takes O(n) time, because all trailing elements need to copy over to next spot.
LinkedList also maintains order.

## Implementation
### Doubly Linked List
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
### Singly Linked List
Occasionally, actually only once for me, that singly linked list will show up on an
interview. Singly linked list seems easier to implement that doubly linked list on a
first glance but deletion in singly linked list requires a second thought.

Each link inside a singly linked list does not have a pointer to its previous link. That
is problematic for deletion because when you try to remove a link, you need to connect
its previous link to its next link. Thus, we need two link runners.

``` ruby
class Link
  attr_accessor :val, :next
  def initialize(val)
    @val = val
    @next = nil
  end
end

class SinglyLinkedList
  attr_reader :head, :tail

  def initialize
    @head = Link.new("head")
    @tail = @head
  end

  def is_empty?
    @head == @tail
  end

  def first_link
    is_empty? ? null : @head.next
  end

  def insert(val)
    new_link = Link.new(val)
    @tail.next = new_link
    @tail = new_link
  end

  def delete(val)
    if is_empty?
      raise "linked list is empty"
    else
      this_link = @head.next
      prev_link = @head
      while this_link != @tail
        if this_link.val == val
          prev_link.next = this_link.next
          this_link = this_link.next
        else
          prev_link = this_link
          this_link = this_link.next
        end
      end

      if @tail.val == val
        @tail = prev_link
        prev_link.next = nil
      end
    end
  end

  def to_s
    str = ""
    current_link = @head
    while current_link != @tail
      str += current_link.val.to_s + " "
      current_link = current_link.next
    end
    str + @tail.val.to_s
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
# by going through the list. Then find the k-th element. The more optimal one
# would be creating two pointers. We place them k nodes apart. Then, when
# we move them at the same pace, p2 will hit the end and p1 will be the target

# 01 02 03 04 05 06 07 08 09
# p1    p2
#    p2    p2
# ...
#                   p1    p2
def return_kth_to_last(k, list)
  p1 = list.first
  p2 = list.first

  i = 0
  while i < k
    return nil if p2 == nil
    p2 = p2.next
    i += 1
  end

  while p2 != list.last
    p1 = p1.next
    p2 = p2.next
  end
  p1
end
```

`sum_lists` - you have two numbers represented by a linked list, where each node
contains a single digit. The digits are stored in reverse order, such that
1's digit is at the head of the list. Write a function that adds the two
numbers and returns the sum as a linked list.
Example:
Input: (7 -> 1 -> 6) + (5 -> 9 -> 2) = 617 + 295

``` ruby
def sum_lists(list1, list2)
  resultant_list = LinkedList.new
  runner1 = list1.head
  runner2 = list2.head
  carry_over = 0
  until runner1.nil? && runner2.nil?
    if runner1.nil?
      digit_sum = runner2.value + carry_over
    elsif runner2.nil?
      digit_sum = runner1.value + carry_over
    else
      digit_sum = runner1.value + runner2.value + carry_over
    end
    carry_over = digit_sum/10
    digit_sum = digit_sum % 10
    resultant_list.insert(digit_sum)

    runner1 = runner1.next unless runner1.nil?
    runner2 = runner2.next unless runner2.nil?
  end
  resultant_list
end
```
