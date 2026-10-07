.MODEL SMALL
.STACK 100H
.DATA
    M1 DB 'Enter n (0-8): $'
    M2 DB 0DH,0AH,'Factorial = $'
.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    LEA DX, M1
    MOV AH, 9
    INT 21H
    MOV AH, 1
    INT 21H
    SUB AL, 30H
    XOR AH, AH
    MOV CX, AX         ; CX = n
    CALL FACT          ; AX = n!
    MOV BX, AX
    LEA DX, M2
    MOV AH, 9
    INT 21H
    MOV AX, BX
    MOV BX, 10
    XOR CX, CX
P1: XOR DX, DX
    DIV BX
    PUSH DX            ; remainder = next digit
    INC CX
    OR  AX, AX
    JNZ P1
P2: POP DX
    ADD DL, '0'
    MOV AH, 2
    INT 21H
    LOOP P2
    MOV AH, 4CH
    INT 21H
MAIN ENDP

FACT PROC              ; in: CX = n, out: AX = n!
    CMP CX, 1
    JA  REC
    MOV AX, 1          ; base case: 0! = 1! = 1
    RET
REC:
    PUSH CX            ; save n
    DEC CX
    CALL FACT          ; AX = (n-1)!
    POP CX             ; restore n
    MUL CX             ; AX = n * (n-1)!
    RET
FACT ENDP
END MAIN