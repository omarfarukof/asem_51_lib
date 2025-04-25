    ORG 0
    ; TIME_DELAY SETUP
        TIME_DELAY_L0_COUNT         EQU     55H
        TIME_DELAY_L1_COUNT         EQU     56H

    ; KEYPAD SETUP
        ; bool ( BIT ADDRESSABLE )
        IS_KEY_SINGLE_PRESS  EQU     7FH
        ; PORT CONNECTION ==>> C(4-1)->P(7-4) + R(4-1)->P(3-0)
        KEYPAD_PORT          EQU     P3



; ============== MAIN CODE START =====================
MAIN:   ; MAIN CODE START
        LCALL KEY_GET_ASCII

        IC_HOLD:    JMP IC_HOLD

    MAIN_END:   LJMP PROG_END;END
; ============== MAIN CODE END ========================



; ============== SUBROUTINE / FUNCTIONS ===============
; TIME CALCULATED DELAY
; TIME_DELAY_1MS:
;         ; FOR f = 11Hz => T = 12/f = 1.09091us
;         ; ==> n = 1ms/T = 916 = 3*L0.L1 + 3*L1 + 2 
;         ; ==> L1 = (916 - 2) / ( 3*L0 + 3 )
;         ; ==> L1 = 1 & L0 = 255
;         MOV TIME_DELAY_L1_COUNT, #1
;     TIME_DELAY_1MS_L1:
;         MOV TIME_DELAY_L0_COUNT, #255
;     TIME_DELAY_1MS_L0:
;         DJNZ TIME_DELAY_L0_COUNT, TIME_DELAY_1MS_L0
;         DJNZ TIME_DELAY_L1_COUNT, TIME_DELAY_1MS_L1
;     RET

TIME_DELAY_20MS:
        ; FOR f = 11Hz => T = 1.09091us
        ; ==> n = 20ms/T = 18333 = 3*L0.L1 + 3*L1 + 2 
        ; ==> L1 = 23 & L0 = 255
        MOV TIME_DELAY_L1_COUNT, #23
    TIME_DELAY_20MS_L1:
        MOV TIME_DELAY_L0_COUNT, #255
    TIME_DELAY_20MS_L0:
        DJNZ TIME_DELAY_L0_COUNT, TIME_DELAY_20MS_L0
        DJNZ TIME_DELAY_L1_COUNT, TIME_DELAY_20MS_L1
    RET

; FOR KEYPAD
KEY_GET_ASCII:
    ; TAKE NUMBER INPUT FROM KEYPAD IN ASCII
    LCALL KEY_GET_DECODE
    RET

KEY_GET_NUMBER:
    ; TAKE NUMBER INPUT FROM KEYPAD
    LCALL KEY_GET_DECODE
    CLR C
    SUBB A, #30H
    RET

KEY_GET_DECODE:        
        ; TAKE ASCII VALUE INPUT FROM KEYPAD 
        MOV KEYPAD_PORT, #0F0H

        LCALL KEY_CHECK_COL     ; B = COLUMN INDEX
        ;MOV B, A
        LCALL KEY_CHECK_ROW     ; A = ROW INDEX
        PUSH 0F0H
        MOV B, #04H
        MUL AB
        POP 0F0H
        ADD A, B
        MOV DPTR, #KEYPAD_DATA
        MOVC A, @A+DPTR
        RET

KEY_IGNORE_NOISE:
        MOV A, KEYPAD_PORT
        ANL A, #0F0H
        CJNE A, #0F0H, KEY_IGNORE_NOISE_2
        LCALL TIME_DELAY_20MS; DELAY 20MS
    KEY_IGNORE_NOISE_2:
        MOV A, KEYPAD_PORT
        ANL A, #0F0H
        CJNE A, #0F0H, KEY_IGNORE_NOISE_RETURN
        SJMP KEY_IGNORE_NOISE
    KEY_IGNORE_NOISE_RETURN:
        RET

KEY_CHECK_COL:  
        MOV A, KEYPAD_PORT
        ANL A, #0F0H
        CJNE A, #0F0H, KEY_CHECK_SINGLE_PRESS_LABEL
        CLR IS_KEY_SINGLE_PRESS
        JMP KEY_CHECK_COL
    KEY_CHECK_SINGLE_PRESS_LABEL:
        JB IS_KEY_SINGLE_PRESS, KEY_CHECK_COL
    KEY_CHECK_COLUMN_0:  
        MOV B, #00H
        CJNE A, #0E0H, KEY_CHECK_COLUMN_1
        JMP KEY_CHECK_COLUMN_END
    KEY_CHECK_COLUMN_1:  
        INC B
        CJNE A, #0D0H, KEY_CHECK_COLUMN_2
        JMP KEY_CHECK_COLUMN_END
    KEY_CHECK_COLUMN_2:  
        INC B
        CJNE A, #0B0H, KEY_CHECK_COLUMN_3
        JMP KEY_CHECK_COLUMN_END
    KEY_CHECK_COLUMN_3:  
        INC B
        ;CJNE A, #0F7H, KEY_CHECK_COLUMN_END
        ;JMP KEY_CHECK_COLUMN_END
    KEY_CHECK_COLUMN_END:
        SETB IS_KEY_SINGLE_PRESS
        RET

KEY_CHECK_ROW: 
        PUSH 0F0H
    KEY_CHECK_ROW_0:
        MOV B, #00H
        SETB KEYPAD_PORT.0
        MOV A, KEYPAD_PORT
        ANL A, #0F0H
        CJNE A, #0F0H, KEY_CHECK_ROW_1
        JMP KEY_CHECK_ROW_END
    KEY_CHECK_ROW_1:
        INC B
        SETB KEYPAD_PORT.1
        MOV A, KEYPAD_PORT
        ANL A, #0F0H
        CJNE A, #0F0H, KEY_CHECK_ROW_2
        JMP KEY_CHECK_ROW_END
    KEY_CHECK_ROW_2:
        INC B
        SETB KEYPAD_PORT.2
        MOV A, KEYPAD_PORT
        ANL A, #0F0H
        CJNE A, #0F0H, KEY_CHECK_ROW_3
        JMP KEY_CHECK_ROW_END
    KEY_CHECK_ROW_3:
        INC B
        ; SETB KEYPAD_PORT.3
        ; MOV A, KEYPAD_PORT
        ; ANL A, #0F0H
        ; CJNE A, #0F0H, KEY_CHECK_ROW_END
    KEY_CHECK_ROW_END:
        MOV A, B
        POP 0F0H
        RET

; =================== DATA LOOK UP TABLE =============================
    ; END OF THE STRING HAS TO BE 0
    KEYPAD_DATA:
        DB '7', '8', '9', '/', '4', '5', '6', '*', '1', '2', '3', '-', 'C', '0', '=', '+' , 0
        ;NOP

PROG_END:
    END