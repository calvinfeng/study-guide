require 'benchmark'

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

puts Benchmark.measure {fibonacci_dynamic(35)}
puts Benchmark.measure {fibonacci(35)}
puts Benchmark.measure { p fibs_dynamic(35) }
puts Benchmark.measure { p fibs(35)}
