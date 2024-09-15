; ==========================
; Group member 01: Tinotenda_Chirozvi_22547747
; Group member 02: Tafara_Hwata_22565991
; Group member 03: Devan_Dewet_05169098
; ==========================

; extern malloc
; extern free
; section .text
;     global addMatrices

; addMatrices:
;     push rbp
;     mov rbp, rsp
;     push rbx
;     push r12
;     push r13
;     push r14
;     push r15


;     ; rdi = float **matrix1
;     ; rsi = float **matrix2
;     ; rdx = int rows
;     ; rcx = int cols

;     mov r12, rdi    ; matrix1
;     mov r13, rsi    ; matrix2
;     mov r14, rdx    ; rows
;     mov r15, rcx    ; cols

   
;     test rdx, rdx
;     jz .return_null
;     test rcx, rcx
;     jz .return_null

   
;     mov rdi, rdx
;     shl rdi, 3      
;     call malloc
;     test rax, rax
;     jz .return_null
;     mov rbx, rax    


;     xor r8, r8  

; .row_loop:
;     mov rdi, r15
;     shl rdi, 2    
;     push rbx
;     call malloc
;     pop rbx
;     test rax, rax
;     jz .cleanup


;     mov [rbx + r8 * 8], rax

;     xor r9, r9     

; .col_loop:
;     mov rdi, [r12 + r8 * 8]  
;     mov rsi, [r13 + r8 * 8]  
;     movss xmm0, [rdi + r9 * 4]
;     addss xmm0, [rsi + r9 * 4]
;     movss [rax + r9 * 4], xmm0

;     inc r9
;     cmp r9, r15
;     jl .col_loop

;     inc r8
;     cmp r8, r14
;     jl .row_loop


;     mov rax, rbx
;     jmp .done

; .cleanup:
;     dec r8

; .cleanup_loop:
;     mov rdi, [rbx + r8 * 8]
;     call free
;     dec r8
;     jns .cleanup_loop

;     mov rdi, rbx
;     call free

; .return_null:
;     xor rax, rax   

; .done:
;     pop r15
;     pop r14
;     pop r13
;     pop r12
;     pop rbx
;     pop rbp
;     ret


; extern malloc
; extern free
; section .text
;     global addMatrices

