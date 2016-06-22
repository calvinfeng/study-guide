# Bit Manipulation

## Signed Binary Number: Two's complement
In two's complement, there is only one zero, represented as 0000 0000.
Negating a number is done by inverting all the bits and then adding one
to that result. With 8 bit, the most positive number it can represent
is 127 and the most negative number is -128.

| Binary Value | Two's Complement | Unsigned |
| ------------ | ---------------- | -------- |
| 0000 0000    | 0                | 0        |
| 0000 0001    | 1                | 1        |
| 0000 0010    | 2                | 2        |
| 0000 0011    | 3                | 3        |
| ...          | 4...             | 4...     |
| 0111 1111    | 127              | 127      |
| 1000 0000    | -128             | 128      |
| 1000 0001    | -127             | 129      |
| 1000 0010    | -126             | 130      |
| 1111 1110    | -2               | 254      |
| 1111 1111    | -1               | 255      |

## Bitwise Operators in Ruby
* AND - Set the result's bit to 1 if it is 1 in both input values
* OR - Set the result's bit to 1 if it is 1 in either input value
* XOR - Set the result's bit to 1 if it is 1 in either input value but not both
* Inverse - Set the result's bit to 0 if the input is 1 and vice versa
* Left Shift - Move the input bits left by a specified number of places
* Right Shift - Move the input bits right by a specified number of places

| Operators   | Symbol | Inputs       | Outputs   |
| ----------- | ------ | ------------ | --------- |
| AND         | &      | 1010 & 0010  | 0010      |
| OR          |        | 1010 OR 1111 | 1111      |
| XOR         | ^      | 1010 ^ 1111  | 0101      |  
| Inverse     | ~      | ~1010        | 0101      |
| Left Shift  | <<     | 0101 << 2    | 0001 0100 |
| Right Shift | >>     | 1100 >> 2    | 0011      |

## GameBoy
Gameboy CPU has 10 registers, A B C D E F G H L SP PC
Each of them can hold 8 bit numbers
SP and PC can hold 16 bit numbers

Work RAM holds 8 KB, 8000 cells with 8 bits
CPU has the ability to perform instructions

`LD A,B` - load function, from second operator and copy it to the first
Take value from B register and copy it to A register

`ADD A, 27` - add function, add value from 27 to A

`JP NZ, 8000H` - jump instruction, NZ - if not zero, jump to 8000

`HALT` - pauses the CPU until a new screen is refreshed

### Assembly language
```
LD A, 0 - Put 0 into register A
LD (8000H), A  - Copy the content of A into memory location 8000 hexidecimal
game goes on ...
LD A, (8000H) - Copy the value from 8000H back to A to perform computation
INC A - Increment by one
LD (8000H), A - Put it back into memory
SUB 100 - Subtract 100 from A
JP C, AFTER - Jump to the position labeled AFTER when the previous operation went below zero
LD A, 0 - Set A back to zero
LD (8000H), A - Copy it back to the memory location
LD A, (8001H) - Load the memory location of life to A
INC A - Increment A
LD (8001H), A - Copy it back to the memory location of life
AFTER:  
```
