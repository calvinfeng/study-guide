# Longest Common Subsequence
require 'benchmark'
# DO NOT CONFUSE subsequence with substrings
# Letters in a subsequence do not need to appear consecutive, while
# substrings do

# Using dynamic programming by breaking problem into subproblems and
# store them in a matrix
def dynamic_lcs(str1, str2)
  c = []
  0.upto(str1.length) do |i|
    row = []
    0.upto(str2.length) do |j|
      row << {value: 0, subseq: ""}
    end
    c << row
  end

  0.upto(str1.length) do |i|
    0.upto(str2.length) do |j|
      unless i == 0 || j == 0
        if str1[i-1] != nil && str2[j-1] != nil && str1[i-1] == str2[j-1]
          c[i][j][:value] = c[i-1][j-1][:value] + 1
          c[i][j][:subseq] = c[i-1][j-1][:subseq] + str1[i-1]
        elsif c[i][j-1][:value] > c[i-1][j][:value]
          c[i][j][:value] = c[i][j-1][:value]
          c[i][j][:subseq] = c[i][j-1][:subseq]
        else
          c[i][j][:value] = c[i-1][j][:value]
          c[i][j][:subseq] = c[i-1][j][:subseq]
        end
      end
    end
  end
  printMatrix(c)
  c[str1.length][str2.length]
end

def printMatrix(mat)
  0.upto(mat.length - 1) do |row|
    str = ""
    0.upto(mat[row].length - 1) do |col|
      str << mat[row][col][:value].to_s + " "
    end
    puts str
  end
end

def brute_force_lcs(str1, str2)
  subseqs1 = subseqs(str1)
  subseqs2 = subseqs(str2)
  longest_subseq = ""
  subseqs1.each do |sub1|
    subseqs2.each do |sub2|
      if sub1 == sub2 && sub1.length > longest_subseq.length
        longest_subseq = sub1
      end
    end
  end
  longest_subseq
end

def subseqs(str)
  return [str] if str.length == 1
  subseqs(str[0...str.length - 1]).map {|el| el + str[str.length - 1]} +
  subseqs(str[0...str.length - 1]) +
  [str[-1]]
end

dna_letters = ["a", "c", "g", "t"]
dna1 = ""
dna2 = ""
10.times do |i|
  dna1 << dna_letters[rand(4)]
  dna2 << dna_letters[rand(4)]
end
# dna1 = "acbcefg"
# dna2 = "abcdaefg"

puts dna1
puts dna2
puts Benchmark.measure { p dynamic_lcs(dna1, dna2) }
puts Benchmark.measure { p brute_force_lcs(dna1, dna2) }

#=======================================================================
# Longest Common Substrings
# Brute force
def substrings(str)
  subseq = []
  0.upto(str.length - 1) do |i|
    (i).upto(str.length - 1) do |j|
      subseq << str[i..j]
    end
  end
  subseq
end

# Find longest common substrings with brute force
def longest_common_substr(str1, str2)
  curr_longest = ""
  substrs1 = substrings(str1)
  substrs2 = substrings(str2)
  substrs1.each do |sub1|
    substrs2.each do |sub2|
      if sub1 == sub2 && sub1.length > curr_longest.length
        curr_longest = sub1
      end
    end
  end
  curr_longest
end
