; ==========================
; Group member 01: Tinotenda_Chirozvi_22547747
; Group member 02: Tafara_Hwata_22565991
; Group member 03: Devan_Dewet_05169098
; ==========================

segment .text
    global calculateMatrixDotProduct

calculateMatrixDotProduct:
    push rbp
    mov rbp, rsp

    test rdx, rdx
    jz .return_zero
    test rcx, rcx
    jz .return_zero

    ; Initialize dotProduct to 0.0
    xorps xmm0, xmm0 ;

    xor r8, r8 
.outer_loop:
    cmp r8, rdx 
    jge .done 

    ; Load pointers to matrix1 and matrix2's current row
    mov r9, [rdi + r8 * 8] 
    mov r10, [rsi + r8 * 8]

    ; Inner loop over columns
    xor r11, r11 
.inner_loop:
    cmp r11, rcx 
    jge .next_row 

    movss xmm1, [r9 + r11 * 4]
    movss xmm2, [r10 + r11 * 4] 

    mulss xmm1, xmm2

    addss xmm0, xmm1

    inc r11
    jmp .inner_loop

.next_row:
    inc r8
    jmp .outer_loop

.done:
    pop rbp
    ret

.return_zero:
    xorps xmm0, xmm0
    pop rbp
    ret
