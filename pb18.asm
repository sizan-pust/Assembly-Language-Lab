.MODEL SMALL
.STACK 100H
.DATA
    NUM   DW 200
    MSG1  DB 'Original value: $'
    MSG2  DB 0DH,0AH,'After dividing by 8: $'

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
    MOV BX, NUM
    MOV CL, 3           ; 2^3 = 8
    SHR BX, CL          ; BX = BX / 8
    MOV AX, BX
    CALL PRINT_DEC      ; print result

    MOV AH, 4CH
    INT 21H
MAIN ENDP

PRINT_DEC PROC          ; prints AX in decimal
    XOR CX, CX
    MOV BX, 10
DIV_LOOP:
    XOR DX, DX
    DIV BX
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