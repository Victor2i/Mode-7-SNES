.define EHIndex = $E0

.define A_DUMP  = $F0 ; 8-bits
.define B_DUMP  = $F1 ; 8-bits
.define X_DUMP  = $F2 ; 16-bits
.define Y_DUMP  = $F4 ; 16-bits
.define S_DUMP  = $F6 ; 16-bits
.define DP_DUMP = $F8 ; 16-bits
.define DB_DUMP = $FA ; 8-bits
.define PC_DUMP = $FB ; 16-bits
.define PB_DUMP = $FD ; 8-bits
.define PS_DUMP = $FE ; 8-bits
.define E_DUMP  = $FF ; 1-bit

Interrupt:
	REP #%00110000
	PHY
	PHX
	SEP #%00110000
	PHA
	XBA
	PHA
	PHD
	PHB
	REP #%00100000
	LDA #$0000
	TCD
	SEP #%00110000
	LDA #$00
	PHA
	PLB
	PLA
	STA DB_DUMP
	PLA
	STA DP_DUMP
	PLA
	STA DP_DUMP+1
	PLA
	STA B_DUMP
	PLA
	STA A_DUMP
	CLC
	XCE
	PHP
	PLA
	AND #%00000001
	STA E_DUMP
	REP #%00110000
	PLX
	STX X_DUMP
	PLY
	STY Y_DUMP
	TSX
	STX S_DUMP
	SEP #%00110000
	PLA
	STA PS_DUMP
	PLA
	STA PC_DUMP
	PLA
	STA PC_DUMP+1
	PLA
	STA PB_DUMP
	REP #%00110000
	LDX #$1FFF
	TXS
	SEP #%00110000
EH_Setup_M0:
	LDA #%10000000
	STA INIDISP
	STZ BG_MODE
	STZ CGRAM_ADDRESS
	STZ CGRAM_DATAW
	STZ CGRAM_DATAW
	LDA #$FF ; Low-byte
	STA CGRAM_DATAW
	LDA #$7F ; Hi-byte
	STA CGRAM_DATAW
	LDA #$8C ; Low-byte
	STA CGRAM_DATAW
	LDA #$31 ; Hi-byte
	STA CGRAM_DATAW
EH_Display_MSGS:
	LDA S_DUMP+1
	AND #%11100000
	BEQ +
	JMP EH_Stack_Error
+	STZ VMAINC
	LDX #0
--	LDA EH_MSGPOSINDEXES.W,X
	STA VMADDL
	INX
	LDA EH_MSGPOSINDEXES.W,X
	STA VMADDH
	DEX
	LDA EH_MSGINDEXES.W,X
	STA EHIndex
	INX
	LDA EH_MSGINDEXES.W,X
	STA EHIndex+1
	LDY #0
-	LDA (EHIndex),Y
	BEQ +
	STA VMDATALW
	INY
	BRA -
+	INX
	CPX #22*2
	BNE --
