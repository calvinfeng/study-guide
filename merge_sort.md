# Merge Sort

## Implementation
``` ruby
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
```
