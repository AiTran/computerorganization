main:
    addi $a0, $zero, 10 # n = 10
    addi $a1, $zero, 5  # m = 5
    jal pascal          # call pascal(10, 5)
    j exit

pascal:
    
    /* 02/21/2020
      Author: AI */
    
    #--------------------------------------#
    #  \^o^/   Write your code here~  \^o^/#
    #--------------------------------------#

    beq $a1, $a0, return # m==n
    beq $a1, $zero, return # m==0
    addi $sp, $sp, -8
    sw $ra, 0x0($sp)    # Save $ra register into stack
    #call pascal (n-1,m-1)
    addi $a0,$a0,-1
    addi $a1,$a1,-1
    jal pascal 
    sw $v0,0x4($sp)
    #call pascal(n-1,m)
    addi $a1,$a1,1 
    jal pascal 
    #get result
    lw $t0,0x4($sp)
    add $v0,$v0,$t0
    #restore parameter
    addi $a0,$a0,1 
   

    lw $ra, 0x0($sp)    # Load $ra register from stack
    addi $sp, $sp, 8
    jr $ra
return:
    addi $v0,$zero,1
    jr $ra
    
exit:
