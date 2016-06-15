class MergeSort
  def self.sort(array)
    return array if array.length < 2
    middle = array.length/2
    left, right = array.take(middle), array.drop(middle)
    sorted_left, sorted_right = MergeSort.sort(left), MergeSort.sort(right)
    MergeSort.merge(sorted_left, sorted_right)
  end

  def self.merge(left, right)
    merged_array = []
    until left.empty? || right.empty?
      merged_array << ((left.first < right.first) ? left.shift : right.shift)
    end
    merged_array + left + right
  end
end

def binary_search(sorted_arr, target)
  return nil if sorted_arr.empty?

  probe_idx = sorted_arr.length/2
  case target <=> sorted_arr[probe_idx]
  when -1
    # Search in left
    binary_search(sorted_arr.take(probe_idx), target)
  when 0
    # Target is found
    probe_idx
  when 1
    # Search in right
    # Make sure to put in offset for the index
    sub_answer = binary_search(sorted_arr.drop(probe_idx + 1), target)
    if sub_answer.nil?
      nil
    else
      probe_idx + 1 + sub_answer
    end
  end
end
