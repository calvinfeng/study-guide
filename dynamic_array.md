# Dynamic Array (Ring Buffer)





# Interview Problems

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
