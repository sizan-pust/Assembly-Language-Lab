.model small
.stack 100h

.data
    titleMsg  db 'Basic assembly operations',13,10,'$'
    movMsg    db 'MOV result: $'
    xchgAMsg  db 13,10,'XCHG AL result: $'
    xchgBMsg  db 13,10,'XCHG BL result: $'
    addMsg    db 13,10,'ADD result: $'
    subMsg    db 13,10,'SUB result: $'
    incMsg    db 13,10,'INC result: $'
    decMsg    db 13,10,'DEC result: $'
    negMsg    db 13,10,'NEG result: -$'
    doneMsg   db 13,10,13,10,'Done.$'
    negResult db ?

.code
main proc
    mov ax, @data
    mov ds, ax

    lea dx, titleMsg
    mov ah, 09h
    int 21h

    ; MOV: AL = 5
    mov al, 5
    lea dx, movMsg
    call showResult

    ; XCHG: swap AL = 2 and BL = 7
    mov al, 2
    mov bl, 7
    xchg al, bl

    ; AL now contains 7
    lea dx, xchgAMsg
    call showResult

    ; BL now contains 2
    mov al, bl
    lea dx, xchgBMsg
    call showResult

    ; ADD: 3 + 4 = 7
    mov al, 3
    add al, 4
    lea dx, addMsg
    call showResult

    ; SUB: 8 - 3 = 5
    mov al, 8
    sub al, 3
    lea dx, subMsg
    call showResult

    ; INC: 4 becomes 5
    mov al, 4
    inc al
    lea dx, incMsg
    call showResult

    ; DEC: 6 becomes 5
    mov al, 6
    dec al
    lea dx, decMsg
    call showResult

    ; NEG: 5 becomes -5
    mov al, 5
    neg al
    mov negResult, al      ; Store -5 as FBh

    ; Convert its magnitude to 5 only for displaying
    mov al, negResult
    neg al
    lea dx, negMsg
    call showResult

    lea dx, doneMsg
    mov ah, 09h
    int 21h

    ; Return to DOS
    mov ax, 4C00h
    int 21h
main endp

; Displays the message in DX and a one-digit value in AL
showResult proc near
    push ax

    mov ah, 09h
    int 21h

    pop ax
    add al, '0'
    mov dl, al
    mov ah, 02h
    int 21h
    ret
showResult endp

end main