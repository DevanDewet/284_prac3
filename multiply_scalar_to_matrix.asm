; ========================== 
; Group member 01: Tinotenda_Chirozvi_22547747 
; Group member 02: Tafara_Hwata_22565991 
; Group member 03: Devan_Dewet_05169098 
; ==========================  

segment .text
global multiplyScalarToMatrix

multiplyScalarToMatrix:
    push rbp
    mov rbp, rsp

    ; Parameters:
    ; rdi = float **matrix
    ; xmm0 = float scalar
    ; rsi = int rows
    ; rdx = int cols


    movss xmm1, [rel one]
    ucomiss xmm0, xmm1
    je .done


    test rsi, rsi
    jz .done
    test rdx, rdx
    jz .done

 
    xor rcx, rcx  ; row counter

.row_loop:
    xor r8, r8    ; column counter
    mov r9, [rdi + rcx * 8]  

.col_loop:

    movss xmm1, [r9 + r8 * 4]
    mulss xmm1, xmm0
    movss [r9 + r8 * 4], xmm1

    ; Move to next column
    inc r8
    cmp r8, rdx
    jl .col_loop

    ; Move to next row
    inc rcx
    cmp rcx, rsi
    jl .row_loop

.done:
    pop rbp
    ret

section .data
    one: dd 1.0