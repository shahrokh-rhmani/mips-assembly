hello: .asciiz "Hello, World!"

li $v0, 4         
la $a0, hello      
syscall           
jr $ra



          
