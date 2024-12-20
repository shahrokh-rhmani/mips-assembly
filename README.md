# mips-assembly

## sum_number_input: (Code Explanation)

- **`li $v0, 4`**: Set system service to print a string.
- **`la $a0, inputNumber`**: Load the address of the inputNumber message into register `$a0`.
- **`li $v0, 5`**: Set system service to read an integer.
- **`li $v0, 1`**: Set system service to print an integer.
- **`li $v0, 10`**: Set system service to exit the program.

#### Recursive Function

- **`sw $ra, 0($sp)`**: Store the return address on the stack.
- **`sw $a0, 4($sp)`**: Store the input number on the stack.
- **`beq $a0, $zero, sumDone`**: If the input number is zero, branch to `sumDone`.
- **`jr $ra`**: Jump to the return address (return to the caller).
