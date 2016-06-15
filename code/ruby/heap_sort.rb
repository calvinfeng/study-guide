require_relative "heap"
require 'byebug'
class Array
  def heap_sort!
    heap = BinaryMinHeap.new
    self.each do |el|
      heap.push(el)
    end
    self.each_index do |idx|
      self[idx] = heap.extract
    end
  end
end
