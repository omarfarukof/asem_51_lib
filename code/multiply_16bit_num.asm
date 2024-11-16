                ORG 00H
                MOV 30H, #53H
                MOV 31H, #78H   ;Num_1 = 7853H
                MOV 34H, #9FH
                MOV 35H, #0A3H  ;Num_2 = A39FH

                ; CLR R4,R5,R6,F7
                MOV R4, 0
                MOV R5, 0
                MOV R6, 0
                MOV R7, 0

                ;STEP_1
                MOV A, 30H      ;WL1
                MOV B, 34H      ;WL2
                MUL AB
                MOV R7, A
                MOV R6, B

                ;STEP_4
                MOV A, 31H      ;WH1
                MOV B, 35H      ;WH2
                MUL AB
                MOV R5, A
                MOV R4, B

                ;STEP_2
                MOV A, 30H      ;WL1
                MOV B, 35H      ;WH2
                LCALL STEP_23

                ;STEP_3
                MOV A, 31H      ;WH1
                MOV B, 34H      ;WL2
                LCALL STEP_23

                ;END

; ---------------------------------------------------------
                ORG 300H
STEP_23:        MUL AB
                ADD A, R6       ;(L*H)L
                MOV R6, A
                LCALL CAR5

                MOV A, B        ;(L*H)H
                ADD A, R5
                MOV R5, A
                LCALL CAR4

                RET

; ----------------------------------------------------------
                ORG 400H
CAR5:           CLR A
                ADDC A, R5
                MOV R5, A
CAR4:           CLR A
                ADDC A, R4
                MOV R4, A
                RET

                END
