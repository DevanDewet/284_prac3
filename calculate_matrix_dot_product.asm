; ==========================
; Group member 01: Tinotenda_Chirozvi_22547747
; Group member 02: Tafara_Hwata_22565991
; Group member 03: Devan_Dewet_05169098
; ==========================

section .text
    global calculateMatrixDotProduct

calculateMatrixDotProduct:
    push rbp
    mov rbp, rsp

    test rdx, rdx
    jz .return_zero
    test rcx, rcx
    jz .return_zero

    ; Initialize dotProduct to 0.0
    xorps xmm0, xmm0 ; xmm0 = 0.0 (will hold the dot product result)

    ; Outer loop over rows
    xor r8, r8 ; r8 = row index
.outer_loop:
    cmp r8, rdx ; Check if row index >= rows
    jge .done ; Exit loop when all rows are processed

    ; Load pointers to matrix1 and matrix2's current row
    mov r9, [rdi + r8 * 8] ; r9 = matrix1[row]
    mov r10, [rsi + r8 * 8] ; r10 = matrix2[row]

    ; Inner loop over columns
    xor r11, r11 ; r11 = column index
.inner_loop:
    cmp r11, rcx ; Check if column index >= cols
    jge .next_row ; Move to the next row

    ; Load the corresponding elements from matrix1 and matrix2
    movss xmm1, [r9 + r11 * 4] ; xmm1 = matrix1[row][col]
    movss xmm2, [r10 + r11 * 4] ; xmm2 = matrix2[row][col]

    ; Multiply the elements
    mulss xmm1, xmm2

    ; Accumulate the result in xmm0
    addss xmm0, xmm1

    ; Increment column index
    inc r11
    jmp .inner_loop

.next_row:
    ; Increment row index
    inc r8
    jmp .outer_loop

.done:
    ; Return the dot product in xmm0
    pop rbp
    ret

.return_zero:
    ; Return 0.0 in xmm0 if rows or cols are zero
    xorps xmm0, xmm0
    pop rbp
    ret
