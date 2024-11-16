                ORG 0
                CLR P1.7        ; MAKE P1.7 AS OUTPUT
                SETB P2.3       ; SET P2.3 AS INPUT

MONITOR:        JNB P2.3 , MONITOR
                CLR P1.7        ; SEND LOW TO HIGH PULSE
                SETB P1.7       ; TO TUNRN ON BUZZER

                END
