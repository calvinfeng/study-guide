# Merge Sort

## Implementation
#### Ruby
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
#### JavaScript
``` javascript
function mergeSort(array) {
  if (array.length < 2) {
    return array;
  } else {
    let midIndex = Math.floor(array.length/2);
    let left = array.slice(0, midIndex);
    let right = array.slice(midIndex);
    return merge(mergeSort(left), mergeSort(right));
  }
}

function merge(left, right) {
  let merged = [];
  while (left.length > 0 && right.length > 0) {
    if (left[0] <= right[0]) {
      merged.push(left.shift());
    } else {
      merged.push(right.shift());
    }
  }
  return merged.concat(left, right);
}
```
