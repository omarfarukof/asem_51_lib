    ORG 0
    ; LCD DISPLAY SETUP
        LCD_P   EQU P2
        LCD_RS  EQU P1.4
        LCD_RW  EQU P1.5
        LCD_E   EQU P1.6
        ; LCD DELAY
        LCD_DELAY_L0_ADDRESS    EQU 6FH
        LCD_DELAY_L0_COUNT      EQU 22H

        MOV SP, #70H
        MOV PSW, #00H



; ============== MAIN CODE START =====================
MAIN:   ; MAIN CODE START
        LCALL LCD_INIT
        LCALL LCD_CLEAR
        LCALL LCD_CURSOR_RIGHT
        LCALL LCD_CURSOR_INC
        
        MOV A, #31H
        LCALL LCD_WRITE_DATA

        ; LCD STRING DISPLAY
        LCALL LCD_CURSOR_LINE_2
        MOV DPTR, #LCD_STR
        LCALL LCD_STR_PRINT

    IC_HOLD:    JMP IC_HOLD
    MAIN_END:   LJMP PROG_END;END
; ============== MAIN CODE END ========================



; ============== SUBROUTINE / FUNCTIONS ===============
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


; =================== DATA LOOK UP TABLE =============================
    ; END OF THE STRING HAS TO BE 0
    LCD_STR:  DB 'L', 'C', 'D', ' ', 'D', 'I', 'S', 'P', 'L', 'A', 'Y', ' ', 'S', 'T', 'R', ' ', '.', 0
                NOP
PROG_END:
                END

