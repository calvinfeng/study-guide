# Stack and Queue
Stack and queue can be implemented with just an array but,
* Stack can only push and pop
* Queue can only push and shift

## Implementation
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
## Interview Problem

__Stack Min__ - How would you design a stack which, in addition to push and pop,
has a function `min` which returns the minimum element? Write a class for it
``` ruby
class MinStack
  def initialize
    @store = []
  end

  def pop
    raise "index out of bound" if @store.empty?
    @store.pop
  end

  def push(value)
    if @store.empty?
      @store << {value: value, min: value}
    else
      @store << {value: value, min: [@store.last[:min], value].min}
    end
  end

  def min
    return nil if @store.empty?
    @store.last[:min]
  end
end
```

__Stack of Plates__ - Imagine a stack of plates. If the stack gets too high,
it might topple. Therefore, in real life, we would likely start a new stack
when the previous stack exceeds some threshold. Implement a data structure
`SetOfStacks` that mimics this. `SetOfStacks` should be composed of several
stacks and should create a new stack once the previous one exceeds capacity.
`SetOfStacks.push()` and `SetOfStacks.pop()` should behave identically to
a single stack.
Follow-up: Implement a function popAt(idx) which performs a pop operation
on a specific sub-stack.
`
