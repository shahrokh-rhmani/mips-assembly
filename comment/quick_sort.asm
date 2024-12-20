.data
array: .word 15, 3, 8, 1, 9, 6       # Define an array with initial values
n: .word 6                           # Define n as the size of the array
comma: .asciiz ", "                  # Define a comma string
newline: .asciiz "\n"                # Define a newline string

.text
.globl main

main:
    lw $t0, n                        # Load n into $t0
    la $t1, array                    # Load the address of array into $t1
    li $t2, 0                        # Initialize loop counter $t2 to 0

print_loop:
    beq $t2, $t0, end_print          # If loop counter equals n, end loop
    lw $a0, 0($t1)                   # Load current array element into $a0
    li $v0, 1                        # Prepare for print integer syscall
    syscall                          # Print integer

    addi $t1, $t1, 4                 # Move to the next array element
    addi $t2, $t2, 1                 # Increment loop counter

    bge $t2, $t0, end_comma          # If loop counter >= n, skip comma
    la $a0, comma                    # Load comma address into $a0
    li $v0, 4                        # Prepare for print string syscall
    syscall                          # Print comma
end_comma:
    j print_loop                     # Jump back to start of print loop

end_print:
    la $a0, newline                  # Load newline address into $a0
    li $v0, 4                        # Prepare for print string syscall
    syscall                          # Print newline

    la $a0, array                    # Load array address into $a0
    li $a1, 0                        # Set left index $a1 to 0
    lw $a2, n                        # Load array size into $a2
    sub $a2, $a2, 1                  # Set right index $a2 to n-1
    jal quicksort                    # Call quicksort function

    lw $t0, n                        # Load n into $t0
    la $t1, array                    # Load the address of array into $t1
    li $t2, 0                        # Initialize loop counter $t2 to 0

print_sorted_loop:
    beq $t2, $t0, end_print_sorted   # If loop counter equals n, end loop
    lw $a0, 0($t1)                   # Load current array element into $a0
    li $v0, 1                        # Prepare for print integer syscall
    syscall                          # Print integer

    addi $t1, $t1, 4                 # Move to the next array element
    addi $t2, $t2, 1                 # Increment loop counter

    bge $t2, $t0, end_comma_sorted   # If loop counter >= n, skip comma
    la $a0, comma                    # Load comma address into $a0
    li $v0, 4                        # Prepare for print string syscall
    syscall                          # Print comma
end_comma_sorted:
    j print_sorted_loop              # Jump back to start of print loop

end_print_sorted:
    la $a0, newline                  # Load newline address into $a0
    li $v0, 4                        # Prepare for print string syscall
    syscall                          # Print newline

    li $v0, 10                       # Prepare for exit syscall
    syscall                          # Exit program

quicksort:
    addi $sp, $sp, -24               # Allocate stack space
    sw $ra, 20($sp)                  # Save return address
    sw $a0, 16($sp)                  # Save array base address
    sw $a1, 12($sp)                  # Save left index
    sw $a2, 8($sp)                   # Save right index
    sw $a3, 4($sp)                   # Save register $a3 (unused)

    bge $a1, $a2, quicksort_done     # If left index >= right index, done

    move $t0, $a1                    # Set $t0 to left index
    move $t1, $a2                    # Set $t1 to right index
    sll $t2, $a1, 2                  # $t2 = left index * 4 (word size)
    add $t2, $a0, $t2                # $t2 = array base + $t2
    lw $t3, 0($t2)                   # Load pivot value

partition_loop:
partition_left:
    sll $t4, $t0, 2                  # $t4 = $t0 * 4 (word size)
    add $t5, $a0, $t4                # $t5 = array base + $t4
    lw $t6, 0($t5)                   # Load array value at $t0
    bge $t6, $t3, partition_left_done # If array value >= pivot, done
    addi $t0, $t0, 1                 # Increment left index
    j partition_left                 # Jump back to partition_left
partition_left_done:

partition_right:
    sll $t7, $t1, 2                  # $t7 = $t1 * 4 (word size)
    add $t8, $a0, $t7                # $t8 = array base + $t7
    lw $t9, 0($t8)                   # Load array value at $t1
    ble $t9, $t3, partition_right_done # If array value <= pivot, done
    subi $t1, $t1, 1                 # Decrement right index
    j partition_right                # Jump back to partition_right
partition_right_done:

    ble $t0, $t1, swap               # If left index <= right index, swap
    bgt $t0, $t1, partition_done     # If left index > right index, done

swap:
    sll $t4, $t0, 2                  # $t4 = $t0 * 4 (word size)
    add $t5, $a0, $t4                # $t5 = array base + $t4
    lw $t6, 0($t5)                   # Load array value at $t0

    sll $t7, $t1, 2                  # $t7 = $t1 * 4 (word size)
    add $t8, $a0, $t7                # $t8 = array base + $t7
    lw $t9, 0($t8)                   # Load array value at $t1

    sw $t9, 0($t5)                   # Swap values
    sw $t6, 0($t8)

    addi $t0, $t0, 1                 # Increment left index
    subi $t1, $t1, 1                 # Decrement right index
    j partition_loop                 # Jump back to partition_loop

partition_done:
    move $a2, $t1                    # Set right index for left partition
    jal quicksort                    # Recursively sort left partition

    move $a1, $t0                    # Set left index for right partition
    lw $a2, 8($sp)                   # Load saved right index
    jal quicksort                    # Recursively sort right partition

quicksort_done:
    lw $a3, 4($sp)                   # Restore $a3
    lw $a2, 8($sp)                   # Restore right index
    lw $a1, 12($sp)                  # Restore left index
    lw $a0, 16($sp)                  # Restore array base address
    lw $ra, 20($sp)                  # Restore return address
    addi $sp, $sp, 24                # Deallocate stack space
    jr $ra                           # Return from function
