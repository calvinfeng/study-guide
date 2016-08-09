"use strict";
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

// var strArr = ["abc", "xyz", "opq", "rst", "uvw", "efg"];
// console.log(stringSort(strArr));

function iterativeDFS(root, target) {
  let stack = [root];
  while (stack.length > 0) {
    let currentNode = stack.pop();
    if (currentNode.value === target) {
      return currentNode;
    } else {
      let children = currentNode.children;
      for (let i = children.length - 1; i >= 0; i--) {
        stack.push(children[i]);
      }
    }
  }
  return null;
}

function breadthFirst(root, target) {
  let queue = [root];
  while (queue.length > 0) {
    let currentNode = queue.shift();
    if (currentNode.value === target) {
      return currentNode;
    } else {
      let children = currentNode.children;
      for (let i = 0; i < children.length; i++) {
        queue.push(children[i]);
      }
    }
  }
  return null;
}

class TreeNode {
  constructor(value) {
    this.value = value;
    this.children = [];
  }
}

let root = new TreeNode(0);
let a = new TreeNode(1.1);
let b = new TreeNode(1.2);
let c = new TreeNode(1.3);
let d = new TreeNode(2.1);
let e = new TreeNode(2.2);
let f = new TreeNode(2.3);

root.children.push(a,b,c);
a.children.push(d, e);
b.children.push(f);

console.log(iterativeDFS(root, 4));
console.log(breadthFirst(root, 4));

// Frontend Angular JS
// MySQL
// Java
// 7~8 People on a team
// secure
// testable
// rgonugunta@clearslide.com
