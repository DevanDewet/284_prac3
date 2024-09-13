; ==========================
; Group member 01: Tinotenda_Chirozvi_22547747
; Group member 02: Tafara_Hwata_22565991
; Group member 03: Devan_Dewet_05169098
; ==========================

extern malloc
extern free
extern fprintf
extern stderr

section .data
    error_msg db "Error: Memory allocation failed", 10, 0

section .text
global addMatrices

addMatrices:
    push rbp
    mov rbp, rsp
    push rbx
    push r12    
    push r13
    push r14
    push r15

    ; Parameters:
    ; rdi = float **matrix1
    ; rsi = float **matrix2
    ; rdx = int rows
    ; rcx = int cols

    ; Preserve parameters
    mov r12, rdi    ; matrix1
    mov r13, rsi    ; matrix2
    mov r14, rdx    ; rows
    mov r15, rcx    ; cols

    ; Check if rows or cols is zero
    test rdx, rdx
    jz .return_null
    test rcx, rcx
    jz .return_null

    ; Allocate memory for result matrix (rows * sizeof(float*))
    mov rdi, rdx
    shl rdi, 3      ; multiply by 8 (sizeof(float*))
    call malloc wrt ..plt
    test rax, rax
    jz .allocation_error
    mov rbx, rax    ; Store result matrix pointer in rbx

    ; Allocate memory for each row and perform addition
    xor r8, r8      ; row counter
.row_loop:
    ; Allocate memory for this row (cols * sizeof(float))
    mov rdi, r15
    shl rdi, 2      ; multiply by 4 (sizeof(float))
    push rbx
    call malloc wrt ..plt
    pop rbx
    test rax, rax
    jz .cleanup

    ; Store row pointer in result matrix
    mov [rbx + r8 * 8], rax

    ; Add corresponding elements from matrix1 and matrix2
    xor r9, r9      ; column counter
.col_loop:
    mov rdi, [r12 + r8 * 8]  ; Get row pointer from matrix1
    mov rsi, [r13 + r8 * 8]  ; Get row pointer from matrix2
    movss xmm0, [rdi + r9 * 4]
    addss xmm0, [rsi + r9 * 4]
    movss [rax + r9 * 4], xmm0

    inc r9
    cmp r9, r15
    jl .col_loop

    inc r8
    cmp r8, r14
    jl .row_loop

    ; Return the result matrix
    mov rax, rbx
    jmp .done

.allocation_error:
    ; Print error message
    mov rdi, [rel stderr]
    mov rsi, error_msg
    xor eax, eax
    call fprintf wrt ..plt

.cleanup:
    ; Free allocated memory if an error occurred
    test r8, r8
    jz .free_main_array
    dec r8
.cleanup_loop:
    mov rdi, [rbx + r8 * 8]
    call free wrt ..plt
    dec r8
    jns .cleanup_loop

.free_main_array:
    mov rdi, rbx
    call free wrt ..plt

.return_null:
    xor rax, rax    ; Return NULL

.done:
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    pop rbp
    ret