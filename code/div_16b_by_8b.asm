; Compiler: Asem-51

                ORG 0H

                ; SETUP VARIABLES WITH RAM ADDRESS
                NUM_H EQU 40H
                NUM_L EQU 41H

                NUM_DIV EQU 42H

                Ga      EQU 30H
                Gb      EQU 31H
                Gc_H    EQU 28H
                Gc_L    EQU 29H

                R_1      EQU 20H
                R       EQU 21H
                ;MOV R, #00H

                A_NH     EQU 35H
                A_NL     EQU 36H
                B_N      EQU 37H

				MOV SP, #60H


MAIN:           ; NUM = 0EDCH ; DIV = 21
                MOV NUM_H, #07EH
                MOV NUM_L, #0DCH
				
				;MOV NUM_H, #01H
                ;MOV NUM_L, #0CH
                MOV NUM_DIV, #21H
                LCALL DIV_16B_8B
;				MOV A, NUM_H
;				LCALL TAKE_NIBBLE_H
				
    MAIN_END:   LJMP PROG_END
				NOP


DIV_16B_8B:     ; TAKE 3/4 DIGIT NUM IN [ NUM_H:NUM_L ]
                ; TAKE 2 DIGIT  [ NUM_DIV ]
                ; RESULT WILL BE STORED IN [ R5:R6 ] (3 DIGIT)
                ; REMAINDER WILL BE STORED IN [ B ]
                MOV A, NUM_H
                LCALL TAKE_NIBBLE_H
                JNZ D_16_8
                LJMP DIV_12B_8B

    D_16_8:     ;TAKE PER NEBEL
                PUSH 03H
                PUSH 04H
                ;=====================

                MOV A, NUM_H
                LCALL TAKE_NIBBLE_H
                MOV R3, A       ; #X00

                MOV A, NUM_H
                LCALL TAKE_NIBBLE_L
                SWAP A
                MOV R4, A       ; #0XX

                MOV A, NUM_L
                LCALL TAKE_NIBBLE_H
                ADD A, R4
                MOV R4, A

                PUSH NUM_H
                PUSH NUM_L       ;============
                MOV NUM_H, R3
                MOV NUM_L, R4
                LCALL DIV_12B_8B


                MOV R6, A
                LCALL TAKE_NIBBLE_H
                MOV R5, A
                MOV A, R6
                LCALL TAKE_NIBBLE_L
                SWAP A
                MOV R6, A

                POP NUM_L        ;============
                POP NUM_H


                MOV A, B
                LCALL TAKE_NIBBLE_H
;                SWAP A
                MOV NUM_H, A
                MOV A, B
                LCALL TAKE_NIBBLE_L
                SWAP A
                MOV B, A

                MOV A, NUM_L
                LCALL TAKE_NIBBLE_L
                ADD A, B
                MOV NUM_L, A

                LCALL DIV_12B_8B
                ADD A, R6
                MOV R6, A
                MOV A, R5
                ADDC A, #00H
                MOV R5, A

                ;=====================
                POP 04H
                POP 03H

                RET

DIV_12B_8B:     MOV A_NH, NUM_H
                MOV A_NL, NUM_L
                MOV B_N, NUM_DIV

                MOV A, #0FFH
                MOV B, B_N
                DIV AB
                MOV Ga, A
                MOV Gb, B

				MOV R, #00H

    DIV_3D:     MOV A, A_NH
                JZ DIV_LD

                ; FOR #X00
                MOV A, Ga
                MOV B, A_NH
                MUL AB
                MOV R_1, A
                ADD A, R
                MOV R, A

                ; REMAIN OF #X00
                MOV A, R_1
                MOV B, B_N
                MUL AB

                MOV Gc_H, B
                MOV Gc_L, A

                CLR C
                CLR A
                SUBB A, Gc_L
                MOV Gc_L, A

                MOV A, A_NH
                SUBB A, Gc_H
                MOV Gc_H, A

    DIV_LD:     ; FOR #XX
                MOV A, A_NL
                MOV B, NUM_DIV
                DIV AB
                ADD A, R
                MOV R, A

    ADD_REMAIN: ; ADD REMAIN OF #XX & #X00
                MOV A, B
                ADD A, Gc_L
                MOV A_NL, A

                CLR A
                ADDC A, Gc_H
                MOV A_NH, A

                JNZ DIV_3D
                CLR C
                MOV A, A_NL
                SUBB A, B_N
                JC DIV_LD

                MOV A, A_NL
                MOV B, NUM_DIV
                DIV AB
                ADD A, R

                RET

TAKE_NIBBLE_H:  ; MOV A , #NUM
                ANL A, #0F0H
                SWAP A
                RET

TAKE_NIBBLE_L:  ; MOV A , #NUM
                ANL A, #0FH
                RET

PROG_END:		NOP
                END
