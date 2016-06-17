require 'byebug'
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

letters = ["d","a","c","f","f","b","d","b","w","m","h","j"]
arr = ["calvin", "hellow","steven", ]
nums = ["123","412","121","001","415","990"]

p key_indexed_count(letters)
p LSD.sort(arr, 3)
p LSD.sort(nums, 3)
