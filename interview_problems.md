# Interview Problems

#Blend
Write a function to check whether a binary tree is mirrored

``` ruby
def isMirrored(left, right)
  return (left == nil && right == nil) if left == nil || right == nil
  left.value == right.value && isMirrored(left.left, right.right) && isMirrored(left.right, right.left)
end
```
