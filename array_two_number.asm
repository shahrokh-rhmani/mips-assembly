.data
array: .word 8, 3  # نمونه آرایه دو عنصری
n: .word 2  # تعداد عناصر آرایه
comma: .asciiz ", "  # کاما برای جدا کردن اعداد
newline: .asciiz "\n"  # کاراکتر newline برای قالب‌بندی

.text
.globl main

main:
    # چاپ عناصر آرایه قبل از مرتب‌سازی
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
    # چاپ newline
    la $a0, newline
    li $v0, 4
    syscall

    # اجرای مرتب‌سازی سریع
    la $a0, array  # آدرس پایه آرایه
    li $a1, 0  # اندیس شروع
    lw $a2, n  # تعداد عناصر آرایه
    sub $a2, $a2, 1  # اندیس پایان
    jal quicksort

    # چاپ عناصر آرایه بعد از مرتب‌سازی
    lw $t0, n  # بارگذاری تعداد عناصر آرایه در $t0
    la $t1, array  # بارگذاری آدرس پایه آرایه در $t1
    li $t2, 0  # مقداردهی اولیه شمارنده به 0

print_sorted_loop:
    beq $t2, $t0, end_print_sorted  # اگر به انتهای آرایه رسیدیم، پایان چاپ
    lw $a0, 0($t1)  # بارگذاری عنصر فعلی آرایه در $a0
    li $v0, 1  # کد سیستم‌کال برای چاپ عدد صحیح
    syscall

    addi $t1, $t1, 4  # حرکت به عنصر بعدی آرایه
    addi $t2, $t2, 1  # افزایش شمارنده

    bge $t2, $t0, end_comma_sorted  # اگر به انتهای آرایه رسیدیم، چاپ کاما پایان یابد
    la $a0, comma
    li $v0, 4
    syscall
end_comma_sorted:
    j print_sorted_loop  # ادامه چاپ

end_print_sorted:
    # چاپ newline
    la $a0, newline
    li $v0, 4
    syscall

    # خروج از برنامه
    li $v0, 10
    syscall

# تابع quicksort
quicksort:
    addi $sp, $sp, -24
    sw $ra, 20($sp)
    sw $a0, 16($sp)
    sw $a1, 12($sp)
    sw $a2, 8($sp)
    sw $a3, 4($sp)

    bge $a1, $a2, quicksort_done  # اگر start >= end باشد، پایان بازگشت

    # تقسیم آرایه
    move $t0, $a1  # i = start
    move $t1, $a2  # j = end
    sll $t2, $a1, 2  # i * 4
    add $t2, $a0, $t2  # array[i]
    lw $t3, 0($t2)  # pivot = array[start]

partition_loop:
    # پیدا کردن عنصری که >= pivot باشد
partition_left:
    sll $t4, $t0, 2
    add $t5, $a0, $t4
    lw $t6, 0($t5)
    bge $t6, $t3, partition_left_done
    addi $t0, $t0, 1
    j partition_left
partition_left_done:

    # پیدا کردن عنصری که <= pivot باشد
partition_right:
    sll $t7, $t1, 2
    add $t8, $a0, $t7
    lw $t9, 0($t8)
    ble $t9, $t3, partition_right_done
    subi $t1, $t1, 1
    j partition_right
partition_right_done:

    ble $t0, $t1, swap  # تعویض array[i] و array[j]

    # بررسی اگر i از j عبور کرده باشد
    bgt $t0, $t1, partition_done

swap:
    # تعویض array[i] و array[j]
    sll $t4, $t0, 2
    add $t5, $a0, $t4
    lw $t6, 0($t5)  # بارگذاری array[i]

    sll $t7, $t1, 2
    add $t8, $a0, $t7
    lw $t9, 0($t8)  # بارگذاری array[j]

    sw $t9, 0($t5)  # جایگزینی array[j] در array[i]
    sw $t6, 0($t8)  # جایگزینی array[i] در array[j]

    addi $t0, $t0, 1  # i++
    subi $t1, $t1, 1  # j--
    j partition_loop

partition_done:
    # مرتب‌سازی بازگشتی زیرآرایه‌ها
    move $a3, $t0  # ایندکس pivot

    # مرتب‌سازی زیرآرایه چپ
    move $a2, $a1
    subi $a2, $a2, 1
    jal quicksort

    # مرتب‌سازی زیرآرایه راست
    move $a1, $a3
    addi $a1, $a1, 1
    lw $a2, 8($sp)  # بارگذاری مقدار قبلی end
    jal quicksort

quicksort_done:
    lw $a3, 4($sp)
    lw $a2, 8($sp)
    lw $a1, 12($sp)
    lw $a0, 16($sp)
    lw $ra, 20($sp)
    addi $sp, $sp, 24
    jr $ra
