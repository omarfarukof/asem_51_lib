    ORG 0
    ; TIME_DELAY SETUP
        TIME_DELAY_L0_COUNT         EQU     55H
        TIME_DELAY_L1_COUNT         EQU     56H

    ; DISPLAY SETUP
        LCD_P   EQU P2
        LCD_RS  EQU P1.4
        LCD_RW  EQU P1.5
        LCD_E   EQU P1.6

    ; LCD DELAY
        LCD_DELAY_L0_ADDRESS    EQU 6FH
        LCD_DELAY_L0_COUNT      EQU 22H

    ; KEYPAD SETUP
        ; bool ( BIT ADDRESSABLE )
        IS_KEY_SINGLE_PRESS  EQU     7FH
        ; PORT CONNECTION ==>> C(4-1)->P(7-4) + R(4-1)->P(3-0)
        KEYPAD_PORT                    EQU     P3


    MOV SP, #70H
    MOV PSW, #00H



; ============== MAIN CODE START =====================
MAIN:   ; MAIN CODE START
        LCALL LCD_INIT
        LCALL LCD_CLEAR
        LCALL LCD_CURSOR_RIGHT
        LCALL LCD_CURSOR_INC

        ; LCD STRING DISPLAY
        MOV DPTR, #LCD_STR
        LCALL LCD_STR_PRINT

        LCALL LCD_CURSOR_LINE_2


    KEY_AGAIN:
        LCALL KEY_GET_ASCII
        LCALL LCD_WRITE_DATA
        JMP KEY_AGAIN

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

; FOR LCD
LCD_STR_PRINT:  
        ;MOV DPTR, #LCD_STR
    LCD_STR_PRINT_AGAIN:
        CLR A           ;set A=0 (match found)
        MOVC A, @A+DPTR ;get ASCII code from table
        JZ LSP_END
        LCALL LCD_WRITE_DATA
        INC DPTR
        SJMP LCD_STR_PRINT_AGAIN
    LSP_END:    
        RET


LCD_DELAY:
        MOV LCD_DELAY_L0_ADDRESS, #LCD_DELAY_L0_COUNT
    LCD_DELAY_L0:
        DJNZ LCD_DELAY_L0_ADDRESS, LCD_DELAY_L0        
        RET

LCD_CMD:        
        LCALL LCD_READY     ;send command to LCD
        MOV LCD_P, A        ;copy reg A to port 1
        CLR LCD_RS          ;LCD_RS=0 for command
        CLR LCD_RW          ;R/W=0 for write
        SETB LCD_E          ;LCD_E=1 for high pulse
        LCALL LCD_DELAY     ;give LCD some time
        CLR LCD_E           ;LCD_E=0 for H-to-L pulse
        LCALL LCD_DELAY     ;give LCD some time
        RET


LCD_WRITE_DATA: 
        LCALL LCD_READY     ;write data to LCD
        MOV LCD_P, A        ;copy reg A to port1
        SETB LCD_RS         ;LCD_RS=1 for data
        CLR LCD_RW          ;R/W=0 for write
        SETB LCD_E          ;LCD_E=1 for high pulse
        LCALL LCD_DELAY     ;give LCD some time
        CLR LCD_E           ;LCD_E=0 for H-to-L pulse
        LCALL LCD_DELAY     ;give LCD some time
        RET

LCD_WRITE_NUMBER:  
        LCALL LCD_READY     ;write data to LCD
        ADD A, #30H         ;CONVERT ASCII NUM
        MOV LCD_P, A        ;copy reg A to port1
        SETB LCD_RS         ;LCD_RS=1 for data
        CLR LCD_RW          ;R/W=0 for write
        SETB LCD_E          ;LCD_E=1 for high pulse
        LCALL LCD_DELAY     ;give LCD some time
        CLR LCD_E           ;LCD_E=0 for H-to-L pulse
        LCALL LCD_DELAY     ;give LCD some time
        RET

LCD_READY:      
        SETB LCD_P.7
        CLR LCD_RS
        SETB LCD_RW

    LCD_WAIT:   
        CLR LCD_E
        LCALL LCD_DELAY
        SETB LCD_E
        JB LCD_P.7, LCD_WAIT
        RET

LCD_INIT:       
    MOV A, #38H         ;init. LCD 2 lines, 5x7 matrix
    ACALL LCD_CMD
    LCALL LCD_CURSOR_OFF      ;dispplay on, cursor on
    LCALL LCD_CMD
    RET

LCD_CURSOR_LINE_1:        
    MOV A, #80H         ; CURSOR AT BEGINNING OF LINE 1
    LCALL LCD_CMD
    RET

LCD_CURSOR_LINE_1_POSITION_A:
    ; MOV A, #3 ; FOR 3RD POSITION OF LINE 1
    ADD A, #80H         ; CURSOR AT A POSITION OF LINE 1
    LCALL LCD_CMD
    RET

LCD_CURSOR_LINE_2:        
    MOV A, #0C0H         ; CURSOR AT BEGINNING OF LINE 2
    LCALL LCD_CMD
    RET

LCD_CURSOR_LINE_2_POSITION_A:
    ; MOV A, #3 ; FOR 3RD POSITION OF LINE 2
    ADD A, #0C0H         ; CURSOR AT A POSITION OF LINE 2
    LCALL LCD_CMD
    RET


LCD_CURSOR_ON:        
    MOV A, #0FH         ; Display on, cursor blinking
    LCALL LCD_CMD
    RET

LCD_CURSOR_OFF:       
    MOV A, #0CH         ; Display on, cursor off
    LCALL LCD_CMD
    RET

LCD_CLEAR:        
    MOV A, #01H         ; Clear Display screen
    LCALL LCD_CMD
    RET

LCD_CURSOR_DEC:
    MOV A, #04H         ; Decrement cursor (shift cursor to left)
    LCALL LCD_CMD
    RET

LCD_CURSOR_INC:
    MOV A, #06H         ; Increment cursor (shift cursor to right)
    LCALL LCD_CMD
    RET

LCD_CURSOR_LEFT:
    MOV A, #10H         ; Shift cursor position to left
    LCALL LCD_CMD
    RET

LCD_CURSOR_RIGHT:
    MOV A, #14H         ; Shift cursor position to left
    LCALL LCD_CMD
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
    LCD_STR:  
        DB 'L', 'C', 'D', ' ', 'D', 'I', 'S', 'P', 'L', 'A', 'Y', ' ', 'S', 'T', 'R', ' ', '.', 0
    KEYPAD_DATA:
        DB '7', '8', '9', '/', '4', '5', '6', '*', '1', '2', '3', '-', 'C', '0', '=', '+' , 0

PROG_END:
    END

