.MODEL SMALL
.STACK 100H
.DATA
    MSG1 DB 'Before ROL : $'
    MSG2 DB 0DH,0AH,'After ROL  : $'
.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    MOV BX, 1234H

    LEA DX, MSG1
    MOV AH, 9
    INT 21H
    CALL PRINT_BIN

    MOV CL, 4
    ROL BX, CL           ; 1234H -> 2341H

    LEA DX, MSG2
    MOV AH, 9
    INT 21H
    CALL PRINT_BIN

    MOV AH, 4CH
    INT 21H
MAIN ENDP

PRINT_BIN PROC           ; prints BX in binary, BX preserved
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    MOV CX, 16
PB_NEXT:
    MOV DL, '0'
    SHL BX, 1
    JNC PB_SKIP
    MOV DL, '1'
PB_SKIP:
    MOV AH, 2
    INT 21H
    LOOP PB_NEXT
    POP DX
    POP CX
    POP BX
    POP AX
    RET
PRINT_BIN ENDP

END MAIN