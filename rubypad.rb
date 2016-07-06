require 'benchmark'
require 'byebug'

def fibs(n)
  return [] if n <= 0
  return [1] if n == 1
  return [1, 1] if n == 2
  fibs(n-1) + [fibs(n-1).last + fibs(n-2).last]
end

$record = Hash.new
def fibs_dynamic(n)
  return [] if n <= 0
  return [1] if n == 1
  return [1, 1] if n == 2
  return $record[n] if $record[n]
  $record[n] = fibs_dynamic(n-1) + [fibs_dynamic(n-1).last + fibs_dynamic(n-2).last]
  $record[n]
end

def fibonacci(n)
  return 0 if n == 0
  return 1 if n == 1
  return fibonacci(n - 1) + fibonacci(n - 2)
end

def fibonacci_dynamic(n)
  return 0 if n == 0
  a, b = 0, 1
  i = 2
  while (i < n)
    c = a + b
    a = b
    b = c
    i += 1
  end
  a + b
end
# puts Benchmark.measure {fibonacci_dynamic(35)}
# puts Benchmark.measure {fibonacci(35)}
# puts Benchmark.measure { p fibs_dynamic(35) }
# puts Benchmark.measure { p fibs(35)}
def minimal_insert(bstree, arr)
  if arr.length == 1
    #bstree.insert(arr[0])
    bstree << arr[0].to_s
  elsif arr.length == 0
    # do nothing
  else
    mid_idx = arr.length/2
    #bstree.insert(arr[mid_idx])
    bstree << arr[mid_idx].to_s
    # Recurse on left sub-array
    minimal_insert(bstree, arr.take(mid_idx))
    # Recurse on right sub-array
    minimal_insert(bstree, arr.drop(mid_idx + 1))
  end
end

# str = ""
# minimal_insert(str, [1,2,3,4,5,6,7])

# O(k nlog(n)) time, with each string has length k
def string_sort(str_arr)
  (str_arr.first.length - 1).downto(0) do |d|
    str_arr = merge_sort(str_arr, d)
  end
  str_arr
end

def merge_sort(arr, idx)
  return arr if arr.empty? || arr.length == 1
  mid_idx = arr.length/2
  left_arr = merge_sort(arr.take(mid_idx), idx)
  right_arr = merge_sort(arr.drop(mid_idx), idx)
  merge(left_arr, right_arr, idx)
end

def merge(left, right, i)
  sorted_result = []
  until left.empty? || right.empty?
    if left[0][i].ord <= right[0][i].ord
      sorted_result << left.shift
    else
      sorted_result << right.shift
    end
  end
  if left.empty?
    sorted_result += right
  else
    sorted_result += left
  end
  sorted_result
end

def triple_step_dynamic(n, memo = Hash.new)
  return [[]] if n == 0
  return [[1]] if n == 1
  return [[1,1],[2]] if n == 2

  result = []
  memo[n - 1] = triple_step_dynamic(n - 1, memo) unless memo[n - 1]
  result += memo[n - 1].map do |combo|
    combo + [1]
  end

  memo[n - 2] = triple_step_dynamic(n - 2, memo) unless memo[n - 2]
  result += memo[n - 2].map do |combo|
    combo + [2]
  end

  memo[n - 3] = triple_step_dynamic(n - 3, memo) unless memo[n - 3]
  result += memo[n - 3].map do |combo|
    combo + [3]
  end
  result
end

def triple_step(n)
  return [[]] if n <= 0
  return [[1]] if n == 1
  return [[1,1], [2]] if n == 2
  result = []
  result += triple_step(n - 1).map do |combo|
    combo + [1]
  end
  result += triple_step(n - 2).map do |combo|
    combo + [2]
  end
  result += triple_step(n - 3).map do |combo|
    combo + [3]
  end
  result
end

# puts Benchmark.measure {triple_step(25)}
# puts Benchmark.measure {triple_step_dynamic(25)}

def find_magic_index(arr, start_idx, end_idx)
  return nil if end_idx < start_idx
  mid = (start_idx + end_idx)/2
  if arr[mid] == mid
    mid
  elsif arr[mid] > mid
    find_magic_index(arr, start, mid - 1)
  else
    find_magic_index(arr, mid + 1, end_idx)
  end
end

def make_change(total, m, coins)
  return 0 if total < 0 || m < 0
  return 1 if total == 0
  return make_change(total, m - 1, coins) + make_change(total - coins[m], m, coins)
end

p make_change(100, 3, [1,5,10,25])
