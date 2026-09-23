.MODEL SMALL
.STACK 100H
.DATA
    MSG DB 'IBM Character Set (20H - FFH):',0DH,0AH,'$'
.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    LEA DX, MSG
    MOV AH, 9
    INT 21H

    MOV DL, 20H          ; start from space
AGAIN:
    MOV AH, 2
    INT 21H              ; display character in DL
    INC DL               ; next character code
    CMP DL, 0             ; wrapped past FFH? 0??
    JNZ AGAIN            ; jump back if not finished

    MOV AH, 4CH
    INT 21H
MAIN ENDP
END MAIN