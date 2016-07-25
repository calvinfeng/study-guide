/*
  This is a repository for hard coding interview problems from Cracking
  the Coding Interview 6th Edition, Chapter 17.

  The following code is written in JavaScript ES6
*/
'use strict';
//======================================================================
/*
  Adding Without Plus: write a function that adds two numbers.
  You should not use add or any arithmetic operators
*/
function bitAddNaive(num1, num2) {
  let binary1 = num1.toString(2);
  let binary2 = num2.toString(2);
  let length;
  if (binary1.length > binary2.length) {
    length = binary1.length;
    while (binary2.length < length) {
      binary2 = 0 + binary2;
    }
  } else {
    length = binary2.length;
    while (binary1.length < length) {
      binary1 = 0 + binary1;
    }
  }
  let sum = "";
  let carryOver = 0;
  for(let i = length - 1; i >= 0; i--) {
    if (binary1[i] === '1' && binary2[i] === '1') {
      if (carryOver > 0) {
        sum = '1' + sum;
        carryOver = 1;
      } else {
        sum = '0' + sum;
        carryOver = 1;
      }
    } else if (binary1[i] === '1' || binary2[i] === '1') {
      if (carryOver > 0) {
        sum = '0' + sum;
        carryOver = 1;
      } else {
        sum = '1' + sum;
        carryOver = 0;
      }
    } else {
      if (carryOver > 0) {
        sum = '1' + sum;
        carryOver = 0;
      } else {
        sum = '0' + sum;
        carryOver = 0;
      }
    }
  }
  if (carryOver > 0) {
    sum = '1' + sum;
  }
  return parseInt(sum, 2);
}

function bitAdd(sum, carry) {
  if (carry === 0) {
    console.log(`sum: ${sum}, carry: ${carry}`);
    return sum;
  } else {
    console.log(`sum: ${sum}, carry: ${carry}`);
    let sumBit = sum ^ carry;
    let carryBit = (sum & carry) << 1 ;
    return bitAdd(sumBit, carryBit);
  }
}

/*
  Shuffle: Write a method to shuffle a deck of card. It must be a perfect
  shuffle, in other words, each of the 52! permutation has to be equally
  likely. Assume that you are given a random number generator which is perfect.
*/

function shuffle(deck) {
  let deckSize = deck.length;
  let shuffled = [];
  while (shuffled.length < deckSize) {
    let randomIndex = Math.floor(Math.random()*deck.length);
    shuffled.push(deck[randomIndex]);
    deck.splice(randomIndex, 1);
  }
  return shuffled;
}

//This is the solution from CTCI
function anotherShuffle(deck) {
  for (let i = 0; i < deck.length ; i++) {
    let randomIndex = Math.floor(Math.random()*i);
    let temp = deck[randomIndex];
    deck[randomIndex] = deck[i];
    deck[i] = temp;
  }
  return deck;
}

// Assign each card an id, ranging from 1 to 52;
let deck = [];
for (let i = 1; i <= 52; i++) {
  deck.push(i);
}

/*
  Random Set: Write a method to randomly generate a set of m integers
  from an array of size n. Each element must have equal probability of being
  chosen.
*/


/*
  Missing Number: an array A constains all the integers from 0 to n,
  except for one number which is missing.

  In this problem, we cannot access an entire integer in A with a single
  operation. The elements of A are represented in binary, and the only
  operation we can use to access them is "fetch the jth bit of A[i],"
  which takes constaint time.

  Write code to find the missing integer. Can do you it in O(n) time?
*/
