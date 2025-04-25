    ORG 0
    ; TIME_DELAY SETUP
        TIME_DELAY_L0_COUNT EQU 55H
        TIME_DELAY_L1_COUNT EQU 56H

        ; TIMER / COUNTER
        ORG 0BH     ; FOR TIMER_0
            LCALL TIMER_0_SUB
            RETI
        ORG 1BH     ; FOR TIMER_1
            LCALL TIMER_1_SUB
            RETI
; ============== MAIN CODE START =====================
    ORG 30H
MAIN:   ; MAIN CODE START


    MAIN_END:   LJMP PROG_END;END
; ============== MAIN CODE END ========================


; ============== SUBROUTINE / FUNCTIONS ===============
; TIME CALCULATED DELAY

TIMER_0_SUB:
    ; TIMER_0 = TH0_TL0
    ; START TIMER_0 => TR0 = 1
    ; END TIMER_0 => TF0 = 1
    ; ---- ---- ---- ---- ----
    ; WRITE CODE HERE
    RET

TIMER_1_SUB:
    ; TIMER_1 = TH1_TL1
    ; START TIMER_1 => TR1 = 1
    ; END TIMER_1 => TF1 = 1
    ; ---- ---- ---- ---- ----
    ; WRITE CODE HERE
    RET

TIMER_0_INIT_MODE_1:
    ; TH0_TL0 = (FFFF - MC)
    MOV A, TMOD
    ANL A, #0F0H
    ADD A, #01H ; MODE 1
    MOV TMOD, A
    RET

TIMER_1_INIT_MODE_1:
    ; TH0_TL0 = (FFFF - MC)
    MOV A, TMOD
    ANL A, #0FH
    SWAP A
    ADD A, #01H ; MODE 1
    SWAP A
    MOV TMOD, A
    RET

TIMER_0_INIT_MODE_2:
    ; TH0 = (FF - MC)
    MOV A, TMOD
    ANL A, #0F0H
    ADD A, #02H ; MODE 2
    MOV TMOD, A
    RET

TIMER_1_INIT_MODE_2:
    ; TH0 = (FF - MC)
    MOV A, TMOD
    ANL A, #0FH
    SWAP A
    ADD A, #02H ; MODE 2
    SWAP A
    MOV TMOD, A
    RET

INTERUPT_ENABLE:
    SETB IE.7
    RET
TIMER_0_ENABLE:
    SETB IE.1
    RET
TIMER_1_ENABLE:
    SETB IE.3
    RET
INTERUPT_DISABLE:
    CLR IE.7
    RET
TIMER_0_DISABLE:
    CLR IE.1
    RET
TIMER_1_DISABLE:
    CLR IE.3
    RET


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