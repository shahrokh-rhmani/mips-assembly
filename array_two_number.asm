.data
array: .word 8, 3
n: .word 2
comma: .asciiz ", "
newline: .asciiz "\n"

.text
.globl main

main:
    lw $t0, n
    la $t1, array
    li $t2, 0

print_loop:
    beq $t2, $t0, end_print
    lw $a0, 0($t1)
    li $v0, 1
    syscall

    addi $t1, $t1, 4
    addi $t2, $t2, 1

    bge $t2, $t0, end_comma
    la $a0, comma
    li $v0, 4
    syscall
end_comma:
    j print_loop

end_print:
    la $a0, newline
    li $v0, 4
    syscall

    la $a0, array
    li $a1, 0
    lw $a2, n
    sub $a2, $a2, 1
    jal quicksort

    lw $t0, n
    la $t1, array
    li $t2, 0

print_sorted_loop:
    beq $t2, $t0, end_print_sorted
    lw $a0, 0($t1)
    li $v0, 1
    syscall

    addi $t1, $t1, 4
    addi $t2, $t2, 1

    bge $t2, $t0, end_comma_sorted
    la $a0, comma
    li $v0, 4
    syscall
end_comma_sorted:
    j print_sorted_loop

end_print_sorted:
    la $a0, newline
    li $v0, 4
    syscall

    li $v0, 10
    syscall

quicksort:
    addi $sp, $sp, -24
    sw $ra, 20($sp)
    sw $a0, 16($sp)
    sw $a1, 12($sp)
    sw $a2, 8($sp)
    sw $a3, 4($sp)

    bge $a1, $a2, quicksort_done

    move $t0, $a1
    move $t1, $a2
    sll $t2, $a1, 2
    add $t2, $a0, $t2
    lw $t3, 0($t2)

partition_loop:
partition_left:
    sll $t4, $t0, 2
    add $t5, $a0, $t4
    lw $t6, 0($t5)
    bge $t6, $t3, partition_left_done
    addi $t0, $t0, 1
    j partition_left
partition_left_done:

partition_right:
    sll $t7, $t1, 2
    add $t8, $a0, $t7
    lw $t9, 0($t8)
    ble $t9, $t3, partition_right_done
    subi $t1, $t1, 1
    j partition_right
partition_right_done:

    ble $t0, $t1, swap
    bgt $t0, $t1, partition_done

swap:
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
    move $a2, $t1
    jal quicksort

    move $a1, $t0
    lw $a2, 8($sp)
    jal quicksort

quicksort_done:
    lw $a3, 4($sp)
    lw $a2, 8($sp)
    lw $a1, 12($sp)
    lw $a0, 16($sp)
    lw $ra, 20($sp)
    addi $sp, $sp, 24
    jr $ra
