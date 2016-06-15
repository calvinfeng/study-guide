function Link(key, val) {
  this.key = key;
  this.val = val;
  this.next = undefined;
  this.prev = undefined;
}

// JSON is backed by hashMap so... I probably shouldn't cheat
Link.prototype.toString = function(){
  return this.key + ": " + this.val;
};

function LinkedList() {
  this.head = new Link();
  this.tail = new Link();
  this.head.next = this.tail;
  this.tail.prev = this.head;
}

LinkedList.prototype.isEmpty = function() {
  return this.head.next === this.tail;
};

LinkedList.prototype.first = function() {
  if (this.isEmpty()) {
    return null;
  } else {
    return this.head.next;
  }
};

LinkedList.prototype.last = function() {
  if (this.isEmpty()) {
    return null;
  } else {
    return this.tail.prev;
  }
};

LinkedList.prototype.insert = function(key, val) {
  var newLink = new Link(key, val);
  var currLast = this.tail.prev;
  // Connect them
  currLast.next = newLink;
  newLink.prev = currLast;
  newLink.next = this.tail;
  this.tail.prev = newLink;
  return newLink;
};

LinkedList.prototype.get = function(key) {
  var val;
  this.each(function(link) {
    if (link.key === key) {
      val = link.val;
    }
  });
  return val;
};

LinkedList.prototype.remove = function(key) {
  var returnVal;
  this.each(function(link) {
    if (link.key === key) {
      link.prev.next = link.next;
      link.next.prev = link.prev;
      link.next = undefined;
      link.prev = undefined;
      returnVal = link;
    }
  });
  return returnVal;
};

LinkedList.prototype.each = function(cb) {
  var currLink = this.head.next;
  while (currLink !== this.tail) {
    cb(currLink);
    if (currLink.next === undefined) {
      // In case of removal
      return null;
    }
    currLink = currLink.next;
  }
  return null;
};

LinkedList.prototype.isInclude = function(key) {
  var boolean = false;
  this.each(function(link) {
    if (link.key === key) {
      boolean = true;
    }
  });
  return boolean;
};

module.exports = LinkedList;
