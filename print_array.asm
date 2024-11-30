.data
array: .word 34, 7, 23, 32, 5, 62  # نمونه آرایه
n: .word 6  # تعداد عناصر آرایه
comma: .asciiz ", "  # کاما برای جدا کردن اعداد
newline: .asciiz "\n"  # کاراکتر newline برای قالب‌بندی
open_bracket: .asciiz "["  # براکت باز
close_bracket: .asciiz "]"  # براکت بسته

.text
.globl main

main:
    # چاپ "Array:"
    la $a0, open_bracket
    li $v0, 4
    syscall

    # چاپ عناصر آرایه
    lw $t0, n  # بارگذاری تعداد عناصر آرایه در $t0
    la $t1, array  # بارگذاری آدرس پایه آرایه در $t1
    li $t2, 0  # مقداردهی اولیه شمارنده به 0

print_loop:
    beq $t2, $t0, end_print  # اگر به انتهای آرایه رسیدیم، پایان چاپ
    lw $a0, 0($t1)  # بارگذاری عنصر فعلی آرایه در $a0
    li $v0, 1  # کد سیستم‌کال برای چاپ عدد صحیح
    syscall

    addi $t1, $t1, 4  # حرکت به عنصر بعدی آرایه
    addi $t2, $t2, 1  # افزایش شمارنده

    bge $t2, $t0, end_comma  # اگر به انتهای آرایه رسیدیم، چاپ کاما پایان یابد
    la $a0, comma
    li $v0, 4
    syscall
end_comma:
    j print_loop  # ادامه چاپ

end_print:
    # چاپ "]"
    la $a0, close_bracket
    li $v0, 4
    syscall

    # چاپ newline
    la $a0, newline
    li $v0, 4
    syscall

    # خروج از برنامه
    li $v0, 10
    syscall
