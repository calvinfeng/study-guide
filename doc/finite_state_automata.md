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
