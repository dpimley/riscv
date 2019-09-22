# -------------------------------
# 
# -------------------------------

.globl __start

.bss
    matrix_c:

.rodata
    msg1:         .string "Input Matrix1 (rasterized) : "
    msg2:         .string "Input Matrix2 (rasterized) : "
    msg3:         .string "Output Matrix (rasterized) : "
    matrix_a:     .word   2, 2, 5, 7
    matrix_b:     .word   3, 5, 1, 8

.text
__start:
    la     a2, msg1                         ; populate parameters for print matrix a
    la     a3, matrix_a
    jal    __print_matrix
    la     a2, msg2                         ; populate parameters for print matrix b
    la     a3, matrix_b
    jal    __print_matrix
    la     a2, matrix_a                     ; populate parameters for multiply matrix
    la     a3, matrix_b
    la     a4, matrix_c
    jal    __multiply_matrix      
    la     a2, msg3                         ; populate parameters for print matrix out
    la     a3, matrix_c
    jal    __print_matrix
    
    j      __finish                         ; finish
    
# Parameters
# a2 : address of 2 x 2 matrix a
# a3 : address of 2 x 2 matrix b
# a4 : addres of ouput matrix
__multiply_matrix:
    mv     t0, a4                           ; move the output address into a temporary
    
    li     t1, 2                            ; set the loop a counter
__loop_row_a:
    beq    t1, zero, __finish_multiply      ; finish if the loop counters have been exhausted
    mv     t2, a3                           ; move the input matrix b address into a temporary
    li     t3, 2                            ; reset the loop b counter
__loop_col_b:
    lw     t4, 0(a2)                        ; load the base 1st operand matrix a
    lw     t5, 0(t2)                        ; load the base 1st operand matrix b
    mul    t5, t5, t4                       ; multiply the two operands
    add    t6, t6, t5                       ; put the result into a register
    lw     t4, 4(a2)                        ; load the base 2nd operand matrix a
    lw     t5, 8(t2)                        ; load the base 2nd operand matrix b
    mul    t5, t5, t4                       ; multiply the two operands
    add    t6, t6, t5                       ; accumulate the result into a register
    sw     t6, 0(t0)                        ; store the value into the output matrix
    addi   t0, t0, 4                        ; increment the next store location
    mv     t6, zero                         ; zero out accumulate register
    addi   t2, t2, 4                        ; increment address for next column of matrix b
    addi   t3, t3, -1                       ; decrement the loop b counter
    bne    t3, zero, __loop_col_b           ; branch if need to use same row with next column
    addi   a2, a2, 8                        ; next address is the next row of matrix a
    addi   t1, t1, -1                       ; decrement loop a counter
    j      __loop_row_a                     ; branch if columns have been exhausted

__finish_multiply:
    addi a2, a2, -16                        ; reset matrix a address for callee preservation
    ret
    
# Parameters
# a2 : print header
# a3 : matrix address
__print_matrix:
    li     a0, 4                            ; string parameter for ecall print
    mv     a1, a2                           ; load print header
    ecall                                   ; call print
    li     t0, 4                            ; loop counter
__print_loop:
    li     a0, 1                            ; ecall parameter for printing integers
    lw     t1, 0(a3)                        ; load matrix value into temporary
    mv     a1, t1                           ; integer parameter for ecall print
    ecall                                   ; call print
    addi   a3, a3, 4                        ; increment the load address (word -> 4 bytes)
    sub    t0, t0, a0                       ; decrement loop counter
    li     a0, 11                           ; string parameter for ecall print
    li     a1, ' '                          ; space parameter for ecall
    ecall                                   ; call print
    bne    t0, zero, __print_loop           ; branch if not done
    li     a0, 11                           ; string parameter for ecall print
    li     a1, '\n'                         ; space parameter for ecall
    ecall                                   ; call print
    ret                                     ; return when finished
    
__finish:
