# Suffix Tree
A suffix tree is simply a trie of all the proper suffixes of a string S.

For example:

| Word  | Suffixes |
|-------|----------|
| hello | hello    |
|       |  ello    |
|       |   llo    |
|       |    lo    |
|       |     o    |

Naturally, some suffixes can become the prefix of other suffix, for example.

| Word  | Suffixes |
|-------|----------|
| abcbc | abcbc    |
|       | bcbc     |
|       | cbc      |
|       | bc       |
|       | c        |

Now the problem is that `bc` is a prefix of `bcbc` but `bc` is a valid suffix. This will terminate search in the suffix tree prematurely. So we need a solution. We need to add a terminal character `$` to the end of the string.

`$` is a character that does not appear elsewhere in the string, and we define it to be less than other characters (e.g. for DNA: $ < A < C < G < T)

`$` enforces a rule we are all used to using, e.g. "as" comes before "ash" in the dictionary

`$` guarantees no suffix is a prefix of any other suffix, because `bc$` is not a prefix of `bcbc$`

## Constructing a Suffix Tree Naively
Suppose we have a string T = "abaaba"

What are the suffixes?

| Word   | Suffixes  |
|--------|-----------|
| abaaba | abaaba$ |
|        | baaba$  |
|        | aaba$   |
|        | aba$    |
|        | ba$     |
|        | a$      |
|        | $       |

We should expect 6 leave nodes that each contains a valid suffix for the word

### The Trie of Suffixes
We can either store the letters in edges or in nodes. If we store the letters in nodes, then we define keys to be letters and values to be null or the suffix.

This is a suffix tree

![suffix_tree]
[suffix_tree]: ../img/suffix_tree.png
Green squares are the leaf nodes
