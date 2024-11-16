                ORG 00H
                MOV DPTR, #350H
                CLR PSW.3
                CLR PSW.4

                LCALL DP2RX
                SETB PSW.3
                LCALL DP2RX

                ; DP2RX Subroutine
                ORG 200H
DP2RX:          CLR A
                MOVC A, @A+DPTR
                MOV R0, A
                INC DPTR
                CLR A
                MOVC A, @A+DPTR
                MOV R1, A
                INC DPTR
                CLR A
                MOVC A, @A+DPTR
                MOV R2, A
                INC DPTR
                RET

; ---------- Assuming "Jurgen" is Stored at 350H on-chip ROM ----------
                ORG 350H
                DB 'Jurgen',0
                END
