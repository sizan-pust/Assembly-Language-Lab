.MODEL SMALL
.STACK 100H
.DATA
    S1  DB 'Hello, $'
    S2  DB 'World!$'
    RES DB 20 DUP(?)
.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    MOV ES, AX         ; STOSB writes to ES:DI
    CLD
    LEA SI, S1
    LEA DI, RES
C1: LODSB              ; AL = [SI], SI++
    CMP AL, '$'
    JE  C2             ; end of string 1
    STOSB              ; [DI] = AL, DI++
    JMP C1
C2: LEA SI, S2
C3: LODSB
    STOSB
    CMP AL, '$'        ; copy string 2 including '$'
    JNE C3
    LEA DX, RES
    MOV AH, 9
    INT 21H
    MOV AH, 4CH
    INT 21H
MAIN ENDP
END MAIN