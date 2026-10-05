.MODEL SMALL
.STACK 100H
.DATA
    NUM   DW 25
    MSG1  DB 'Original value: $'
    MSG2  DB 0DH,0AH,'After multiplying by 2: $'

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    LEA DX, MSG1
    MOV AH, 9
    INT 21H
    MOV AX, NUM
    CALL PRINT_DEC      ; print original value

    LEA DX, MSG2
    MOV AH, 9
    INT 21H
    MOV AX, NUM
    SHL AX, 1           ; AX = AX * 2
    CALL PRINT_DEC      ; print result

    MOV AH, 4CH
    INT 21H
MAIN ENDP

PRINT_DEC PROC          ; prints AX in decimal
    XOR CX, CX
    MOV BX, 10
DIV_LOOP:
    XOR DX, DX
    DIV BX              ; AX = AX/10, DX = remainder
    PUSH DX
    INC CX
    CMP AX, 0
    JNE DIV_LOOP
PRINT_LOOP:
    POP DX
    ADD DL, '0'
    MOV AH, 2
    INT 21H
    LOOP PRINT_LOOP
    RET
PRINT_DEC ENDP

END MAIN