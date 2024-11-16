                ORG 00H
                MOV R3, #05H        ; No. of Hex to Convert
                MOV R0, #30H        ; Strating Location of Hex Numbers in RAM
                MOV R1, #40H        ; Strating Location of Dec Numbers in RAM
                MOV R4, #0AH        ; Base of Dec Numbers
HEX2DEC:        MOV R5, #03H        ; No. of Digits for Dec Num ( 8bit Hex = 3digit Dec )
                MOV A, @R0
BASEDIV:        MOV B, R4
                DIV AB
                MOV @R1, B
                INC R1              ; Next Digit of Dec Num
                DJNZ R5, BASEDIV
                INC R0              ; Next Hex Num to Convert
                DJNZ R3, HEX2DEC
                END
