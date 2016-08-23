# Algorithm Design Canvas
The algorithm design canvas captures the process for tackling algorithm design
problems. It's the most convenient way to represent algorithmic thinking.
Every algorithmic problem, big or small, easy or hard, should eventually
end up as a completed canvas.

![canvas]
[canvas]: http://www.hiredintech.com/data/uploads/the-algorithm-design-canvas.png

## 1. Constraints
How large the input array can be? Can the input string contain unicode characters?
Is the robot allowed to make diagonal moves in the maze, can graph have negative
edges?

Asking interviewer the right question will lead to insightful constraints

1. Strings, Arrays, and Numbers
  * How many elements can be in the array?
  * How large can each element be? If it's a string how long? if it's a number,
  what is the minimum and maximum value?
  * What is in each element? If it's a number, is it an integer or float? If it's
  a string, is it a single byte or multibyte (unicode)?
  * If the problem involves finding a subsequence, does "subsequence" mean
  that the elements must be adjacent or is there no such requirement?
  * Does the array contain unique numbers or can they be repeated?

2. Grids/Mazes
  * For problems where some actor (e.g. robot) is moving in a grid or a maze,
  what moves are allowed? Can the robot move diagonally (hence 8 valid moves),
  or only horizontally/vertically (hence only 4 valid moves)?
  * Are all cells in the grid allowed? Or can there be obstacles?
  * If the actor is trying to get from A to B, are A and B guaranteed to be
  different from each other?
  * If the actor is trying to get from A to B, is it guaranteed that there's
  a path between the two cells?

3. Graphs
  * How many nodes can the graph have?
  * How many edges can the graph have?
  * If the edges have weights, what is the range for the weights?
  * Can there be loops in the graph? Can there be negative-sum loops in the graph?
  * Is the graph directed or undirected?
  * Does the graph have multiple edges and/or self loops?

4. Return Values
  * What should my method return?
  * If there are multiple solutions to the problem, which one should be returned?
  * If it should return multiple values, do you have any preference on what to return?
  * What should I return if the input is invalid?
  * What to return if I can't find the element?

## 2. Ideas
After you've identified all the constraints, you go into idea generation.
Typically during interview you discuss 1 ~ 3 ideas. Often times you start
with one, explain it to the interviewer, and then move on to a better idea.

### Simplify the task
"A map of streets is given, which has the shape of a rectangular grid with N columns
and M rows. At the intersections of these streets there are people. They all want to meet
at one single intersection. The goal is to choose such an intersection, which
minimizes the total walking distance of all people. Remember that they can only
walk along the streets (the so called "Manhattan distance")"

So how can we approach this problem?
Imagine that we only have one street and people are at various positions
on that street. They will be looking for an optimal place to meet on this
street. Can you solve this problem? It turns out to be much easier than the
2D version. You just have to find the median value of all people's positions
on the street and this is an optimal answer.

Now if we go back to the original problem, we can notice that finding
the X and Y coordinates of the meeting point are two independent tasks.
This is because of teh way people move - Manhattan distance. This leads us
to the final conclusion that we have to solve two 1D problems.

### Try a few example
You may start noticing patterns if you try to solve a few sample inputs that
you create. It is okay to tell the interviewer that you would like to try
writing down a few examples in order to try to find some pattern.

Here is a sample problem:
"There are N + 1 parking spots, numbered from 0 to N. There are N cars numbered
from 1 to N parked in various parking spots with one left empty. Reorder the cars
so that car #1 is in spot #1, car #2 is in spot #2 and so on. Spot #0 will remain
empty. The only allowed operation is to take a car and move it to the free spot."

The key is, which car to move.

### Think of suitable data structures
For some problems it is more or less apparent that some sort of data structure will
do the job. If you start to get this feeling think about the data structures
you know about and try to apply them and see if they fit.

Example question:
"Design a data structure, which supports several operations: insert a number
with O(log n), return the median element with O(1), delete the median element
with O(log n), where n is the number of elements in the data structure"

We can use two heaps, one stores the one half smallest numbers and other is for the
other half biggest numbers.

### Think about related problems that you know
If you see a problem and cannot think of a solution, try to remember another
problem, which looks like it. If there is such, if its solution can somehow be
adjusted to work for the problem at hand. This can sometimes mislead you
but many problems are related, so it could also get you out of the situation.

## 3. Complexities
### Why is complexity so important?
Solving problem is not just about finding a way to compute the correct answer.
The solution should work quickly enough and with reasonable memory usage.
Therefore, you have to show the interviewer two things:

1. Your solution is good enough in terms of speed and memory
2. You are capable of evaluating the time and memory complexity of various algorithmic solutions

## 4. Code
After you've identified the problem's constraints, discussed a few ideas,
analyzed their complexities, and found one that both you and your interviewer
think is worth being implemented, you go into writing the code.

We see many people who jump straight into coding, ignoring all previous steps.
This is bad in real life, and it’s bad when done at your interview. Never, ever jump straight into coding before having thought about and discussed constraints, ideas and complexities with your interviewer.

* Think before you code: Especially if you're coding on a sheet of paper (where there is
  no undo), if you are not careful everything could become very messy very quickly
* Coding outside of an IDE does not give you permission to stop abiding by good code style
* It's even more important to decompose your code into small logical pieces
* Read your code multiple times before you claim it's ready.

## 5. Tests
Finally, you move on to writing test cases and testing your code.

Showing that you know and care about testing is a great advantage. It demonstrates that you fundamentally understand the important part testing plays in the software development process. It gives the interviewer confidence that once hired, you’re not going to start writing buggy code and ship it to production, and instead you’re going to write unit tests, review your code, work through example scenarios, etc.

### Sample tests vs Extensive tests
We call the first kind *sample* tests: these are small examples that you can feed to your code, and run through it line by line to make sure it works. You may want to do this once your code is written, or your interviewer may ask you to do it. The keyword here is "small": not "simple" or "trivial".

Alternatively, your interviewer may ask you to do more *extensive* testing, where they ask you to come up with some good test cases for your solution. Typically, you will not be asked to run them step-by-step. It is more of a mental test design exercise to demonstrate whether you're skilled at unit testing your code.

### Extensive Testing
* Edge cases
* Cases when there is no solution
* Non-trivial functional tests
* Randomized tests
* Load testing

### Sample Testing
Sample tests are small tests that you run your code on at the interview to make sure
it's solid. This combination (non-trivial functional + edge + no solution) tends to be the most effective.
For the amount of time it takes to design the tests and to run them on your code on a sheet of paper,
it gives you the highest certainty in your code.
