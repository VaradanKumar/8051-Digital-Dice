; Digital Dice using 8051 Assembly
; Project report: BCSE309L - Digital Assignment 2
;
; Input:
;   P2.0 - push button (active low)
; Output:
;   P3 - 7-segment display byte
; Timer:
;   Timer 0, Mode 1
;
; IMPORTANT:
; The report has a port-description inconsistency: one section mentions
; Port 1 for the display, but the supplied assembly writes to P3.
; Wire the display to P3.0-P3.7 for this exact program, or change the
; MOV P3 instructions after checking your board wiring.

            ORG 0000H
            SJMP MAIN

MAIN:
            MOV P3, #00H
            MOV TMOD, #01H
            MOV R0, #01H

CHECK_SWITCH:
            JNB P2.0, SWITCH_PRESSED
            SETB TR0
            SJMP CHECK_SWITCH

SWITCH_PRESSED:
            CLR TR0
            ACALL DEBOUNCE
            JNB P2.0, GENERATE
            SJMP CHECK_SWITCH

GENERATE:
            ACALL RANDOM
            ACALL DISPLAY
            ACALL LONG_DELAY

WAIT_RELEASE:
            JNB P2.0, WAIT_RELEASE
            ACALL DEBOUNCE
            MOV P3, #00H
            SJMP CHECK_SWITCH

RANDOM:
            MOV A, TL0
            ADD A, R0
            RR A
            ANL A, #07H
            JZ INVALID
            CJNE A, #07H, VALID

INVALID:
            MOV A, #01H

VALID:
            CJNE A, #06H, DONE
            MOV A, #06H

DONE:
            MOV R2, A
            MOV R0, A
            RET

DISPLAY:
            MOV DPTR, #SEG_TABLE
            MOV A, R2
            DEC A
            MOVC A, @A+DPTR
            MOV P3, A
            RET

DEBOUNCE:
            MOV R4, #250
DB_LOOP:
            MOV R5, #100
            DJNZ R5, $
            DJNZ R4, DB_LOOP
            RET

LONG_DELAY:
            MOV R4, #250
DLY_LOOP1:
            MOV R5, #250
DLY_LOOP2:
            MOV R6, #4
            DJNZ R6, $
            DJNZ R5, DLY_LOOP2
            DJNZ R4, DLY_LOOP1
            RET

; Common-cathode 7-segment codes for digits 1 through 6.
SEG_TABLE:
            DB 06H, 5BH, 4FH, 66H, 6DH, 7DH

            END
