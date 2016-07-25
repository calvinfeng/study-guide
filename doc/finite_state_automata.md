# Finite State Automata

## Naive
The naive approach toward string matching is that, given a string with
length n, and a pattern or substring with length m:

Using an example, string = "ababc" and pattern = "abc"

1. Iterate through `ababc` and `abc` simultaneously, using index i for string
and index j for pattern
2. Check `a`: string[0] == pattern[0],
3. Check `b`: string[1] == pattern[1],
4. Check `a`: string[2] != pattern[2], reset j to be 0
5. Check `a` again so string[2] == pattern[0]
6. Check `b`: string[3] == pattern[1] and so on...

This naive algorithm will run O(n*m) time.

## Keep Track of States
Ultimately, if we can avoid resetting the index j in the pattern string, we can optimize this algorithm to O(n + m). The trick is to keep track of states.

Let's say we are given a pattern string `abc`. We will have four states,
* State 0: No match or match empty string
* State 1: Match `a`
* State 2: Match `ab`
* State 3: Match `abc`

Now we construct a table, and we call this the transition table (it means how state should transition to another for a given input)

| States \ Input   | a       | b       | c       |
|------------------|---------|---------|---------|
| State 0: `empty` | State 1 | State 0 | State 0 |
| State 1: `a`     | State 1 | State 2 | State 0 |
| State 2: `ab`    | State 1 | State 0 | State 3 |
| State 3: `abc`   | Completion

![finite_state_automata]
[finite_state_automata]: ../img/finite_state_automata.png

#### Interpretation
At a given state, input is the character that you get from scanning through
a string. Say we are at State 0, and next incoming character is `a` then we
will proceed to State 1, else stay at State 0.

## Concrete Example
Using the original string `ababc`, pattern `abc`, and the transition table
we have constructed above. We will show how this finite state automata works.
```
Iteration #1
input = 'a'
state = 0 -> 1

Iteration #2
input = 'b'
state = 1 -> 2

Iteration #3
input = 'a'
state = 2 -> 1

Iteration #4
input = 'b'
state = 1 -> 2

Iteration #5
input = 'c'
state = 2 -> 3

Once state 3 is reached, it means substring is found
```
## Implementation
``` ruby
def transition_table(pattern, radix)
  table = Hash.new
  (0..pattern.length).each do |i|
    table["state:#{i}"] = {pattern: pattern[0...i]}
  end

  (0...pattern.length).each do |i|
    radix.each do |char|
      str = table["state:#{i}"][:pattern] + char
      discard_num = 0
      (i+1).downto(0) do |j|
        if table["state:#{j}"][:pattern] == str.chars.drop(discard_num).join
          table["state:#{i}"][char] = "state:#{j}"
          next
        end
        discard_num += 1
      end
    end
  end

  table
end

def is_match(string, pattern, radix)
  table = transition_table(pattern, radix)
  num_of_states = table.keys.length - 1
  current_state = "state:0"
  string.chars.each do |char|
    current_state = table[current_state][char]
    return true if current_state == "state:#{num_of_states}"
  end
  false
end
```

## Challenge
The challenge is in creating the transition table. Here's a basic rule of
thumb. We begin with State 0 with an empty string `""`. For the example above,
we have three radixes, they are `a`, `b`, and `c`.

Start at state 0, we append these radixes to the string of current state then we ask
```
is "a" a match for the string of state 1?
is "b" a match for the string of state 1?
is "c" a match for ...
...
```
Since `a` is a match for the string of state 1, so we will say that, at
state 0, given "a" as an input, we will transition to state 1. Since other
inputs are not a match for state 1, they will transition back to state 0.

At state 1, our string is `a`, we ask the same question again,
```
is "aa" a match for the string of state 2? No
-> we drop the "a" in the front,
is "a" a match for the string of state 1? Yes
-> "aa" -> state 1

is "ab" a match for the string of state 2? Yes
-> "ab" -> state 2

is "ac" a match for the string of state 2? No
-> we drop the "a" in the front,
is "c" a match for the string of state 1? No
-> we drop the "c" in the front,
is "" a match for the string of state 0? Yes
-> "ac" -> state 0
```

At state 2, our string is now `ab`, we do the same thing as above.
