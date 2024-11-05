.model small
.stack 100h
.data
    num1 dw 24    ; First number - you can change this value
    num2 dw 36    ; Second number - you can change this value
    msg db 'GCD is: $'
    ten dw 10     ; Used for decimal conversion
    
.code
main proc
    mov ax, @data
    mov ds, ax
    
    ; Print message
    lea dx, msg
    mov ah, 9
    int 21h
    
    ; Get numbers from data segment and calculate GCD
    mov ax, num1
    mov bx, num2
    call gcd
    
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
    cmp bx, 0      ; Check if b = 0
    je gcd_end     ; If b = 0, return a
    
    xor dx, dx     ; Clear dx for division
    div bx         ; Divide ax by bx, remainder in dx
    mov ax, bx     ; Move b to a
    mov bx, dx     ; Move remainder to b
    jmp gcd_loop   ; Repeat
    
gcd_end:
    mov bx, ax     ; Store result in bx
    pop dx
    pop ax
    ret
gcd endp

; Procedure to print number to screen
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
    push dx        ; Save remainder (digit) to stack
    inc cx         ; Increment counter
    jmp divide_loop
    
print_digits:
    cmp cx, 0      ; Check if all digits are printed
    je print_done
    pop dx         ; Get digit from stack
    add dl, 48     ; Convert to ASCII
    mov ah, 2      ; Print character
    int 21h
    dec cx         ; Decrement counter
    jmp print_digits
    
print_done:
    ; Print newline
    mov dl, 13
    mov ah, 2
    int 21h
    mov dl, 10
    mov ah, 2
    int 21h
    
    pop dx
    pop cx
    pop bx
    pop ax
    ret
print_num endp

end main