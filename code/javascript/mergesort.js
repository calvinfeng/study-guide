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
