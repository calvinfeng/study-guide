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
