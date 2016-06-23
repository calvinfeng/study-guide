# Radix Sort
What is a radix? It's the number of unique digits, including zero, used to
represent numbers in positional numeral system.

| Name        | Radix | Bits | Characters          |
| ----------- | ----- | ---- | ------------------- |
| binary      | 2     | 1    | 01                  |
| octal       | 8     | 3    | 01234567            |  
| decimal     | 10    | 4    | 0123456789          |
| hexadecimal | 16    | 4    | 0123456789ABCDEF    |
| DNA         | 4     | 2    | ACTG                |
| lower case  | 26    | 5    | abcdefg...          |
| upper case  | 26    | 5    | ABCDEFG...          |
| protein     | 20    | 5    | ACDEFGHIKLMNPQRSTVWY|
| base64      | 64    | 6    | ABC...abc...0123... |
| ASCII       | 128   | 7    | ASCII characters    |
| Unicode     | 65536 | 16   | Unicode characters  |

## Performance of Sorting Algorithms
| Algorithm | Guarantee     | Stable? | Space    |
| --------- | ------------- | ------- | -------- |
| insertion | N^2 / 2       | yes     | 1        |
| mergesort | N log(N)      | yes     | N        |
| quicksort | 1.39 N log(N) | no      | c log(N) |
| heapsort  | 2 N log(N)    | no      | 1        |

Lower bound: ~ N log(N) compares required by any compare-based algorithms

Can we do better? Yes if we don't depend on comparing keys.

## Key-indexed Counting
Assumption: keys are integers between 0 and R - 1
Implication: We can use key as an array index
Goal: Sort an array arr[] of N letters between 0 and R - 1
* Count frequencies of each letter using key as index
* Compute frequency cumulates which specify destination
* Access culumates using key as index to move items
* Copy back into original array

Java implementation uses static array, which is more efficient, but it requires
one to take care of the indexing. Ruby version is cleaner and more intuitive.
``` java
int N = a.length;
int[] count = new int[R + 1];
for (int i = 0; i < N; i++) count[a[i]+1]++;
for (int r = 0; r < R; r++) count[r+1] += count[r];
for (int i = 0; i < N; i++) aux[count[a[i]]++] = a[i];
for (int i = 0; i < N; i++) a[i] = aux[i];
```

It takes O(n) to iterate through the array once and count their frequency
of appearance with a counter array/hash.
It takes O(R + n) to go through the second loop. It has check O(R) times
for the if-statement and (in this case) within those 256 if-statements, it
has to push the elements *n* times into the final array.
``` ruby
def key_indexed_count(arr)
  # ASCII character has a radix of 256
  radix = 256
  count = []
  result = []
  arr.each do |el|
    idx = el.ord
    if count[idx]
      count[idx] += 1
    else
      count[idx] = 1
    end
  end

  (0...radix).each do |idx|
    if count[idx]
      until count[idx] == 0
        result << idx.chr
        count[idx] -= 1
      end
    end
  end
  result
end
```

## Two Classifications of Radix Sort
LSD - least significant digit radix sort
MSD - most significant digit radix sort

LSD string(radix) sort
* Consider characters from right to left
* Stably sort using d-th character as the key(using key-indexed counting)

``` ruby
class LSD
  # Assuming all strings in the array have same length, which is str_length
  def self.sort(str_arr, str_length)
    # assuming extended ASCII characters, there are 256 of them
    # use Ruby's ord method
    radix = 256
    (str_length - 1).downto(0) do | d |
      buffer = []
      count = []
      # Set everything to be zero, since can't set it to zero by default
      (0...radix).each do |idx|
        count[idx] = 0
      end
      str_arr.each do |str|
        idx = str[d].ord
        count[idx + 1] += 1
      end
      (0...radix - 1).each do |idx|
        count[idx + 1] += count[idx]
      end
      # the count array will indicate the appropriate index position
      # for the sorted string array
      (0...str_arr.length).each do |idx|
        i = str_arr[idx][d].ord
        buffer[count[i]] = str_arr[idx]
        count[i] += 1
      end
      str_arr = buffer
    end
    str_arr
  end
end
```

## Interview Problems
What is the most efficient way to sort 1 million 32 bit integers?

__Non Comparison Sort__:

Part 1: Say that I gave you an array of length n, containing the numbers 1..n in jumbled order. "Sort" this array in O(n) time. You should be able to do this without looking at the input.

Part 2: Say that I give you an array of length n with numbers in the range 1..N (N >= n). Sort this array in O(n + N) time. You may use O(N) memory.

Part 3: Say I give you an array of n strings, each of length k. I claim that, using merge sort, you can sort this in O(knlog(n)), since comparing a pair of strings takes O(k) time.

In theory, I can sort this with O(k*n) time using non comparison radix sort.
``` ruby
def sort1(jumbled_arr)
  (1..(jumbled_arr.length)).to_a
end

def sort2(array, max_val)
  counter = Array.new(max_val + 1, 0)
  result = []
  array.each do |el|
    counter[el] += 1
  end
  counter.each_index do |idx|
    counter[idx].times { result << idx }
  end
  result
end

def sort3(str_arr)
  (str_arr.first.length - 1).downto(0) do |d|
    str_arr = merge_sort(str_arr, d)
  end
  str_arr
end

def merge_sort(arr, idx)
  return arr if arr.empty? || arr.length == 1
  mid_idx = arr.length/2
  left_arr = merge_sort(arr.take(mid_idx), idx)
  right_arr = merge_sort(arr.drop(mid_idx), idx)
  merge(left_arr, right_arr, idx)
end

def merge(left, right, i)
  sorted_result = []
  until left.empty? || right.empty?
    if left[0][i].ord <= right[0][i].ord
      sorted_result << left.shift
    else
      sorted_result << right.shift
    end
  end
  if left.empty?
    sorted_result += right
  else
    sorted_result += left
  end
  sorted_result
end
```