EH_Display_Registers:
	LDA #$77
	STA VMADDL
	LDA #$44
	STA VMADDH
	LDA PB_DUMP
	JSR EH_Display_hex_byte
	LDA PC_DUMP+1
	JSR EH_Display_hex_byte
	LDA PC_DUMP
	JSR EH_Display_hex_byte
	LDA #$A5
	STA VMADDL
	LDA #$44
	STA VMADDH
	LDA A_DUMP
	JSR EH_Display_hex_byte
	LDA #$E5
	STA VMADDL
	LDA #$44
	STA VMADDH
	LDA B_DUMP
	JSR EH_Display_hex_byte
	LDA #$25
	STA VMADDL
	LDA #$45
	STA VMADDH
	LDA B_DUMP
	JSR EH_Display_hex_byte
	LDA A_DUMP
	JSR EH_Display_hex_byte
	LDA #$65
	STA VMADDL
	LDA #$45
	STA VMADDH
	LDA X_DUMP+1
	JSR EH_Display_hex_byte
	LDA X_DUMP
	JSR EH_Display_hex_byte
	LDA #$A5
	STA VMADDL
	LDA #$45
	STA VMADDH
	LDA Y_DUMP+1
	JSR EH_Display_hex_byte
	LDA Y_DUMP
	JSR EH_Display_hex_byte
	LDA #$E5
	STA VMADDL
	LDA #$45
	STA VMADDH
	LDA S_DUMP+1
	JSR EH_Display_hex_byte
	LDA S_DUMP
	JSR EH_Display_hex_byte
	LDA #$26
	STA VMADDL
	LDA #$46
	STA VMADDH
	LDA DB_DUMP
	JSR EH_Display_hex_byte
	LDA #$66
	STA VMADDL
	LDA #$46
	STA VMADDH
	LDA DP_DUMP+1
	JSR EH_Display_hex_byte
	LDA DP_DUMP
	JSR EH_Display_hex_byte
	LDA #$A6
	STA VMADDL
	LDA #$46
	STA VMADDH
	LDA PB_DUMP
	JSR EH_Display_hex_byte
	LDA #$E6
	STA VMADDL
	LDA #$46
	STA VMADDH
	LDA PC_DUMP+1
	JSR EH_Display_hex_byte
	LDA PC_DUMP
	JSR EH_Display_hex_byte
EH_Display_PS:
	LDY PS_DUMP
	LDA #$F1
	STA VMADDL
	LDA #$44
	STA VMADDH
	TYA
	LDX #7
	JSR EH_Shift_bits
	ORA #%00110000
	STA VMDATALW
	LDA #$31
	STA VMADDL
	LDA #$45
	STA VMADDH
	TYA
	LDX #6
	JSR EH_Shift_bits
	ORA #%00110000
	STA VMDATALW
	LDA #$71
	STA VMADDL
	LDA #$45
	STA VMADDH
	TYA
	LDX #5
	JSR EH_Shift_bits
	ORA #%00110000
	STA VMDATALW
	LDA #$B1
	STA VMADDL
	LDA #$45
	STA VMADDH
	TYA
	LDX #4
	JSR EH_Shift_bits
	ORA #%00110000
	STA VMDATALW
	LDA #$F1
	STA VMADDL
	LDA #$45
	STA VMADDH
	TYA
	LDX #3
	JSR EH_Shift_bits
	ORA #%00110000
	STA VMDATALW
	LDA #$31
	STA VMADDL
	LDA #$46
	STA VMADDH
	TYA
	LDX #2
	JSR EH_Shift_bits
	ORA #%00110000
	STA VMDATALW
	LDA #$71
	STA VMADDL
	LDA #$46
	STA VMADDH
	TYA
	LDX #1
	JSR EH_Shift_bits
	ORA #%00110000
	STA VMDATALW
	LDA #$B1
	STA VMADDL
	LDA #$46
	STA VMADDH
	TYA
	AND #%00000001
	ORA #%00110000
	STA VMDATALW
	LDA #$F1
	STA VMADDL
	LDA #$46
	STA VMADDH
	LDA E_DUMP
	ORA #%00110000
	STA VMDATALW
EH_Disable_FBLANK:
	LDA #%00001111
	STA INIDISP
	STP ; Adieu

EH_Stack_Error:
	STZ VMAINC
	LDX #0
	LDA #$27
	STA VMADDL
	LDA #$44
	STA VMADDH
-	LDA EH_Title.W,X
	BEQ +
	STA VMDATALW
	INX
	BRA -
+	LDX #0
	LDA #$A1
	STA VMADDL
	LDA #$44
	STA VMADDH
-	LDA EH_StackErrorL1.W,X
	BEQ +
	STA VMDATALW
	INX
	BRA -
+	LDX #0
	LDA #$E1
	STA VMADDL
	LDA #$44
	STA VMADDH
-	LDA EH_StackErrorL2.W,X
	BEQ +
	STA VMDATALW
	INX
	BRA -
