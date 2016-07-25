# Binary Search

## Implementation
#### Ruby
``` ruby
def binary_search(sorted_arr, target)
  return nil if sorted_arr.empty?

  probe_idx = sorted_arr.length/2
  case target <=> sorted_arr[probe_idx]
  when -1
    # search in left
    binary_search(sorted_arr.take(probe_idx), target)
  when 0
    # target is found
    probe_idx
  when 1
    # search in right
    sub_answer = binary_search(sorted_arr.drop(probe_idx + 1), target)
    if sub_answer.nil?
      nil
    else
      # make sure to put in offset for the index
      probe_idx + 1 + sub_answer
    end
  end
end
```

#### JavaScript
``` javascript
function binarySearch(sortedArray, target) {
  if (sortedArray.length === 0) {
    return null;
  } else {
    let probeIndex = Math.floor(sortedArray.length/2);
    if (target < sortedArray[probeIndex]) {
      let left = sortedArray.slice(0, probeIndex);
      return binarySearch(left, target);
    } else if (target > sortedArray[probeIndex]) {
      let right = sortedArray.slice(probeIndex + 1);
      let subAnswer = binarySearch(right, target);
      if (subAnswer) {
        return probeIndex + subAnswer + 1;
      } else {
        return null;
      }
    } else {
      return probeIndex;
    }
  }
}
```
## Interview Problems
`three_sum` - Write a function to determine whether any 3 elements in an
array sum to zero or any target. Brute force will take O(n^3) time, a better
solution will take O(n^2 log(n)) time. An even better solution will take O(n^2) time
with O(n) space.
