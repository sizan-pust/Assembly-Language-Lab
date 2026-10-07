.MODEL SMALL
.STACK 100H
.DATA
    MSG1 DB 'Enter dividend (e.g. -7): $'
    MSG2 DB 0DH,0AH,'Enter divisor  (e.g. 2) : $'
    MSG3 DB 0DH,0AH,'Quotient  = $'
    MSG4 DB 0DH,0AH,'Remainder = $'
    MSG5 DB 0DH,0AH,'Error: division by zero.$'
.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    LEA DX, MSG1
    MOV AH, 9
    INT 21H
    CALL READ_NUM
    MOV BH, AL           ; BH = dividend

    LEA DX, MSG2
    MOV AH, 9
    INT 21H
    CALL READ_NUM
    MOV BL, AL           ; BL = divisor

    CMP BL, 0
    JE  DIV_ZERO

    MOV AL, BH
    CBW                  ; sign-extend AL into AX
    IDIV BL              ; AL = quotient, AH = remainder
    MOV CX, AX           ; CL = quotient, CH = remainder

    LEA DX, MSG3
    MOV AH, 9
    INT 21H
    MOV AL, CL
    CALL PRINT_SIGNED

    LEA DX, MSG4
    MOV AH, 9
    INT 21H
    MOV AL, CH
    CALL PRINT_SIGNED
    JMP EXIT

DIV_ZERO:
    LEA DX, MSG5
    MOV AH, 9
    INT 21H
EXIT:
    MOV AH, 4CH
    INT 21H
MAIN ENDP

READ_NUM PROC            ; reads [-]digit, returns signed value in AL
    PUSH BX
    XOR BL, BL           ; BL = 0 means positive
    MOV AH, 1
    INT 21H
    CMP AL, '-'
    JNE RN_DIGIT
    MOV BL, 1            ; negative
    MOV AH, 1
    INT 21H
RN_DIGIT:
    SUB AL, 30H
    CMP BL, 1
    JNE RN_DONE
    NEG AL
RN_DONE:
    POP BX
    RET
READ_NUM ENDP

PRINT_SIGNED PROC        ; prints signed byte in AL
    PUSH AX
    PUSH DX
    CMP AL, 0
    JGE PS_POS
    PUSH AX
    MOV DL, '-'
    MOV AH, 2
    INT 21H
    POP AX
    NEG AL
PS_POS:
    XOR AH, AH
    CALL PRINT_DEC
    POP DX
    POP AX
    RET
PRINT_SIGNED ENDP

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