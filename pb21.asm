;Input five numbers, show original and reverse order using the stack, then sum and average
.MODEL SMALL
.STACK 100H
.DATA
    NUMS DB 5 DUP(?)
    MSG1 DB 'Enter 5 single-digit numbers: $'
    MSG2 DB 0DH,0AH,'Original order : $'
    MSG3 DB 0DH,0AH,'Reverse order  : $'
    MSG4 DB 0DH,0AH,'Sum           = $'
    MSG5 DB 0DH,0AH,'Average       = $'
.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    LEA DX, MSG1
    MOV AH, 9
    INT 21H

    LEA SI, NUMS
    MOV CX, 5
    XOR BX, BX           ; BX = sum
INPUT:
    MOV AH, 1
    INT 21H              ; AL = ASCII digit
    MOV [SI], AL         ; store in array
    INC SI
    SUB AL, 30H
    XOR AH, AH
    ADD BX, AX           ; sum += digit
    MOV DL, ' '
    MOV AH, 2
    INT 21H
    LOOP INPUT

    ; ---- original order ----
    LEA DX, MSG2
    MOV AH, 9
    INT 21H
    LEA SI, NUMS
    MOV CX, 5
SHOW1:
    MOV DL, [SI]
    MOV AH, 2
    INT 21H
    MOV DL, ' '
    MOV AH, 2
    INT 21H
    INC SI
    LOOP SHOW1

    ; ---- push all onto stack ----
    LEA SI, NUMS
    MOV CX, 5
PUSHLP:
    MOV AL, [SI]
    XOR AH, AH
    PUSH AX
    INC SI
    LOOP PUSHLP

    ; ---- pop = reverse order ----
    LEA DX, MSG3
    MOV AH, 9
    INT 21H
    MOV CX, 5
POPLP:
    POP DX               ; DL = ASCII digit
    MOV AH, 2
    INT 21H
    MOV DL, ' '
    MOV AH, 2
    INT 21H
    LOOP POPLP

    ; ---- sum ----
    LEA DX, MSG4
    MOV AH, 9
    INT 21H
    MOV AX, BX
    CALL PRINT_DEC

    ; ---- average ----
    LEA DX, MSG5
    MOV AH, 9
    INT 21H
    MOV AX, BX
    MOV CL, 5
    DIV CL               ; AL = quotient, AH = remainder
    MOV BH, AH           ; save remainder
    XOR AH, AH
    CALL PRINT_DEC       ; integer part
    MOV DL, '.'
    MOV AH, 2
    INT 21H
    MOV AL, BH
    SHL AL, 1            ; remainder * 2 = first decimal digit (since /5)
    ADD AL, 30H
    MOV DL, AL
    MOV AH, 2
    INT 21H

    MOV AH, 4CH
    INT 21H
MAIN ENDP

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