; addMatrices:
;     push rbp
;     mov rbp, rsp
;     sub rsp, 8            ; Align stack to 16 bytes (as we're about to push 5 registers, making it misaligned)
;     push rbx
;     push r12
;     push r13
;     push r14
;     push r15

;     ; rdi = float **matrix1
;     ; rsi = float **matrix2
;     ; rdx = int rows
;     ; rcx = int cols

;     mov r12, rdi    ; matrix1
;     mov r13, rsi    ; matrix2
;     mov r14, rdx    ; rows
;     mov r15, rcx    ; cols

;     test rdx, rdx
;     jz .return_null
;     test rcx, rcx
;     jz .return_null

;     ; Allocate memory for the result matrix
;     mov rdi, rdx
;     shl rdi, 3            ; rdi = rows * 8 (for 64-bit pointers to rows)
;     call malloc
;     test rax, rax
;     jz .return_null
;     mov rbx, rax          ; rbx = result matrix base pointer

;     xor r8, r8            ; r8 = row index

; .row_loop:
;     mov rdi, r15
;     shl rdi, 2            ; rdi = cols * 4 (for 32-bit floats)
;     push rbx              ; Save rbx because malloc may overwrite rbx
;     call malloc
;     pop rbx               ; Restore rbx
;     test rax, rax
;     jz .cleanup           ; If malloc fails, go to cleanup

;     mov [rbx + r8 * 8], rax   ; Store pointer to newly allocated row in result matrix

;     xor r9, r9            ; r9 = column index

; .col_loop:
;     mov rdi, [r12 + r8 * 8]   ; rdi = matrix1[r8] (pointer to row r8 of matrix1)
;     mov rsi, [r13 + r8 * 8]   ; rsi = matrix2[r8] (pointer to row r8 of matrix2)
;     movss xmm0, [rdi + r9 * 4] ; Load matrix1[r8][r9] into xmm0
;     addss xmm0, [rsi + r9 * 4] ; Add matrix2[r8][r9] to xmm0
;     movss [rax + r9 * 4], xmm0 ; Store the result in result[r8][r9]

;     inc r9
;     cmp r9, r15           ; Compare column index to number of columns
;     jl .col_loop

;     inc r8
;     cmp r8, r14           ; Compare row index to number of rows
;     jl .row_loop

;     mov rax, rbx          ; Return result matrix pointer
;     jmp .done

; .cleanup:
;     dec r8                ; Start cleaning up from the last allocated row

; .cleanup_loop:
;     mov rdi, [rbx + r8 * 8] ; Get pointer to row
;     call free             ; Free the row
;     dec r8
;     jns .cleanup_loop     ; Repeat until all rows are freed

;     mov rdi, rbx
;     call free             ; Free the top-level matrix pointer

; .return_null:
;     xor rax, rax          ; Return null if there was an error

; .done:
;     pop r15
;     pop r14
;     pop r13
;     pop r12
;     pop rbx
;     add rsp, 8            ; Restore stack alignment
;     pop rbp
;     ret


extern malloc
section .text
    global addMatrices

addMatrices:
   endbr64
   push   rbp
   mov    rbp,rsp
   push   rbx
   sub    rsp,0x48
   mov    QWORD [rbp-0x38],rdi
   mov    QWORD [rbp-0x40],rsi
   mov    DWORD [rbp-0x44],edx
   mov    DWORD [rbp-0x48],ecx
   cmp    DWORD [rbp-0x44],0x0
   je     .j1
   cmp    DWORD [rbp-0x48],0x0
   jne    .j2
.j1:
   mov    eax,0x0
   jmp    .j3
.j2:
   mov    eax,DWORD [rbp-0x44]
   cdqe
   shl    rax,0x3
   mov    rdi,rax
   call   malloc
   mov    QWORD [rbp-0x18],rax
   mov    DWORD [rbp-0x24],0x0
   jmp    .j4
.j5:
   mov    eax,DWORD [rbp-0x48]
   cdqe
   shl    rax,0x2
   mov    edx,DWORD [rbp-0x24]
   movsxd rdx,edx
   lea    rcx,[rdx*8+0x0]
   mov    rdx,QWORD [rbp-0x18]
   lea    rbx,[rcx+rdx*1]
   mov    rdi,rax
   call   malloc
   mov    QWORD [rbx],rax
   add    DWORD [rbp-0x24],0x1
.j4:
   mov    eax,DWORD [rbp-0x24]
   cmp    eax,DWORD [rbp-0x44]
   jl     .j5
   mov    DWORD [rbp-0x20],0x0
   jmp    .j6
.j9:
   mov    DWORD [rbp-0x1c],0x0
   jmp    .j8
.j7:
   mov    eax,DWORD [rbp-0x20]
   cdqe
   lea    rdx,[rax*8+0x0]
   mov    rax,QWORD [rbp-0x38]
   add    rax,rdx
   mov    rdx,QWORD [rax]
   mov    eax,DWORD [rbp-0x1c]
   cdqe
   shl    rax,0x2
   add    rax,rdx
   movss  xmm1,DWORD [rax]
   mov    eax,DWORD [rbp-0x20]
   cdqe
   lea    rdx,[rax*8+0x0]
   mov    rax,QWORD [rbp-0x40]
   add    rax,rdx
   mov    rdx,QWORD [rax]
   mov    eax,DWORD [rbp-0x1c]
   cdqe
   shl    rax,0x2
   add    rax,rdx
   movss  xmm0,DWORD [rax]
   mov    eax,DWORD [rbp-0x20]
   cdqe
   lea    rdx,[rax*8+0x0]
   mov    rax,QWORD [rbp-0x18]
   add    rax,rdx
   mov    rdx,QWORD [rax]
   mov    eax,DWORD [rbp-0x1c]
   cdqe
   shl    rax,0x2
   add    rax,rdx
   addss  xmm0,xmm1
   movss  DWORD [rax],xmm0
   add    DWORD [rbp-0x1c],0x1
.j8:
   mov    eax,DWORD [rbp-0x1c]
   cmp    eax,DWORD [rbp-0x48]
   jl     .j7
   add    DWORD [rbp-0x20],0x1
.j6:
   mov    eax,DWORD [rbp-0x20]
   cmp    eax,DWORD [rbp-0x44]
   jl     .j9
   mov    rax,QWORD [rbp-0x18]
.j3:
   mov    rbx,QWORD [rbp-0x8]
   leave
   ret