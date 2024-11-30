.data
array: .word 34, 7, 23, 32, 5, 62
n: .word 6
comma: .asciiz ", "
newline: .asciiz "\n"
open_bracket: .asciiz "["
close_bracket: .asciiz "]"

.text
.globl main

main:
    la $a0, open_bracket
    li $v0, 4
    syscall

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
    la $a0, close_bracket
    li $v0, 4
    syscall

    la $a0, newline
    li $v0, 4
    syscall

    li $v0, 10
    syscall
