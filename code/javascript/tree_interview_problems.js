var BSTree = require('./binary-search-tree.js');

function Node(value) {
  this.value = value;
  this.left = null;
  this.right = null;
}

/*
  This is not optimized but it's most intuitive. It runs in O(nlog(n)) time

  Question: How to get height of a binary search tree? Or any binary tree
  in general?
  Use recursion and DFS style
  Base case: If a node doesn't have any children, it's a leaf node, return 0
  Base case: If a node is null, return -1
  Inductive step: The height of a tree is the height of its left or right subtree
  plus one. But make sure to pick out the taller subtree.
*/
function getHeight(node) {
  if (node === null) {
    return -1;
  } else {
    return Math.max(getHeight(node.left), getHeight(node.right)) + 1;
  }
}

function isBalanced(root) {
  if (root === null) {
    return true;
  } else {
    var heightDiff = getHeight(root.left) - getHeight(root.right);
    if (Math.abs(heightDiff) > 1) {
      return false;
    } else {
      return isBalanced(root.left) && isBalanced(root.right);
    }
  }
}

/*
  This is the optimized version. It should run in O(n) time with O(h) space
*/
function checkHeight(root) {
  if (root === null) {
    return -1;
  } else {
    var leftHeight = checkHeight(root.left);
    if (leftHeight === false) {
      return false;
    }

    var rightHeight = checkHeight(root.right);
    if (rightHeight === false) {
      return false;
    }

    var heightDiff = Math.abs(leftHeight - rightHeight);
    if (heightDiff > 1) {
      return false;
    } else {
      return Math.max(leftHeight, rightHeight) + 1;
    }
  }
}

function checkBalance(root) {
  return checkHeight(root) !== false;
}

function validateBST(root) {
  if (root.left && root.right) {
    return (BSTree.max(root.left).value <= root.value &&
      BSTree.max(root.right).value > root.value) &&
        (validateBST(root.left) && validateBST(root.right));
  } else if (root.left) {
    return (BSTree.max(root.left).value <= root.value) &&
      validateBST(root.left);
  } else if (root.right) {
    return (BSTree.max(root.right).value > root.value) &&
      validateBST(root.right);
  } else {
    return true;
  }
}
var leftThree = new Node(10);
var leftTwo = new Node(3);
var leftOne = new Node(5);
var rightTwo = new Node(6);
var randomRoot = new Node(7);
var rightOne = new Node(8);
randomRoot.left = leftOne;
randomRoot.right = rightOne;
leftOne.left = leftTwo;
leftOne.right = rightTwo;
leftTwo.left = leftThree;
console.log(validateBST(randomRoot));


var sampleTree = new BSTree();
sampleTree.insert(5);
sampleTree.insert(2);
sampleTree.insert(1);
sampleTree.insert(3);
sampleTree.insert(7);
sampleTree.insert(6);
sampleTree.insert(8);
sampleTree.insert(9);
sampleTree.insert(10);
console.log(sampleTree.inorder());
console.log(isBalanced(sampleTree.root));
console.log(checkBalance(sampleTree.root));
console.log(validateBST(sampleTree.root));
