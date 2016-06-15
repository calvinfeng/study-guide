require_relative "static_array"
require 'byebug'
class RingBuffer
  attr_reader :length

  def initialize(size = 8)
    @store = StaticArray.new(size)
    @start_idx = 0
    @length = 0
    @capacity = size
  end

  # O(1)
  def [](index)
    if index >= length
      raise "index out of bounds"
    end
    logical_index = self.check_index(index)
    @store[logical_index]
  end

  # O(1)
  def []=(index, val)
    logical_index = self.check_index(index)
    @store[logical_index] = val
  end

  # O(1)
  def pop
    if @length == 0
      raise "index out of bounds"
    end
    @length -= 1
    last_index = self.check_index(@length)
    @store[last_index]
  end

  # O(1) ammortized
  def push(val)
    if @length == @capacity
      self.resize!
    end
    last_index = self.check_index(@length)
    @store[last_index] = val
    @length += 1
  end

  # O(1)
  def shift
    if @length == 0
      raise "index out of bounds"
    end
    val = @store[@start_idx]
    @start_idx = (@start_idx + 1) % @capacity
    @length -= 1
    val
  end

  # O(1) ammortized
  def unshift(val)
    if @length == @capacity
      self.resize!
    end
    @length += 1
    @start_idx = (@start_idx - 1) % @capacity
    @store[@start_idx] = val
  end

  protected
  attr_accessor :capacity, :start_idx, :store
  attr_writer :length

  def check_index(index)
    (@start_idx + index) % @capacity
  end

  def resize!
    new_store = StaticArray.new(2*@capacity)
    i = 0
    while i < @length
      new_store[i] = @store[(@start_idx + i) % capacity]
      i += 1
    end
    @capacity *= 2
    @start_idx = 0
    @store = new_store
  end
end
