require_relative 'heap2'

class PriorityMap
  def initialize(&prc)
    @map = {}
    @queue = BinaryMinHeap.new do |key1, key2|
      prc.call(@map[key1], @map[key2])
    end
  end

  def [](key)
    return nil unless @map.has_key?(key)
    @map[key]
  end

  def []=(key, value)
    if @map.has_key?(key)
      update(key, value)
    else
      insert(key, value)
    end
  end

  def count
    @map.count
  end

  def empty?
    count == 0
  end

  def extract
    #key is the vertex, while value is the cost 
    key = @queue.extract
    value = @map.delete(key)
    [key, value]
  end

  def has_key?(key)
    @map.has_key?(key)
  end

  protected
  attr_accessor :map, :queue

  def insert(key, value)
    @map[key] = value
    @queue.push(key)
  end

  def update(key, value)
    throw "key does not exist" unless @map.has_key?(key)
    @map[key] = value
    @queue.reduce!(key)
    nil
  end
end
