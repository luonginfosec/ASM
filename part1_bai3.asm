.model small
.stack 100h
.data
    msg1 db 'Nhap so thu nhat: $'    ; "Enter first number: "
    msg2 db 10,13,'Nhap so thu hai: $'    ; "Enter second number: "
    msg3 db 10,13,'Ket qua: $'    ; "Result: "
    num1 dw ?    ; First number storage
    num2 dw ?    ; Second number storage
    result dw ?  ; Result storage
    sign db ?    ; Sign of result (0 for positive, 1 for negative)
    
.code
main proc
    mov ax, @data
    mov ds, ax
    
    ; Display prompt for first number
    lea dx, msg1
    mov ah, 9
    int 21h
    
    ; Input first number
    call input_number
    mov num1, ax
    
    ; Display prompt for second number
    lea dx, msg2
    mov ah, 9
    int 21h
    
    ; Input second number
    call input_number
    mov num2, ax
    
    ; Perform subtraction
    mov ax, num1
    sub ax, num2
    mov result, ax
    
    ; Check result's sign
    jns positive
    neg ax      ; If negative, convert to positive for printing
    mov sign, 1 ; Mark as negative
    jmp print_result
positive:
    mov sign, 0
    
print_result:
    ; Display result message
    lea dx, msg3
    mov ah, 9
    int 21h
    
    ; Print minus sign if result is negative
    cmp sign, 1
    jne skip_minus
    mov dl, '-'
    mov ah, 2
    int 21h
skip_minus:
    
    ; Print the result
    mov ax, result
    test ax, ax
    jns print_num
    neg ax
print_num:
    call output_number
    
    ; End program
    mov ah, 4ch
    int 21h
main endp

; Procedure to input a number
input_number proc
    push bx
    push cx
    push dx
    
    mov bx, 0    ; Store number
    mov cx, 0    ; Character counter
    mov sign, 0  ; Default to positive
    
    ; Read first character
    mov ah, 1
    int 21h
    
    ; Check for minus sign
    cmp al, '-'
    jne not_negative
    mov sign, 1
    mov ah, 1    ; Read next character
    int 21h
not_negative:
    
read_loop:
    ; Check for Enter key
    cmp al, 13
    je end_input
    
    ; Convert ASCII character to number
    sub al, 30h
    
    ; Multiply old number by 10 and add new digit
    mov cl, al
    mov ax, bx
    mov dx, 10
    mul dx
    mov bx, ax
    add bl, cl
    
    ; Read next character
    mov ah, 1
    int 21h
    jmp read_loop
    
end_input:
    mov ax, bx
    
    ; Handle negative number
    cmp sign, 1
    jne skip_neg
    neg ax
skip_neg:
    
    pop dx
    pop cx
    pop bx
    ret
input_number endp

; Procedure to output a number
output_number proc
    push ax
    push bx
    push cx
    push dx
    
    mov bx, 10   ; Divide by 10
    mov cx, 0    ; Digit counter
    
    ; Extract digits
divide_loop:
    mov dx, 0
    div bx
    push dx      ; Save remainder on stack
    inc cx
    test ax, ax
    jnz divide_loop
    
    ; Print digits
print_loop:
    pop dx
    add dl, 30h  ; Convert number to ASCII character
    mov ah, 2
    int 21h
    loop print_loop
    
    pop dx
    pop cx
    pop bx
    pop ax
    ret
output_number endp

end main