require 'byebug'

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

class BSTNode
  attr_accessor :left, :right
  attr_reader :value

  def initialize(value)
    @value = value
    @left = nil
    @right = nil
  end
end

def depth_lists(root)
  linkedlist_arr = []
  current_list = LinkedList.new
  current_list.insert(root.value, root) unless root.nil?
  until current_list.empty?
    linkedlist_arr << current_list
    parents = current_list
    current_list = LinkedList.new
    parents.each do |parent|
      parentNode = parent.val
      current_list.insert(parentNode.left.value, parentNode.left) unless parentNode.left.nil?
      current_list.insert(parentNode.right.value, parentNode.right) unless parentNode.right.nil?
    end
  end
  linkedlist_arr
end

rootNode = BSTNode.new(4)
rootNode.left = BSTNode.new(2)
rootNode.left.left = BSTNode.new(1)
rootNode.left.right = BSTNode.new(3)
rootNode.right = BSTNode.new(6)
rootNode.right.left = BSTNode.new(5)
rootNode.right.right = BSTNode.new(7)
depth_lists(rootNode)
