# Dynamic Programming
Dynamic programming is mostly just a matter of taking a recursive algorithm
and finding the overlapping subproblems (that is, the repeated calls.) You
then cache those results for future recursive calls.

Some people call top-down dynamic programming "memorization" and only use
"dynamic programming" to refer to bottom-up work.

## Classic Example: Fibonacci
The recursive version
``` ruby
def fib(n)
  return 0 if n == 0
  return 1 if n == 1
  return fib(i - 1) + fib(i - 2)
end
```
### Top-Down Dynamic Approach
There are a lot repeated calls in the fib recursion. In fact, we should only
compute O(n) calls and rest should be cached. This is what memorization is
all about.

``` ruby
# Write a function, fibs(num) which returns the first n elements from
# the Fibonacci sequence, given n.
# Current time complexity is ~ 2.4^n power, exponentially
require 'benchmark'
def fibs(n)
  return [] if n <= 0
  return [1] if n == 1
  return [1, 1] if n == 2
  fibs(n-1) + [fibs(n-1).last + fibs(n-2).last]
end

$record = Hash.new
def fibs_dynamic(n)
  return [] if n <= 0
  return [1] if n == 1
  return [1, 1] if n == 2
  return $record[n] if $record[n]
  $record[n] = fibs_dynamic(n-1) + [fibs_dynamic(n-1).last + fibs_dynamic(n-2).last]
  $record[n]
end

puts Benchmark.measure { fibs_dynamic(22) }
puts Benchmark.measure { fibs(22)}
```

### Bottom-Up Dynamic Approach
Think about doing the same thing as the recursive memorized approach, but
in reverse. All we need is the first two base cases and we can construct
any Fibonacci number out of them.
``` ruby
def fibonacci(n)
  return 0 if n == 0
  a, b = 0, 1
  i = 2
  while (i < n)
    c = a + b
    a = b
    b = c
    i += 1
  end
  a + b
end
```

## LCS: Longest Common Subsequence
 
``` ruby
# Write a function, common_substrings(str1, str2) that takes two strings and returns
# the longest common substring. This is known as the LCS problem. (NP-hard)
# Use Suffix tree and Dynamic Programming to solve
def common_substrings(str1, str2)
  # Naive Solution
  longest_substr = ""
  substr1 = Hash.new
  (0...str1.length).each do |i|
    (i..str1.length).each do |j|
      substr1[str1[i..j]] = true
    end
  end
  (0...str2.length).each do |i|
    (i..str2.length).each do |j|
      if substr1[str2[i..j]] && (j - i) > longest_substr.length
        longest_substr = str2[i..j]
      end
    end
  end
  longest_substr
end
```
