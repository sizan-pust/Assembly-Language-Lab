.MODEL SMALL
.STACK 100H
.DATA
    MSG DB 'pabna university of science and technology$'
    NL  DB 0DH,0AH,'$'
.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    LEA DX, MSG          ; show original
    MOV AH, 9
    INT 21H
    LEA DX, NL
    MOV AH, 9
    INT 21H

    LEA SI, MSG
UP:
    MOV AL, [SI]
    CMP AL, '$'
    JE  DONE
    CMP AL, 'a'
    JB  NEXT
    CMP AL, 'z'
    JA  NEXT
    SUB AL, 20H          ; convert
    MOV [SI], AL
NEXT:
    INC SI
    JMP UP
DONE:
    LEA DX, MSG
    MOV AH, 9
    INT 21H

    MOV AH, 4CH
    INT 21H
MAIN ENDP
END MAIN