.data
array: .word 15, 3, 8, 1, 9, 6  # Sample array
n: .word 6  # Number of elements in the array
comma: .asciiz ", "  # Comma for separating numbers
newline: .asciiz "\n"  # Newline character for formatting

.text
.globl main

main:
    # Load the number of elements into $t0
    lw $t0, n
    # Load the base address of the array into $t1
    la $t1, array
    # Initialize the counter to 0
    li $t2, 0

print_loop:
    # If counter equals the number of elements, end print loop
    beq $t2, $t0, end_print
    # Load the current element of the array into $a0
    lw $a0, 0($t1)
    # Print the integer
    li $v0, 1
    syscall

    # Move to the next element
    addi $t1, $t1, 4
    # Increment the counter
    addi $t2, $t2, 1

    # If not the last element, print a comma
    bge $t2, $t0, end_comma
    la $a0, comma
    li $v0, 4
    syscall
end_comma:
    # Continue printing
    j print_loop

end_print:
    # Print newline
    la $a0, newline
    li $v0, 4
    syscall

    # Start quicksort
    la $a0, array  # Load base address of the array
    li $a1, 0  # Start index
    lw $a2, n  # Load number of elements
    sub $a2, $a2, 1  # End index
    jal quicksort

    # Print the sorted array
    lw $t0, n  # Load the number of elements
    la $t1, array  # Load the base address of the array
    li $t2, 0  # Initialize the counter to 0

print_sorted_loop:
    # If counter equals the number of elements, end print loop
    beq $t2, $t0, end_print_sorted
    # Load the current element of the array into $a0
    lw $a0, 0($t1)
    # Print the integer
    li $v0, 1
    syscall

    # Move to the next element
    addi $t1, $t1, 4
    # Increment the counter
    addi $t2, $t2, 1

    # If not the last element, print a comma
    bge $t2, $t0, end_comma_sorted
    la $a0, comma
    li $v0, 4
    syscall
end_comma_sorted:
    # Continue printing
    j print_sorted_loop

end_print_sorted:
    # Print newline
    la $a0, newline
    li $v0, 4
    syscall

    # Exit the program
    li $v0, 10
    syscall

quicksort:
    # Save the return address and arguments on the stack
    addi $sp, $sp, -24
    sw $ra, 20($sp)
    sw $a0, 16($sp)
    sw $a1, 12($sp)
    sw $a2, 8($sp)
    sw $a3, 4($sp)

    # Base case: if start index >= end index, return
    bge $a1, $a2, quicksort_done

    # Partition the array
    move $t0, $a1  # i = start
    move $t1, $a2  # j = end
    sll $t2, $a1, 2  # i * 4
    add $t2, $a0, $t2  # array[i]
    lw $t3, 0($t2)  # pivot = array[start]

partition_loop:
partition_left:
    # Find element >= pivot
    sll $t4, $t0, 2
    add $t5, $a0, $t4
    lw $t6, 0($t5)
    bge $t6, $t3, partition_left_done
    addi $t0, $t0, 1
    j partition_left
partition_left_done:

partition_right:
    # Find element <= pivot
    sll $t7, $t1, 2
    add $t8, $a0, $t7
    lw $t9, 0($t8)
    ble $t9, $t3, partition_right_done
    subi $t1, $t1, 1
    j partition_right
partition_right_done:

    # If i <= j, swap elements
    ble $t0, $t1, swap
    # If i > j, partition is done
    bgt $t0, $t1, partition_done

swap:
    # Swap elements at i and j
    sll $t4, $t0, 2
    add $t5, $a0, $t4
    lw $t6, 0($t5)

    sll $t7, $t1, 2
    add $t8, $a0, $t7
    lw $t9, 0($t8)

    sw $t9, 0($t5)
    sw $t6, 0($t8)

    addi $t0, $t0, 1
    subi $t1, $t1, 1
    j partition_loop

partition_done:
    # Recursively sort the left subarray
    move $a2, $t1
    jal quicksort

    # Recursively sort the right subarray
    move $a1, $t0
    lw $a2, 8($sp)
    jal quicksort

quicksort_done:
    # Restore the saved registers
    lw $a3, 4($sp)
    lw $a2, 8($sp)
    lw $a1, 12($sp)
    lw $a0, 16($sp)
    lw $ra, 20($sp)
    addi $sp, $sp, 24
    jr $ra
