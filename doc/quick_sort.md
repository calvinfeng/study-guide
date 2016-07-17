# Quick Sort

## Implementation
#### Ruby
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
is `array[pivot_idx + 1]`. Then the pivot will take over the spot at `array[pivot_idx + 1]`.

At last, put the value in pivot's origin position which is `array[pivot_idx]`.

#### JavaScript
We can throw a callback in for the JavaScript version to achieve the same
generality as above. But this version doesn't need to return any value because
we are modifying the array in place.
``` javascript
function inPlaceQuickSort(array, startIndex, arrayLength) {
  if (arrayLength >= 2) {
    let pivotIndex = partition(array, startIndex, arrayLength);
    let leftLength = pivotIndex - startIndex;
    let rightLength = arrayLength - leftLength - 1;
    inPlaceQuickSort(array, startIndex, leftLength);
    inPlaceQuickSort(array, pivotIndex + 1, rightLength);
  }
}

function partition(array, startIndex, subArrayLength) {
  let pivotIndex = startIndex;
  let pivot = array[startIndex];
  for (let i = startIndex + 1; i < startIndex + subArrayLength; i++) {
    let val = array[i];
    if (val < pivot) {
      array[i] = array[pivotIndex + 1];
      array[pivotIndex + 1] = pivot;
      array[pivotIndex] = val;
      pivotIndex += 1;
    }
  }
  return pivotIndex;
}
```

### Tail Recursion
Answer from Quora:
Tail recursion is a special kind of recursion where the recursive call is the very last thing in the function. It's a function that does not do anything at all after recursing.

This is important because it means that you can just pass the result of the recursive call through directly instead of waiting for it—you don't have to consume any stack space. A normal function, on the other hand, has to have a stack frame so that the compiler knows to come back to it (and have all the necessary variable values) after the recursive call is finished.

Some languages recognize this and implement "proper tail calls" or "tail call elimination": if they see a recursive call in tail position, they actually compile it into a jump that reuses the current stack frame instead of calling the function normally. This improves the memory usage of the function asymptotically and prevents it from overflowing the stack. With this behavior, tail recursion is actually generally a good thing: chances are you do want to write your functions in a tail-recursive form if you can.
