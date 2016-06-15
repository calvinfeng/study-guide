function BinaryMaxHeap() {
  this.store = [];
}

BinaryMaxHeap.prototype.count = function() {
  return this.store.length;
};

BinaryMaxHeap.prototype.extract = function() {
  var tempHolder = this.store[0];
  this.store[0] = this.store[this.count() - 1];
  this.store[this.count() - 1] = tempHolder;
  var returnVal = this.store.pop();
  BinaryMaxHeap.heapifyDown(this.store, 0);
  return returnVal;
};

BinaryMaxHeap.prototype.peek = function() {
  return this.store[0];
};

BinaryMaxHeap.prototype.push = function(val) {
  this.store.push(val);
  BinaryMaxHeap.heapifyUp(this.store, this.count() - 1);
  return val;
};

BinaryMaxHeap.childIndices = function(length, parentIdx) {
  var childIndices = [];
  var firstChild, secChild;
  firstChild = parentIdx*2 + 1;
  secChild = parentIdx*2 + 2;

  if (firstChild < length) {
    childIndices.push(firstChild);
  }
  if (secChild < length) {
    childIndices.push(secChild);
  }
  return childIndices;
};

BinaryMaxHeap.parentIndex = function(childIdx) {
  if (childIdx === 0) {
    return null;
  } else {
    return Math.floor((childIdx - 1)/2);
  }
};

BinaryMaxHeap.heapifyUp = function(array, childIdx) {
  var parentIdx, temp;
  parentIdx = BinaryMaxHeap.parentIndex(childIdx);

  if (childIdx && childIdx > 0) {
    if (array[parentIdx] < array[childIdx]) {
      temp = array[parentIdx];
      array[parentIdx] = array[childIdx];
      array[childIdx] = temp;
    }
    //traversing upward
    BinaryMaxHeap.heapifyUp(array, parentIdx);
  }
};

BinaryMaxHeap.heapifyDown = function(array, parentIdx) {
  var childIdxes, temp;
  childIdxes = BinaryMaxHeap.childIndices(array.length, parentIdx);

  if (childIdxes.length === 2) {
    if (array[childIdxes[0]] > array[childIdxes[1]] && array[childIdxes[0]] > array[parentIdx]) {
      temp = array[parentIdx];
      array[parentIdx] = array[childIdxes[0]];
      array[childIdxes[0]] = temp;
      BinaryMaxHeap.heapifyDown(array, childIdxes[0]);
    } else if (array[childIdxes[1]] > array[parentIdx]){
      temp = array[parentIdx];
      array[parentIdx] = array[childIdxes[1]];
      array[childIdxes[1]] = temp;
      BinaryMaxHeap.heapifyDown(array, childIdxes[1]);
    }
  } else if (childIdxes.length === 1) {
    if (array[childIdxes[0]] > array[parentIdx]) {
      temp = array[parentIdx];
      array[parentIdx] = array[childIdxes[0]];
      array[childIdxes[0]] = temp;
      BinaryMaxHeap.heapifyDown(array, childIdxes[0]);
    }
  }
};

var sampleSize = 10000000;

var startTime = new Date();
var heap = new BinaryMaxHeap();
for (var i = 0; i < sampleSize; i ++) {
  heap.push(Math.floor(Math.random()*sampleSize));
}

var result = [];
for (i = 0; i < sampleSize; i ++) {
  result.push(heap.extract());
}
var endTime = new Date();
// console.log(heap);
// console.log(result);
console.log(endTime.getTime() - startTime.getTime());
