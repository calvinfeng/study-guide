# Stack and Queue
Stack and queue can be implemented with just an array but,
* Stack can only push and pop
* Queue can only push and shift

``` ruby
class Stack
  def initialize
    @store = []
  end

  def push(value)
    @store << value
  end

  def pop
    @store.pop
  end
end

class Queue
  def initialize
    @store = []
  end

  def enqueue(value)
    @store << value
  end

  def dequeue
    @store.shfit
  end
end
```
