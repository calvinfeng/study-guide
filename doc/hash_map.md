# Hash map

## Implementation
``` ruby
class HashMap
  include Enumerable

  attr_reader :count

  def initialize(num_buckets = 8)
    @store = Array.new(num_buckets) { LinkedList.new }
    @count = 0
  end

  def include?(key)
    bucket(key).include?(key)
  end

  def set(key, val)
    delete(key) if include?(key)
    resize! if @count >= num_buckets

    @count += 1
    bucket(key).insert(key, val)
  end

  def get(key)
    bucket(key).get(key)
  end

  def delete(key)
    removal = bucket(key).remove(key)
    @count -= 1 if removal
    removal
  end

  def each
    @store.each do |bucket|
      bucket.each { |link| yield [link.key, link.val] }
    end
  end

  def to_s
    pairs = inject([]) do |strs, (k, v)|
      strs << "#{k} => #{v}"
    end
    "{\n" + pairs.join(",\n") + "\n}"
  end

  alias_method :inspect, :to_s
  alias_method :[], :get
  alias_method :[]=, :set

  private

  def num_buckets
    @store.length
  end

  def resize!
    old_store = @store
    @store = Array.new(num_buckets * 2) { LinkedList.new }
    @count = 0

    old_store.each do |bucket|
      bucket.each { |link| set(link.key, link.val) }
    end
  end

  def bucket(key)
    @store[key.hash % num_buckets]
  end
end
```

## Interview Problems
`consecutive_sequence` - Implement a function to determine the longest
consecutive sequence of integers from an array of integers. For example,
[1, 2, 5, 4, 3] has a sequence of 5. [100, 1, 20, 4, 3, 2] has a sequence
of 4 because of {1, 2, 3, 4}. Notice that the integers do not appear in order.
Write an algorithm that will complete this task in O(n) time.
You may assume that there can only be one sequence

``` ruby
# HINT:
# first iteration: add the integers to a set
# second iteration: delete an integer from the set if it has a consecutive partner
```
