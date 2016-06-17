require 'byebug'
class TrieNode
  attr_accessor :children, :value
  attr_reader :letter, :parent
  def initialize(parent = nil, value = nil, letter = nil)
    @value = value
    @parent = parent
    @children = Hash.new
    @letter = letter
  end
end

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

test_trie = Trie.new
test_trie.insert("cal", {name: "cal", age: 24, weight: 155})
test_trie.insert("cat", {name: "cat", age: 20, weight: 180})
# test_trie.insert("cat", {age: 5, weight: 20})
# test_trie.insert("carmen", {age: 25, weight: 110})
# test_trie.insert("steven", {age: 31, weight: 140})
p test_trie.find("cat")
test_trie.delete("cat")
p test_trie.find("cat")
p test_trie.find("cal")
