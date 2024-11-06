.model small
.stack 100h
.data
    msg1 db 'Nhap so thu nhat: $'
    msg2 db 10,13,'Nhap so thu hai: $'
    msg3 db 10,13,'Ket qua: $'
    num1 dw ?    ; S? th? nh?t
    num2 dw ?    ; S? th? hai
    result dw ?  ; K?t qu?
    sign db ?    ; D?u c?a k?t qu? (0 là duong, 1 là âm)
    
.code
main proc
    mov ax, @data
    mov ds, ax
    
    ; Hi?n th? thông báo nh?p s? th? nh?t
    lea dx, msg1
    mov ah, 9
    int 21h
    
    ; Nh?p s? th? nh?t
    call input_number
    mov num1, ax
    
    ; Hi?n th? thông báo nh?p s? th? hai
    lea dx, msg2
    mov ah, 9
    int 21h
    
    ; Nh?p s? th? hai
    call input_number
    mov num2, ax
    
    ; Th?c hi?n phép tr?
    mov ax, num1
    sub ax, num2
    mov result, ax
    
    ; Ki?m tra d?u c?a k?t qu?
    jns positive
    neg ax      ; N?u âm, d?i thành duong d? in
    mov sign, 1 ; Ðánh d?u s? âm
    jmp print_result
positive:
    mov sign, 0
    
print_result:
    ; Hi?n th? thông báo k?t qu?
    lea dx, msg3
    mov ah, 9
    int 21h
    
    ; In d?u tr? n?u k?t qu? âm
    cmp sign, 1
    jne skip_minus
    mov dl, '-'
    mov ah, 2
    int 21h
skip_minus:
    
    ; In k?t qu?
    mov ax, result
    test ax, ax
    jns print_num
    neg ax
print_num:
    call output_number
    
    ; K?t thúc chuong trình
    mov ah, 4ch
    int 21h
main endp

; Th? t?c nh?p s?
input_number proc
    push bx
    push cx
    push dx
    
    mov bx, 0    ; Luu s?
    mov cx, 0    ; Ð?m s? ký t?
    mov sign, 0  ; M?c d?nh là s? duong
    
    ; Ð?c ký t? d?u tiên
    mov ah, 1
    int 21h
    
    ; Ki?m tra d?u tr?
    cmp al, '-'
    jne not_negative
    mov sign, 1
    mov ah, 1    ; Ð?c s? ti?p theo
    int 21h
not_negative:
    
read_loop:
    ; Ki?m tra ký t? Enter
    cmp al, 13
    je end_input
    
    ; Chuy?n ký t? ASCII thành s?
    sub al, 30h
    
    ; Nhân s? cu v?i 10 và c?ng s? m?i
    mov cl, al
    mov ax, bx
    mov dx, 10
    mul dx
    mov bx, ax
    add bl, cl
    
    ; Ð?c ký t? ti?p
    mov ah, 1
    int 21h
    jmp read_loop
    
end_input:
    mov ax, bx
    
    ; X? lý s? âm
    cmp sign, 1
    jne skip_neg
    neg ax
skip_neg:
    
    pop dx
    pop cx
    pop bx
    ret
input_number endp

; Th? t?c xu?t s?
output_number proc
    push ax
    push bx
    push cx
    push dx
    
    mov bx, 10   ; Chia cho 10
    mov cx, 0    ; Ð?m s? ch? s?
    
    ; Tách các ch? s?
divide_loop:
    mov dx, 0
    div bx
    push dx      ; Luu ph?n du vào stack
    inc cx
    test ax, ax
    jnz divide_loop
    
    ; In các ch? s?
print_loop:
    pop dx
    add dl, 30h  ; Chuy?n s? thành ký t? ASCII
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