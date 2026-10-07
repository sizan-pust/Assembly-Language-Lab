.MODEL SMALL
.STACK 100H
.DATA
    MSG1 DB 'Enter first number  : $'
    MSG2 DB 0DH,0AH,'Enter second number : $'
    MSG3 DB 0DH,0AH,'GCD = $'
.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    LEA DX, MSG1
    MOV AH, 9
    INT 21H
    CALL READ_DEC
    MOV BX, AX           ; BX = first number

    LEA DX, MSG2
    MOV AH, 9
    INT 21H
    CALL READ_DEC
    MOV CX, AX           ; CX = second number

    MOV AX, BX           ; A
    MOV BX, CX           ; B
GCD_LOOP:
    CMP BX, 0
    JE  FOUND
    XOR DX, DX
    DIV BX               ; DX = A mod B
    MOV AX, BX           ; A = B
    MOV BX, DX           ; B = remainder
    JMP GCD_LOOP

FOUND:
    MOV CX, AX           ; save GCD
    LEA DX, MSG3
    MOV AH, 9
    INT 21H
    MOV AX, CX
    CALL PRINT_DEC

    MOV AH, 4CH
    INT 21H
MAIN ENDP

READ_DEC PROC            ; reads digits until Enter, returns AX
    PUSH BX
    PUSH CX
    PUSH DX
    XOR BX, BX           ; BX = number so far
RD_LOOP:
    MOV AH, 1
    INT 21H
    CMP AL, 0DH          ; Enter?
    JE  RD_END
    SUB AL, 30H
    XOR AH, AH
    MOV CX, AX           ; CX = digit
    MOV AX, BX
    MOV DX, 10
    MUL DX               ; AX = number * 10
    ADD AX, CX           ; + digit
    MOV BX, AX
    JMP RD_LOOP
RD_END:
    MOV AX, BX
    POP DX
    POP CX
    POP BX
    RET
READ_DEC ENDP

PRINT_DEC PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    XOR CX, CX
    MOV BX, 10
PD_DIV:
    XOR DX, DX
    DIV BX
    PUSH DX
    INC CX
    CMP AX, 0
    JNE PD_DIV
PD_SHOW:
    POP DX
    ADD DL, 30H
    MOV AH, 2
    INT 21H
    LOOP PD_SHOW
    POP DX
    POP CX
    POP BX
    POP AX
    RET
PRINT_DEC ENDP

END MAIN