.data
promptMessage: .asciiz "Calculating the sum of numbers from 1 to 10\n"
resultMessage: .asciiz "\nThe sum of the numbers from 1 to 10 is: "
newline: .asciiz "\n"
theSum: .word 0

.text
.globl main

main:
    li $a0, 10  # Initialize the starting number to 10
    jal sumNumbers  # Call the recursive function to calculate the sum
    sw $v0, theSum  # Store the result in theSum

    li $v0, 4
    la $a0, resultMessage
    syscall

    li $v0, 1
    lw $a0, theSum
    syscall

    li $v0, 4
    la $a0, newline
    syscall

    li $v0, 10
    syscall

.globl sumNumbers
sumNumbers:
    subu $sp, $sp, 8
    sw $ra, 0($sp)
    sw $a0, 4($sp)

    li $v0, 0
    beq $a0, $zero, sumDone

    sub $a0, $a0, 1
    jal sumNumbers
    lw $a0, 4($sp)
    add $v0, $v0, $a0

sumDone:
    lw $ra, 0($sp)
    lw $a0, 4($sp)
    addu $sp, $sp, 8
    jr $ra
