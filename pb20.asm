;Reverse all 8 bits of AL
.MODEL SMALL
.STACK 100H
.DATA
    MSG1 DB 'Original AL : $'
    MSG2 DB 0DH,0AH,'Reversed AL : $'
.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    LEA DX, MSG1
    MOV AH, 9
    INT 21H
    MOV AL, 0B2H         ; 10110010
    MOV BL, AL
    CALL PRINT8

    XOR BL, BL           ; BL will collect reversed bits
    MOV CX, 8
REV:
    SHL AL, 1            ; MSB of AL -> CF
    RCR BL, 1            ; CF -> MSB of BL (older bits move right)
    LOOP REV
    MOV AL, BL           ; AL = reversed byte

    LEA DX, MSG2
    MOV AH, 9
    INT 21H
    CALL PRINT8          ; prints BL (same as AL)

    MOV AH, 4CH
    INT 21H
MAIN ENDP

PRINT8 PROC              ; prints BL in binary, BL preserved
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    MOV CX, 8
P8_NEXT:
    MOV DL, '0'
    SHL BL, 1
    JNC P8_SKIP
    MOV DL, '1'
P8_SKIP:
    MOV AH, 2
    INT 21H
    LOOP P8_NEXT
    POP DX
    POP CX
    POP BX
    POP AX
    RET
PRINT8 ENDP

END MAIN