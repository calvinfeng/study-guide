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
