function Node(value) {
  this.value = value;
  this.left = null;
  this.right = null;
}

function BSTree() {
  this.root = undefined;
  this.nodeCount = 0;
}

BSTree.prototype.insert = function(value) {
  if (this.root) {
    BSTree.insert(this.root, value);
    this.nodeCount += 1;
  } else {
    this.root = new Node(value);
  }
};

BSTree.insert = function(node, value) {
  if (node) {
    if (value <= node.value) {
      node.left = BSTree.insert(node.left, value);
    } else {
      node.right = BSTree.insert(node.right, value);
    }
    return node;
  } else {
    return new Node(value);
  }
};

BSTree.prototype.find = function(value) {
  return BSTree.find(this.root, value);
};

//Class method is the way to go, just because we want to do a recursive
//version of the find method. If we do iterative, we can start with the
//instance method
BSTree.find = function(node, value) {
  if (node) {
    if (value < node.value) {
      return BSTree.find(node.left, value);
    } else if (node.value < value) {
      return BSTree.find(node.right, value);
    } else {
      return node;
    }
  } else {
    return null;
  }
};

BSTree.prototype.max = function() {
  return BSTree.max(this.root).value;
};

BSTree.prototype.min = function() {
  return BSTree.min(this.root).value;
};

BSTree.prototype.height = function() {
  return BSTree.height(this.root);
};

BSTree.prototype.inorder = function() {
  return BSTree.inorder(this.root);
};

BSTree.prototype.delete = function(value) {
  BSTree.delete(this.root, value);
};

BSTree.max = function(node) {
  // The right most node is the max
  if (node) {
    if (node.right) {
      return BSTree.max(node.right);
    } else {
      return node;
    }
  } else {
    return null;
  }
};

BSTree.min = function(node) {
  // The left most node is the min
  if (node) {
    if (node.left) {
      return BSTree.min(node.left);
    } else {
      return node;
    }
  } else {
    return null;
  }
};

BSTree.height = function(node) {
  if (node) {
    if (!node.left && !node.right) {
      return 0;
    } else {
      var depth = [];
      if (node.left) {
        depth += [1 + BSTree.height(node.left)];
      }
      if (node.right) {
        depth += [1 + BSTree.height(node.right)];
      }
      return Math.max(...depth);
    }
  } else {
    return -1;
  }
};

BSTree.inorder = function(node) {
  if (node) {
    var arr = [];
    arr += BSTree.inorder(node.left);
    arr += [node.value];
    arr += BSTree.inorder(node.right);
    return arr;
  } else {
    return [];
  }
};

BSTree.deleteMin = function(node) {
  if (node) {
    if (node.left) {
      node.left = BSTree.deleteMin(node.left);
      return node;
    } else {
      return node.right;
    }
  } else {
    return null;
  }
};

BSTree.delete = function(node, value) {
  if (node) {
    if (value < node.value) {
      node.left = BSTree.delete(node.left, value);
    } else if (node.value < value) {
      node.right = BSTree.delete(node.right, value);
    } else {
      if (!node.right) {
        return node.left;
      }
      if (!node.left) {
        return node.right;
      }
      //Once the node is found, replace it with the minimum from its right child
      var target = node;
      node = target.right.min();
      node.right = BSTree.deleteMin(node.right);
      node.left = target.left;
    }
  } else {
    return null;
  }
};


var tree = new BSTree();
while (tree.nodeCount < 10) {
  tree.insert(Math.floor(Math.random()*10));
}
console.log(tree.height());
