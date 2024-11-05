.model small
.stack 100h
.data
    x dw ?    ; variable to store first input number
    y dw ?    ; variable to store second input number
    z dw ?    ; variable to store result
    msg1 db 'Enter first number (x): $'
    msg2 db 13, 10, 'Enter second number (y): $'
    newline db 13, 10, '$'   ; newline character sequence

.code
main proc
    ; initialize data segment
    mov ax, @data
    mov ds, ax
    
    ; display prompt for x
    lea dx, msg1
    mov ah, 9
    int 21h
    
    ; read x from keyboard
    call read_number
    mov x, ax
    
    ; display prompt for y
    lea dx, msg2
    mov ah, 9
    int 21h
    
    ; read y from keyboard
    call read_number
    mov y, ax
    
    ; check condition if (x >= 4)
    mov ax, x
    cmp ax, 4
    jl else_if_y_greater_2    ; if x < 4, jump to else if block
    
    ; check if (y < 2)
    mov ax, y
    cmp ax, 2
    jge else_x_plus_y        ; if y >= 2, jump to else block
    
    ; calculate z = x + y + 2
    mov ax, x
    add ax, y
    add ax, 2
    mov z, ax
    jmp print_result
    
else_x_plus_y:
    ; calculate z = x + y
    mov ax, x
    add ax, y
    mov z, ax
    jmp print_result
    
else_if_y_greater_2:
    ; check else if (y > 2)
    mov ax, y
    cmp ax, 2
    jle else_x_plus_y_plus_1  ; if y <= 2, jump to else block
    
    ; calculate z = x + y - 2
    mov ax, x
    add ax, y
    sub ax, 2
    mov z, ax
    jmp print_result
    
else_x_plus_y_plus_1:
    ; calculate z = x + y + 1
    mov ax, x
    add ax, y
    add ax, 1
    mov z, ax
    
print_result:
    ; print newline
    lea dx, newline
    mov ah, 9
    int 21h
    
    ; print the final result
    mov ax, z
    call print_number
    
    ; terminate program
    mov ah, 4ch
    int 21h
main endp

; procedure to read a number from keyboard
; returns: AX = number read
read_number proc
    push bx
    push cx
    mov bx, 0      ; initialize result
    mov cx, 0      ; digit counter
read_digit:
    ; read a character
    mov ah, 1
    int 21h
    
    ; check for enter key (carriage return)
    cmp al, 13
    je read_done
    
    ; convert ASCII to number
    sub al, 30h
    mov cl, al
    mov ax, bx
    mov bx, 10
    mul bx        ; ax = ax * 10
    mov bx, ax
    add bx, cx    ; bx = bx + digit
    jmp read_digit
    
read_done:
    mov ax, bx
    pop cx
    pop bx
    ret
read_number endp

; procedure to print a number
; input: AX = number to print
print_number proc
    push ax
    push bx
    push cx
    push dx
    
    mov bx, 10     ; divisor
    mov cx, 0      ; counter for digits
    
    ; check if number is negative
    test ax, ax
    jns divide_loop
    push ax
    mov dl, '-'    ; print minus sign
    mov ah, 2
    int 21h
    pop ax
    neg ax         ; make number positive
    
divide_loop:
    mov dx, 0
    div bx         ; ax = ax / 10, dx = remainder
    push dx        ; push remainder onto stack
    inc cx         ; increment digit counter
    test ax, ax
    jnz divide_loop
    
print_loop:
    pop dx
    add dl, 30h    ; convert to ASCII
    mov ah, 2      ; print character function
    int 21h
    loop print_loop
    
    pop dx
    pop cx
    pop bx
    pop ax
    ret
print_number endp

end main