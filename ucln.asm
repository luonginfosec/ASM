.model small
.stack 100h
.data
    msg1 db 'Enter first number: $'
    msg2 db 10, 13, 'Enter second number: $'
    msg3 db 10, 13, 'GCD is: $'
    num1 dw ?
    num2 dw ?
    ten dw 10   ; For decimal conversion
    
.code
main proc
    mov ax, @data
    mov ds, ax
    
    ; Print first message
    lea dx, msg1
    mov ah, 9
    int 21h
    
    ; Read first number
    call read_num
    mov num1, ax
    
    ; Print second message
    lea dx, msg2
    mov ah, 9
    int 21h
    
    ; Read second number
    call read_num
    mov num2, ax
    
    ; Calculate GCD
    mov ax, num1
    mov bx, num2
    call gcd
    
    ; Print result message
    lea dx, msg3
    mov ah, 9
    int 21h
    
    ; Print result
    mov ax, bx
    call print_num
    
    ; Exit program
    mov ah, 4ch
    int 21h
main endp

; GCD procedure using Euclidean algorithm
gcd proc
    push ax
    push dx
    
gcd_loop:
    cmp bx, 0       ; Check if b = 0
    je gcd_end      ; If b = 0, return a
    
    xor dx, dx      ; Clear dx for division
    div bx          ; Divide ax by bx, remainder in dx
    mov ax, bx      ; Move b to a
    mov bx, dx      ; Move remainder to b
    jmp gcd_loop    ; Repeat
    
gcd_end:
    mov bx, ax      ; Store result in bx
    pop dx
    pop ax
    ret
gcd endp

; Read number procedure
read_num proc
    push bx
    push cx
    mov bx, 0      ; Initialize result
    
read_digit:
    mov ah, 1      ; Read character
    int 21h
    
    cmp al, 13     ; Check for Enter key
    je read_done
    
    sub al, 48     ; Convert ASCII to number
    mov cl, al
    mov ax, bx
    mul ten        ; Multiply current result by 10
    add al, cl     ; Add new digit
    mov bx, ax
    jmp read_digit
    
read_done:
    mov ax, bx     ; Move result to ax
    pop cx
    pop bx
    ret
read_num endp

; Print number procedure
print_num proc
    push ax
    push bx
    push cx
    push dx
    
    mov cx, 0      ; Initialize digit counter
    
    ; Handle zero case
    cmp ax, 0
    jne divide_loop
    mov dl, '0'
    mov ah, 2
    int 21h
    jmp print_done
    
divide_loop:
    cmp ax, 0
    je print_digits
    xor dx, dx     ; Clear dx for division
    div ten        ; Divide by 10
    push dx        ; Save remainder (digit)
    inc cx         ; Increment digit counter
    jmp divide_loop
    
print_digits:
    cmp cx, 0      ; Check if all digits printed
    je print_done
    pop dx         ; Get digit
    add dl, 48     ; Convert to ASCII
    mov ah, 2      ; Print character
    int 21h
    dec cx         ; Decrement counter
    jmp print_digits
    
print_done:
    pop dx
    pop cx
    pop bx
    pop ax
    ret
print_num endp

end main