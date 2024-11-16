                ORG 0
                MOV R3, #34H
                MOV R2, #7AH    ; NUM_1 = 347AH
                MOV R5, #85H
                MOV R4, #34H    ; NUM_2 = 8534H

                MOV A, R2
                SUBB A, R4
                MOV 31H, A

                MOV A, R3
                SUBB A, R5
                MOV 30H, A

                JC CARRY
                LJMP NO_CARRY

CARRY:          LCALL CPL2
NO_CARRY:       NOP

; ------------------------------------------------
                ORG 300H
CPL2:           MOV A, 31H
                CPL A
                ADD A, #01H
                MOV 31H, A

                MOV A, 30H
                CPL A
                ADDC A, #00H
                MOV 30H, A

                SETB C
                RET

                END
