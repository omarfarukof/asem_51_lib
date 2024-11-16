                ORG 00H
                MOV R0, #30H    ; START OF STRING
                MOV R1, #36H    ; END OF STRING
                MOV R2, #03H    ; 7BYTES / 2 = 3

CHECK:          MOV A, @R0
                SUBB A, @R1
                JNZ NOT_PALIN
                INC R0
                DEC R1
                DJNZ R2, CHECK

                MOV DPTR, #50H
                MOVC A, @A+DPTR     ; IS PALINDROME
                MOV P1, A
NOT_PALIN:

; ---------------------------------------------
                ORG 50H
                DB 'Y',0

                END

