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
