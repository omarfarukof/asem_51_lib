                ORG 0
                MOV R0, #30H        ; START OF NUM_1
                MOV R1, #40H        ; START OF NUM_2
                SETB PSW.3          ; RES BANK 01
                MOV R0, #62H        ; START OF RESULT
                MOV R3, #04H        ; NO. OF BYTES
                CLR C

CONT_ADD:       CLR PSW.3           ; RES BANK 00
                MOV A, @R0
                ADDC A, @R1
                INC R0
                INC R1
                SETB PSW.3          ; RES BANK 01
                MOV @R0, A
                INC R0
                DJNZ R3, CONT_ADD

                END
