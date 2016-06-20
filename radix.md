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
