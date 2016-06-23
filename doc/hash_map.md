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

__Hash Dictionary__: Suppose a hash representing a directory. All keys are
strings with names for either folders or files. Keys that are folders point
to nested hashes. Keys that are files point to "true". Write a function
that takes such a hash and returns an array of strings with the path to
each file in the hash.
__Example__:
```
files = {
  'a' => {
    'b' => {
      'c' => {
        'd' => {
          'e' => true
        },

        'f' => true
      }
    }
  }
}

file_list(files) # => ['a/b/c/d/e', 'a/b/c/f']
```
``` ruby
def file_list(hash)
  files = []
  hash.each do |item, nested_item|
    if nested_item.is_a?(Hash)
      folder = item
      nested_files = file_list(nested_item)
      nested_files.each { |file| files << "#{folder}/#{file}" }
    else
      files << item
    end
  end
  files
end
```
```
Walk through example:
files = {
  'a' => {
    'b' => true,
    'c' => true
  }
}

file_list(files)
Initialize files => [], an empty array
files.each do |item, nested_item|
item = 'a'
nested_item = {'b' => true, 'c' => true}
Set folder = 'a'
Since nested_item is a hash, we open another stack and call:
  file_list({'b' => true, 'c' => true})
  Initialize files => []
  files.each do |item, nested_item|
  item = 'b', 'c'
  nested_item is not a hash, so items will go into files
  return ['b', 'c']
Now nested_files = ['b', 'c']
nested_files.each do |file|
files << 'a/b'
files << 'a/c'
and etc...

Another example:
files = {
  'a' => {
    'b' => { 'c' => true },
    'd' => { 'e' => true, 'f' => true }
  }
}
Initialize files => []
files.each do |item, nested_item|
item = 'a'
nested_item = {
  'b' => { 'c' => true },
  'd' => { 'e' => true, 'f' => true }
}
Set folder = 'a'
Since nested_item is a hash, open another stack and make call:
  file_list({'b' => { c => true }, 'd' => { 'e' => true, 'f' => true }})
  Initialize files = []
  files.each do |item, nested_item|
  item = 'b', 'd'
  nested_item => { 'c' => true }, { 'e' => true, 'f' => true }
  Set folder = 'b' and 'd'
  Since nested_item is a hash again, open another stack and call:
    file_list(...)
    Initialize files = []
    files.each do |item, nested_item|
    item = c, e, f
    return ['c'], ['e', 'f']
  Now we can do nested_files.each |file|
  files << "b/c"
  files << "c/e"
  files << "c/f"
  return files = ["b/c", "c/e", "c/f"]
We have those nested files at this stack now, ["b/c", "c/e", "c/f"], do
nested_files.each do |file| again
["a/b/c", "a/c/e", "a/c/f"] is the final result
```
