require_relative "static_array"

class DynamicArray
  attr_reader :length

  def initialize(size = 8)
    @store = StaticArray.new(size)
    @length = 0
    @capacity = size
  end

  # O(1)
  def [](index)
    if index >= length
      raise "index out of bounds"
    end
    @store[index]
  end

  # O(1)
  def []=(index, value)
    @store[index] = value
  end

  # O(1)
  def pop
    if @length == 0
      raise "index out of bounds"
    end
    @length -= 1
    @store[@length]
  end

  # O(1) ammortized; O(n) worst case. Variable because of the possible
  # resize.
  def push(val)
    if @length == @capacity
      self.resize!
    end
    @store[@length] = val
    @length += 1
  end

  # O(n): has to shift over all the elements.
  def shift
    if @length == 0
      raise "index out of bounds"
    end

    returnVal = @store[0]
    i = 1
    while i < @length do
      @store[i - 1] = @store[i]
      i += 1
    end
    @length -= 1
    returnVal
  end

  # O(n): has to shift over all the elements.
  def unshift(val)
    if @length == @capacity
      self.resize!
    end
    i = @length
    while i >= 0 do
      @store[i + 1] = @store[i]
      i -= 1
    end
    @length += 1
    @store[0] = val
  end

  protected
  attr_accessor :capacity, :store
  attr_writer :length

  def check_index(index)
  end

  # O(n): has to copy over all the elements to the new store.
  def resize!
    @capacity *= 2
  end
end
