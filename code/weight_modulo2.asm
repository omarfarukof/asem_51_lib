                ORG 00H
                MOV R2, #73H
                MOV P1, #34H        ; Assume 34h is at port-1
                MOV A, P1
                XRL A, R2
                MOV R1, #08H
                MOV R3, #00H        ; Count Weight 
WEIGHT:         JNB A.0, NOTBIT
                INC R3
NOTBIT:         RR A
		DJNZ R1, WEIGHT
                END
