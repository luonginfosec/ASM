.model small
.stack 100h
.data
    msg1 db 'Nhap so thu nhat: $'
    msg2 db 10,13,'Nhap so thu hai: $'
    msg3 db 10,13,'Ket qua: $'
    num1 dw ?    ; S? th? nh?t
    num2 dw ?    ; S? th? hai
    result dw ?  ; K?t qu?
    sign db ?    ; D?u c?a k?t qu? (0 l� duong, 1 l� �m)
    
.code
main proc
    mov ax, @data
    mov ds, ax
    
    ; Hi?n th? th�ng b�o nh?p s? th? nh?t
    lea dx, msg1
    mov ah, 9
    int 21h
    
    ; Nh?p s? th? nh?t
    call input_number
    mov num1, ax
    
    ; Hi?n th? th�ng b�o nh?p s? th? hai
    lea dx, msg2
    mov ah, 9
    int 21h
    
    ; Nh?p s? th? hai
    call input_number
    mov num2, ax
    
    ; Th?c hi?n ph�p tr?
    mov ax, num1
    sub ax, num2
    mov result, ax
    
    ; Ki?m tra d?u c?a k?t qu?
    jns positive
    neg ax      ; N?u �m, d?i th�nh duong d? in
    mov sign, 1 ; ��nh d?u s? �m
    jmp print_result
positive:
    mov sign, 0
    
print_result:
    ; Hi?n th? th�ng b�o k?t qu?
    lea dx, msg3
    mov ah, 9
    int 21h
    
    ; In d?u tr? n?u k?t qu? �m
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
    
    ; K?t th�c chuong tr�nh
    mov ah, 4ch
    int 21h
main endp

; Th? t?c nh?p s?
input_number proc
    push bx
    push cx
    push dx
    
    mov bx, 0    ; Luu s?
    mov cx, 0    ; �?m s? k� t?
    mov sign, 0  ; M?c d?nh l� s? duong
    
    ; �?c k� t? d?u ti�n
    mov ah, 1
    int 21h
    
    ; Ki?m tra d?u tr?
    cmp al, '-'
    jne not_negative
    mov sign, 1
    mov ah, 1    ; �?c s? ti?p theo
    int 21h
not_negative:
    
read_loop:
    ; Ki?m tra k� t? Enter
    cmp al, 13
    je end_input
    
    ; Chuy?n k� t? ASCII th�nh s?
    sub al, 30h
    
    ; Nh�n s? cu v?i 10 v� c?ng s? m?i
    mov cl, al
    mov ax, bx
    mov dx, 10
    mul dx
    mov bx, ax
    add bl, cl
    
    ; �?c k� t? ti?p
    mov ah, 1
    int 21h
    jmp read_loop
    
end_input:
    mov ax, bx
    
    ; X? l� s? �m
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
    mov cx, 0    ; �?m s? ch? s?
    
    ; T�ch c�c ch? s?
divide_loop:
    mov dx, 0
    div bx
    push dx      ; Luu ph?n du v�o stack
    inc cx
    test ax, ax
    jnz divide_loop
    
    ; In c�c ch? s?
print_loop:
    pop dx
    add dl, 30h  ; Chuy?n s? th�nh k� t? ASCII
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