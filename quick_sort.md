# Quick Sort

## Implementation
``` ruby
# Not in place, use O(n) memory
class QuickSort
  def self.sort(array)
    return array if array.empty?
    pivot_idx = rand(array.length)
    array[0], array[pivot_idx] = array[pivot_idx], array[0]

    pivot = array.first
    left = array.select {|el| pivot > el}
    middle = array.select {|el| pivot == el}
    right = array.select {|el| pivot < el}

    QuickSort.sort(left) + middle + QuickSort.sort(right)
  end
end
```
The pivot is chosen randomly by selecting a random index in the array and
swap the random element with the first element. Due to recursion, this method
will take O(n) space. We can improve it by sorting in place.
``` ruby
class QuickSort
  def self.in_place_sort!(array, start = 0, length = array.length, &prc)
    prc ||= Proc.new {|el1, el2| el1 <=> el2}
    return array if length < 2

    pivot_idx = partition(array, start, length, &prc)
    left_length = pivot_idx - start
    right_length = length - (left_length + 1)

    in_place_sort!(array, start, left_length, &prc)
    in_place_sort!(array, pivot_idx + 1, right_length, &prc)
    array
  end

  def self.partition(array, start, length, &prc)
    prc ||= Proc.new {|el1, el2| el1 <=> el2}
    pivot_idx, pivot = start, array[start]
    ((start + 1)...(start+length)).each do |idx|
      val = array[idx]
      if prc.call(pivot, val) == 1
        array[idx] = array[pivot_idx + 1]
        array[pivot_idx + 1] = pivot
        array[pivot_idx] = val
        pivot_idx += 1
      end
    end
  end
end
```
`partition` will iterate through every index. Whenever `array[idx]` is greater
than the pivot. It will first get replaced  with the element after pivot, which
is `array[pivot_idx + 1]`.
Then the pivot will take over the spot at `array[pivot_idx + 1]`.

At last, put the value in pivot's origin position which is `array[pivot_idx]`.
