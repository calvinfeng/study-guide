# Trie
A data structure for searching with string keys

## Speed Comparison
L is the length of string

| implementation | search     | insert | delete | operations on keys |
| -------------- | ---------- | ------ | ------ | ------------------ |
| red-black BST  | L + log(N) | log(N) | log(N) | compareTo()        |
| hash table     | L          | L      | L      | equals() & hash()  |

Can we do better? Yes if we can avoid examining the entire key, as with
string sorting. Trie provides a data structure that enables one to search
without going through the entire length of the string, especially when
the key doesn't exist in the library.

It is faster than hashing, more flexible than BST, for string specifically
A trie could be a good data structure for building a memory-efficient
dictionary with fast lookups and auto-completion.Think of it as a hash table,
providing fast lookup of key-value pairs (or just lookup of keys), but
unlike a hash table it allows you to iterate over the keys in sorted order.

## R-way Trie
* Store characters into nodes (not keys)
* Each node has up to R children, R stands for radix.
  * Example: for lowercase letters, R = 26, so each node can have up to 26
  children
* Store values in nodes corresponding to last character in the key
  * Example: "calvin" => {age: 24}, the age hash will be stored in node "n"

### Search in a Trie
Follow links corresponding to each character in the key
* Search hit: node where search ends has a non-null value
* Search miss: reach null link or node where search ends has null value

### Insertion in Trie
Follow links corresponding to each character in the key
* Encounter a null link: create new node
* Encounter the last character of the key: set value in that node

### Deletion in Trie
* Find the node corresponding to key and set value to null
* If node has null value and all null links, remove that node and recurse

## Implementation
``` ruby
# This is very similar to binary search tree, in terms of implementation
class Trie
  def initialize
    @root = TrieNode.new
  end

  def insert(key, value)
    Trie.insert!(@root, key, value)
  end

  def find(key)
    Trie.find!(@root, key)
  end

  def delete(key)
    Trie.delete!(@root, key)
  end

  def self.insert!(node,key,value)
    return nil if key.nil?
    if key.length == 0
      node.value = value
    else
      node.children[key[0]] = TrieNode.new(node, nil, key[0]) unless node.children[key[0]]
      Trie.insert!(node.children[key[0]], key[1..-1], value)
    end
  end

  def self.find!(node, key)
    return nil if node.nil?
    if key.length == 0
      node.value
    else
      Trie.find!(node.children[key[0]], key[1..-1])
    end
  end

  def self.delete!(node, key)
    return nil if node.nil?
    if key.length == 0
      node.value = nil
      Trie.clean_up_nodes!(node)
    else
      Trie.delete!(node.children[key[0]], key[1..-1])
    end
  end

  def self.clean_up_nodes!(node)
    curr_node = node.parent
    while curr_node.children.keys == 1
      curr_node.children = Hash.new
      latest_letter = curr_node.letter
      curr_node = curr_node.parent
    end
    curr_node.children[latest_letter] = nil
  end
end
```
