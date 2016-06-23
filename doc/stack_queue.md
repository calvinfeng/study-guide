# StackQueue

StackQueue is a queue that is implemented with stack. The sole purpose of making
this data structure is to solve the max window range problem.

## Implementation
``` ruby
class StackQueue
  def initialize
    @in, @out = [], []
  end

  def enqueue(value)
    @in << value
  end

  def dequeue
    if @out.empty?
      @out << @in.pop until @in.empty?
    end
    @out.pop
  end
end
```
We can modify the stack to be a MinMaxStack, so when elements are pushed into the stack, it has the ability to keep track of the min and max. Using MinMaxStack, we can create a queue, a sliding window, to keep track of the min and max of all the numbers inside the window.

``` ruby
class MinMaxStack
  def initialize
    @store = []
  end

  def length
    @store.length
  end

  def push(value)
    if @store.empty?
      @store << { value: value, min: value, max: value }
    else
      @store << {
        value: value,
        max: [@store.last[:max], value].max,
        min: [@store.last[:min], value].min
      }
    end
  end

  def pop
    (@store.pop)[:value]
  end

  def max
    @store.empty? ? nil : (@store.last)[:max]
  end

  def min
    @store.empty? ? nil : (@store.last)[:min]
  end
end

class MinMaxStackQueue
  def initialize
    @in, @out = MinMaxStack.new, MinMaxStack.new
  end

  def enqueue(value)
    @in.push(value)
  end

  def dequeue
    if @out.length == 0
      @out.push(@in.pop) until @in.length == 0
    end
    @out.pop
  end

  def length
    @in.length + @out.length
  end

  def max
    maxes = []
    maxes << @in.max if @in.length > 0
    maxes << @out.max if @out.length > 0
    maxes.max
  end

  def min
    mins = []
    mins << @in.min if @in.length > 0
    mins << @out.min if @out.length > 0
    mins.min
  end
end
```
## Interview Problems
Windowed Max Range - Given an array, and a window size `w`, find the maximum
`max - min` within a range of `w` elements

``` ruby
windowed_max_range([1, 0, 2, 5, 4, 8], 3) == 5 # => 0, 2, 5
windowed_max_range([1, 3, 2, 5, 4, 8], 5) == 6 # => 3, 2, 5, 4, 8
```
There is a naive solution to this problem, which takes O(n^2) time. It
considers all the subarrays of size w. Using MinMaxStackQueue, we can
turn this problem into O(n).

``` ruby
def windowed_max_range(array, window_size)
  max_range = nil
  queue = MinMaxStackQueue.new
  array.each do |el|
    queue.enqueue(el)
    if max_range.nil? || (queue.max - queue.min) > max_range
      max_range = (queue.max - queue.min)
    end

    if queue.length == window_size
      queue.dequeue
    end
  end
  max_range
end
```
