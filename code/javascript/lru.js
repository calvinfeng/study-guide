var LinkedList = require('./linked_list.js');

function LRUCache(max, cb) {
  this.map = {};
  this.store = new LinkedList();
  this.MAX = max;
  //imagine this callback is computationally heavy
  //if the result already exists, don't compute
  this.cb = cb;
}

LRUCache.prototype.count = function() {
  return Object.keys(this.map).length;
};

LRUCache.prototype.get = function(key) {
  if (this.map[key]) {
    var link = this.map[key];
    this.refreshLink(link);
    return link.val;
  } else {
    var val = this.calc(key);
    return val;
  }
};

LRUCache.prototype.calc = function(key) {
  var val = this.cb.call(key);
  var newLink = this.store.insert(key, val);
  this.map[key] = newLink;

  if (this.count() > this.MAX) {
    this.eject();
  }
  return val;
};

LRUCache.prototype.refreshLink = function(link) {
  //remove link from list
  link.prev.next = link.next;
  link.next.prev = link.prev;

  //add link to last
  link.prev = this.store.last;
  link.next = this.store.last.next;
  this.store.last.next = link;
};

LRUCache.prototype.eject = function() {
  //remove first link
  var rmLink = this.store.first;
  rmLink.prev.next = rmLink.next;
  rmLink.next.prev = rmLink.prev;
  this.map[rmLink.key] = undefined;
  return null;
};

var cache = new LRUCache(5, function(key){
  var i = 0;
  while (i < 2000000000) {
    //do nothing basically
    i += 1;
  }
  return key;
});

console.log(cache.get(1));
console.log(cache.get(2));
console.log(cache.get(1));
