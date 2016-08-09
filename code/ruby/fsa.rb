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

def string_match(string, pattern, radix)
  table = transition_table(pattern, radix)
  num_of_states = table.keys.length - 1
  curr_state = "state:0"
  string.chars.each do |char|
    curr_state = table[curr_state][char]
    return true if curr_state == "state:#{num_of_states}"
  end
  false
end

puts transition_table("acgt", ['a','c','g', 't']);
puts string_match("acgacgacgaccgtgctgactacggtttacg", "acgt", ['a', 'c', 'g', 't'])
