.MODEL SMALL
.STACK 100H
.DATA
    MSG1 DB 'Enter first number (0-9)  : $'
    MSG2 DB 0DH,0AH,'Enter second number (0-9) : $'
    MSG3 DB 0DH,0AH,'Product = $'
.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    LEA DX, MSG1
    MOV AH, 9
    INT 21H
    MOV AH, 1
    INT 21H
    SUB AL, 30H
    MOV BL, AL           ; BL = first number

    LEA DX, MSG2
    MOV AH, 9
    INT 21H
    MOV AH, 1
    INT 21H
    SUB AL, 30H          ; AL = second number

    MUL BL               ; AX = AL * BL (unsigned)
    MOV BX, AX           ; save product

    LEA DX, MSG3
    MOV AH, 9
    INT 21H
    MOV AX, BX
    CALL PRINT_DEC

    MOV AH, 4CH
    INT 21H
MAIN ENDP

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