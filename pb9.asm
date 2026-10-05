.MODEL SMALL
.STACK 100H
.DATA
    MSG DB 'Flag byte (SF ZF - AF - PF - CF) = $'
.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    MOV AL, 05H
    SUB AL, 05H          ; operation: 5 - 5 = 0
    LAHF                 ; AH <- flag byte
    MOV BL, AH

    LEA DX, MSG
    MOV AH, 9
    INT 21H

    MOV CX, 8
PRINT:
    MOV DL, '0'
    SHL BL, 1            ; MSB -> Carry Flag
    JNC SKIP
    MOV DL, '1'
SKIP:
    MOV AH, 2
    INT 21H
    LOOP PRINT

    MOV AH, 4CH
    INT 21H
MAIN ENDP
END MAIN