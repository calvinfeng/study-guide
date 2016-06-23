# Dynamic Array (Ring Buffer)

## Implementation
``` ruby
class DynamicArray
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
    @store[self.check_index(index)]
  end

  # O(1)
  def []=(index, value)
    @store[self.check_index(index)] = value
  end

  # O(1)
  def pop
    if @length == 0
      raise "index out of bounds"
    end
    @length -= 1
    @store[self.check_index(@length)]
  end

  # O(1) amortized; O(n) worst case.
  def push(val)
    if @length == @capacity
      self.resize!
    end
    @store[self.check_index(@length)] = val
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
```
## Interview Problems
`is_unique` - implement an algorithm to determine if a string has all unique
characters. What if you cannot use additional data structure?
``` ruby
# build a hash to count number of char appearance
def is_unique(str)
  letter_count = Hash.new
  str.chars.each do |char|
    if letter_count[char]
      return false
    else
      letter_count[char] = 1
    end
  end
  true
end

# no hash
def is_unique(str)
  str = str.chars.sort.join
  (1...str.length).each do |i|
    return false if str[i] == str[i - 1]
  end
  true
end
```

`check_permutation` - given two strings, write a method to decide if one is
a permutation of the other
``` ruby
# O(n) time by creating a hash for both strings
def check_permutation(str1, str2)
  str1_hash = Hash.new
  str1.chars.each do |char|
    if str1_hash[char]
      str1_hash[char] += 1
    else
      str1_hash[char] = 1
    end
  end

  str2_hash = Hash.new
  str2.chars.each do |char|
    if str2_hash[char]
      str2_hash[char] += 1
    else
      str2_hash[char] = 1
    end
  end

  str1_hash == str2_hash
end
```

`rotate_matrix` - given an image represented by an NxN matrix, where each pixel
in the image is 4 bytes, write a method to rotate the image by 90 degrees.
Can do you this place?
``` ruby
# first reverse each row array, and then do a transpose
# the result is that the matrix is rotated 90 degree counter-clockwise
def rotate_matrix(mat)
  rotated_mat = []
  mat.each_index do |i|
    reversed_row = []
    (mat[i].length - 1).downto(0) do |j|
      reversed_row << mat[i][j]
    end
    rotated_mat << reversed_row
  end

  (0...rotated_mat.length).each do |i|
    (i...rotated_mat[i].length).each do |j|
      rotated_mat[i][j], rotated_mat[j][i] = rotated_mat[j][i], rotated_mat[i][j]
    end
  end

  rotated_mat
end
```

`is_palindrome` - check if a string is a palindrome by using recursion
``` ruby
def is_palindrome?(str)
  return true if str.length <= 1
  if str[0] == str[str.length - 1]
    is_palindrome?(str[1...str.length - 1])
  else
    return false
  end
end
```
