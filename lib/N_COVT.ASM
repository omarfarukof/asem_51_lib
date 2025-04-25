                ORG 0

; ============== MAIN CODE START =====================
MAIN:           ; MAIN CODE START
                NOP

    MAIN_END:   ;END
; ============== MAIN CODE END ========================


; ============== SUBROUTINE / FUNCTIONS ===============

A2DEC:          ; HEX NUM IN A
                MOV B, #10D         ; BASE OF DEC
                DIV AB
;                 MOV @R0, B          ; DEC = REMAINDER (B)
                PUSH 0F0H           ; PUSH REMAINDER (B) TO STACK
                MOV B, #10D         ; BASE OF DEC
                DIV AB
                MOV A, B            ; (DEC_H)
                POP 0F0H            ; POP STACK TO B (DEC_L)
                RET



; =================== DATA LOOK UP TABLE =============================


END