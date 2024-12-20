.data
inputNumber: .asciiz "Enter a number: "      # Prompt message for user input
resultMessage: .asciiz "\nThe total of the numbers is: "  # Result message to be displayed
newline: .asciiz "\n"                        # Newline character
theSum: .word 0                              # Variable to store the sum of the numbers

.text
.globl main

main:
    li $v0, 4                                # Load immediate value 4 into $v0 (print string syscall)
    la $a0, inputNumber                      # Load address of inputNumber string into $a0
    syscall                                  # Make syscall to print the inputNumber string

    li $v0, 5                                # Load immediate value 5 into $v0 (read integer syscall)
    syscall                                  # Make syscall to read an integer from the user
    move $a0, $v0                            # Move the user input from $v0 to $a0

    jal sumNumbers                           # Jump and link to the sumNumbers function
    sw $v0, theSum                           # Store the result (sum) in theSum

    li $v0, 4                                # Load immediate value 4 into $v0 (print string syscall)
    la $a0, resultMessage                    # Load address of resultMessage string into $a0
    syscall                                  # Make syscall to print the resultMessage string

    li $v0, 1                                # Load immediate value 1 into $v0 (print integer syscall)
    lw $a0, theSum                           # Load the value of theSum into $a0
    syscall                                  # Make syscall to print the sum

    li $v0, 4                                # Load immediate value 4 into $v0 (print string syscall)
    la $a0, newline                          # Load address of newline string into $a0
    syscall                                  # Make syscall to print the newline

    li $v0, 10                               # Load immediate value 10 into $v0 (exit syscall)
    syscall                                  # Make syscall to exit the program

.globl sumNumbers
sumNumbers:
    subu $sp, $sp, 8                         # Decrease stack pointer by 8 to allocate space on the stack
    sw $ra, 0($sp)                           # Save return address on the stack
    sw $a0, 4($sp)                           # Save $a0 (current number) on the stack

    li $v0, 0                                # Initialize $v0 to 0 (base case sum is 0)
    beq $a0, $zero, sumDone                  # If $a0 (current number) is zero, jump to sumDone

    sub $a0, $a0, 1                          # Decrement $a0 by 1
    jal sumNumbers                           # Recursively call sumNumbers
    lw $a0, 4($sp)                           # Restore $a0 (current number) from the stack
    add $v0, $v0, $a0                        # Add the current number to the sum

sumDone:
    lw $ra, 0($sp)                           # Restore return address from the stack
    lw $a0, 4($sp)                           # Restore $a0 from the stack
    addu $sp, $sp, 8                         # Increase stack pointer by 8 to deallocate space
    jr $ra                                   # Jump back to return address