+	LDX #0
	LDA #$41
	STA VMADDL
	LDA #$45
	STA VMADDH
-	LDA EH_StackErrorL3.W,X
	BEQ +
	STA VMDATALW
	INX
	BRA -
+	LDA #$0B
	STA VMADDL
	LDA #$45
	STA VMADDH
	LDA S_DUMP+1
	JSR EH_Display_hex_byte
	LDA S_DUMP
	JSR EH_Display_hex_byte
	JMP EH_Disable_FBLANK

EH_Shift_bits:
	LSR
	DEX
	BNE EH_Shift_bits
	AND #%00000001
	RTS

EH_Display_hex_byte:
	TAY
	LSR
	LSR
	LSR
	LSR
	JSR EH_Convert_hex_ascii
	STA VMDATALW
	TYA
	AND #%00001111
	JSR EH_Convert_hex_ascii
	STA VMDATALW
	RTS

EH_Convert_hex_ascii:
	PHA
	XBA
	PLA
	XBA
	AND #%00001000
	BNE +
	XBA
	PHA
	XBA
	PLA
	ORA #$30
	RTS
+	XBA
	PHA
	XBA
	PLA
	CMP #8
	BEQ ++
	CMP #9
	BNE +++
++	ORA #$30
	RTS
+++	CLC
	ADC #$37
	RTS

EH_MSGINDEXES:
	.dw EH_Title
	.dw EH_MSG0
	.dw EH_MSG1
	.dw EH_MSG2
	.dw EH_MSG3
	.dw EH_MSG4
	.dw EH_MSG5
	.dw EH_MSG6
	.dw EH_MSG7
	.dw EH_MSG8
	.dw EH_MSG9
	.dw EH_MSG10
	.dw EH_MSG11
	.dw EH_MSG12
	.dw EH_MSG13
	.dw EH_MSG14
	.dw EH_MSG15
	.dw EH_MSG16
	.dw EH_MSG17
	.dw EH_MSG18
	.dw EH_MSG19
	.dw EH_MSG20

EH_MSGPOSINDEXES:
	.dw $4427
	.dw $4461
	.dw $44A1
	.dw $44E1
	.dw $4521
	.dw $4561
	.dw $45A1
	.dw $45E1
	.dw $4621
	.dw $4661
	.dw $46A1
	.dw $46E1
	.dw $44AE
	.dw $44EE
	.dw $452E
	.dw $456E
	.dw $45AE
	.dw $45EE
	.dw $462E
	.dw $466E
	.dw $46AE
	.dw $46EE

EH_Title:
	.db "Exception handler",0

EH_MSG0:
	.db "The crash occured at $",0

EH_MSG1:
	.db "A: $",0

EH_MSG2:
	.db "B: $",0

EH_MSG3:
	.db "C: $",0

EH_MSG4:
	.db "X: $",0

EH_MSG5:
	.db "Y: $",0

EH_MSG6:
	.db "S: $",0

EH_MSG7:
	.db "DB: $",0

EH_MSG8:
	.db "DP: $",0

EH_MSG9:
	.db "PB: $",0

EH_MSG10:
	.db "PC: $",0

EH_MSG11:
	.db "Processor status:",0

EH_MSG12:
	.db "N:",0

EH_MSG13:
	.db "V:",0

EH_MSG14:
	.db "M:",0

EH_MSG15:
	.db "X:",0

EH_MSG16:
	.db "D:",0

EH_MSG17:
	.db "I:",0

EH_MSG18:
	.db "Z:",0

EH_MSG19:
	.db "C:",0

EH_MSG20:
	.db "E:",0

EH_StackErrorL1:
	.db "A crash occured.",0

EH_StackErrorL2:
	.db "The stack was at an invalid     address ($    )",0 ; Les espaces permettent d'aller à la ligne suivante

EH_StackErrorL3:
	.db "Couldn't display registers.",0