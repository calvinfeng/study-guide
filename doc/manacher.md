# Longest Palindromic Substring

The worst solution is O(n^3) which is to find all the substrings and then run
`isPalindrome?` on them.
Finding substrings is O(n^2) and for each substring we run O(n) check

This is a slightly better naive solution with O(n^2)
``` ruby
def longest_p_substring(str)
  longest = ""
  (0...str.length).each do |idx|
    left = idx - 1
    right = idx + 1
    odd_palindrome = [str[idx]]
    # You don't have to use array, but it feels more intuitive than using pure indices
    while left > 0 && right < str.length && str[left] == str[right]
      odd_palindrome.unshift(str[left])
      odd_palindrome.push(str[right])
      left -= 1
      right += 1
    end
    longest = odd_palindrome.join if odd_palindrome.length > longest.length

    left = idx
    right = idx + 1
    even_palindrome = []
    while left > 0 && right < str.length && str[left] == str[right]
      even_palindrome.unshift(str[left])
      even_palindrome.push(str[right])
      left -= 1
      right += 1
    end
    longest = even_palindrome.join if even_palindrome.length > longest.length
  end
  longest
end
```
So what's so bad about the solution above? The issue is that we are expanding
for every center. If we don't have to expand for the unnecessary situation, then
we can get the solution down to O(n) time

O(n) solution => Manacher's Algorithm
``` ruby
def manacher(str)
  t = "$##{str.chars.join('#')}#@"
  # pali is responsible for holding the length of palindrome centered at a given index
  pali = Array.new(t.length){0}
  # center and right boundary indices start at 0
  ctr, right = 0, 0
  (1...t.length - 1).each do |idx|
    mirr = 2*ctr - idx
    # Copy palindrome length from mirror, if idx is still within right boundary
    # Or else, use right - idx if pali[mirr] expands beyond the left boundary
    if idx < right
      pali[idx] = [right - idx, pali[mirr]].min
    end
    # Now we know we have at least pali[mirr] length for palindrome so we can skip checking those ones
    while t[idx + (1 + pali[idx])] == t[idx - (1 + pali[idx])]
      pali[idx] += 1
    end
    # if the palindrome at current index expands beyond the right boundary, we need to
    # reset the right boundary and re-center at idx
    if idx + pali[idx] > right
      ctr = idx
      right = idx + pali[idx]
    end
  end
  pali
end
```
