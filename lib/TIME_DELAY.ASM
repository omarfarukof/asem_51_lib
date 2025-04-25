    ORG 0
    ; TIME_DELAY SETUP
        TIME_DELAY_L0_COUNT         EQU     55H
        TIME_DELAY_L1_COUNT         EQU     56H

; ============== MAIN CODE START =====================
MAIN:   ; MAIN CODE START


    MAIN_END:   LJMP PROG_END;END
; ============== MAIN CODE END ========================


; ============== SUBROUTINE / FUNCTIONS ===============
; TIME CALCULATED DELAY
TIME_DELAY_1MS:
        ; FOR f = 11Hz => T = 12/f = 1.09091us
        ; ==> n = 1ms/T = 916 = 3*L0.L1 + 3*L1 + 2 
        ; ==> L1 = (916 - 2) / ( 3*L0 + 3 )
        ; ==> L1 = 1 & L0 = 255
        MOV TIME_DELAY_L1_COUNT, #1
    TIME_DELAY_1MS_L1:
        MOV TIME_DELAY_L0_COUNT, #255
    TIME_DELAY_1MS_L0:
        DJNZ TIME_DELAY_L0_COUNT, TIME_DELAY_1MS_L0
        DJNZ TIME_DELAY_L1_COUNT, TIME_DELAY_1MS_L1
    RET

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


PROG_END:
    END