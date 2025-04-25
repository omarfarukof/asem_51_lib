    ORG 0
    SJMP MAIN

    ; ---- ---- ----
    ; WRITE SETUP CODES HERE
    ; ---- ---- ----


    MOV SP, #70H
    MOV PSW, #00H



; ============== MAIN CODE START =====================
    ORG 30H
MAIN:   ; MAIN CODE START
    
    ; ---- ---- ----
    ; WRITE MAIN CODE HERE
    ; ---- ---- ----

    MAIN_END:   LJMP PROG_END;END
; ============== MAIN CODE END ========================



; ============== SUBROUTINE / FUNCTIONS ===============

; ---- ---- ----
; WRITE SUBROUTINES HERE\
; ---- ---- ----

; =================== DATA LOOK UP TABLE =============================
    ; END OF THE STRING HAS TO BE 0
    
    ; ---- ---- ----
    ; TABLE_LABEL:
        ; DB '1', '2' , ... ... , 0
    ; ---- ---- ----

PROG_END:
    END