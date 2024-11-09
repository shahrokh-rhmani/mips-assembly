.data
inputNumber: .asciiz "Enter a number: "
resultMessage: .asciiz "\nThe total of the numbers is: "
newline: .asciiz "\n"
theSum: .word 0

.text
.globl main

main:
    li $v0, 4
    la $a0, inputNumber
    syscall

    li $v0, 5
    syscall
    move $a0, $v0  # Move the user input to $a0

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
