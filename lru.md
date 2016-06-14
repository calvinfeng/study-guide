## Least Recently Use LRU Cache
### Key Idea
It uses HashMap and LinkedList. Every key in the HashMap points to a single
link. The links form a LinkedList. The list is used for preserving the chronological order of the links. The head is the least recently used link, while the tail is the most recently used link. HashMap is used for fast retrieval.

``` ruby
class LRUCache
  def initialize(max, prc)
    @map = HashMap.new
    @store = LinkedList.new
    @max = max
    @prc = prc
  end

  def count
    @map.count
  end

  def get(key)
    if @map[key]
      link = @map[key]
      update_link!(link)
      link.val
    else
      calc!(key)
    end
  end

  def to_s
    "Map: " + @map.to_s + "\n" + "Store: " + @store.to_s
  end

  private

  def calc!(key)
    val = @prc.call(key)
    new_link = @store.insert(key, val)
    @map[key] = new_link

    eject! if count > @max
    val
  end

  def update_link!(link)
    link.prev.next = link.next
    link.next.prev = link.prev

    link.prev = @store.last
    link.next = @store.last.next
    @store.last.next = link
  end

  def eject!
    rm_link = @store.first
    rm_link.prev.next = rm_link.next
    rm_link.next.prev = rm_link.prev
    @map.delete(rm_link.key)
    nil
  end
end
```
