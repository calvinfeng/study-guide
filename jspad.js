var cache = {};
function dynamicFib(n) {
  if (n <= 0) {
    return [];
  } else if (n === 1) {
    return [1];
  } else if (n === 2) {
    return [1, 1];
  }

  if (cache[n]) {
    return cache[n];
  } else {
    cache[n] = dynamicFib(n - 1).concat(dynamicFib(n - 1)[dynamicFib(n - 1).length - 1] +
      dynamicFib(n - 2)[dynamicFib(n - 2).length - 1]);
    return cache[n];
  }
}

function fib(n) {
  if (n <= 0) {
    return [];
  } else if (n === 1) {
    return [1];
  } else if (n === 2) {
    return [1, 1];
  }
  return fib(n - 1).concat(fib(n - 1)[fib(n - 1).length - 1] +
    fib(n - 2)[fib(n - 2).length - 1]);
}

function stringSort(strArr) {
  for (var d = strArr[0].length - 1; d >= 0; d -= 1) {
    strArr = mergeSort(strArr, d);
  }
  return strArr;
}

function mergeSort(arr, i) {
  if (arr.length <= 1) {
    return arr;
  } else {
    var mid = Math.floor(arr.length/2);
    var left = arr.slice(0, mid);
    var right = arr.slice(mid, arr.length);
    return merge(mergeSort(left), mergeSort(right), i);
  }
}

function merge(left, right, i) {
  var result = [];
  while (left.length !== 0 && right.length !== 0) {
    if (left[0].charCodeAt(i) <= right[0].charCodeAt(i)) {
      result.push(left.shift());
    } else {
      result.push(right.shift());
    }
  }
  if (left.length === 0) {
    return result.concat(right);
  } else {
    return result.concat(left);
  }
}

var strArr = ["abc", "xyz", "opq", "rst", "uvw", "efg"];
console.log(stringSort(strArr));
