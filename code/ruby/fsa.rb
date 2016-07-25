# Finite State Automata

# Assuming we are only allowing a, b, c states, hence "finite states"
def transition_table(pattern, radix)
  table = Hash.new
  (0..pattern.length).each do |i|
    table["state:#{i}"] = {pattern: pattern[0...i]}
  end

  (0...pattern.length).each do |i|
    radix.each do |char|
      str = table["state:#{i}"][:pattern] + char
      discard_num = 0
      (i+1).downto(0) do |j|
        if table["state:#{j}"][:pattern] == str.chars.drop(discard_num).join
          table["state:#{i}"][char] = "state:#{j}"
          next
        end
        discard_num += 1
      end
    end
  end
  table
end

def is_match(string, pattern)


end

puts transition_table("aacb", ['a','b','c']);
