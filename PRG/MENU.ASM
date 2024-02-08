Open_Main_Menu:
	LDA #%10000000
	STA Menu_Params
	STZ Menu_Index
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
	JSR Display_menu
	RTS

Close_main_menu:
	STZ Menu_Params
	STZ Menu_Index
	LDA #7
	STA BG_MODE
	STZ CGRAM_ADDRESS
	LDX #0
-	LDA Color_data.W,X
	STA CGRAM_DATAW
	INX
	CPX #6
	BNE -
	JSR Remove_cursor
	RTS

Display_menu:
	STZ Menu_Index
	JSR Cleanup_menu_screen
	LDA Menu_Params
	AND #%00000011
	BEQ Display_main_menu
	CMP #1
	BEQ Display_autoinc_menu
	CMP #2
	BEQ Display_matrixedit_menu
	RTS

Display_main_menu:
	STZ VMAINC
	LDX #0
--	LDA Menu0_MSGPOSIndexes.W,X
	STA VMADDL
	INX
	LDA Menu0_MSGPOSIndexes.W,X
	STA VMADDH
	DEX
	LDA Menu0_MSGIndexes.W,X
	STA MSGIndex
	INX
	LDA Menu0_MSGIndexes.W,X
	STA MSGIndex+1
	LDY #0
-	LDA (MSGIndex),Y
	BEQ +
	STA VMDATALW
	INY
	BRA -
+	INX
	CPX #5*2
	BNE --
	LDA #%10000000
	STA Cursor_Params
	JSR Update_cursor
	RTS

Display_autoinc_menu:
	STZ VMAINC
	LDX #0
--	LDA Menu1_MSGPOSIndexes.W,X
	STA VMADDL
	INX
	LDA Menu1_MSGPOSIndexes.W,X
	STA VMADDH
	DEX
	LDA Menu1_MSGIndexes.W,X
	STA MSGIndex
	INX
	LDA Menu1_MSGIndexes.W,X
	STA MSGIndex+1
	LDY #0
-	LDA (MSGIndex),Y
	BEQ +
	STA VMDATALW
	INY
	BRA -
+	INX
	CPX #5*2
	BNE --
	JSR Display_M7_matrixes
	JSR Display_autoinc_values
	LDA #%11000000
	STA Cursor_Params
	JSR Update_cursor
	RTS

Display_matrixedit_menu:
	STZ VMAINC
	LDX #0
--	LDA Menu2_MSGPOSIndexes.W,X
	STA VMADDL
	INX
	LDA Menu2_MSGPOSIndexes.W,X
	STA VMADDH
	DEX
	LDA Menu2_MSGIndexes.W,X
	STA MSGIndex
	INX
	LDA Menu2_MSGIndexes.W,X
	STA MSGIndex+1
	LDY #0
-	LDA (MSGIndex),Y
	BEQ +
	STA VMDATALW
	INY
	BRA -
+	INX
	CPX #5*2
	BNE --
	JSR Display_M7_matrixes
	JSR Display_matrix_values
	LDA #%11000000
	STA Cursor_Params
	JSR Update_cursor
	RTS

Display_M7_matrixes:
	STZ VMAINC
	LDX #0
	LDY #0
-	LDA Menu1_MatrixesIndexes.W,X
	STA VMADDL
	INX
	LDA Menu1_MatrixesIndexes.W,X
	STA VMADDH
	INX
	LDA Menu1_MatrixesLetters.W,Y
	STA VMDATALW
	LDA #$3A ; Deux-points
	STA VMDATALW
	INY
	CPY #8
	BNE -
	RTS

Display_autoinc_values:
	LDX #0
-	JSR +
	LDA H_AINC+1
	JSR Display_hex_byte
	LDA H_AINC
	JSR Display_hex_byte
	JSR +
	LDA V_AINC+1
	JSR Display_hex_byte
	LDA V_AINC
	JSR Display_hex_byte
	JSR +
	LDA MX_AINC+1
	JSR Display_hex_byte
	LDA MX_AINC
	JSR Display_hex_byte
	JSR +
	LDA MY_AINC+1
	JSR Display_hex_byte
	LDA MY_AINC
	JSR Display_hex_byte
	JSR +
	LDA MA_AINC+1
	JSR Display_hex_byte
	LDA MA_AINC
	JSR Display_hex_byte
	JSR +
	LDA MB_AINC+1
	JSR Display_hex_byte
	LDA MB_AINC
	JSR Display_hex_byte
	JSR +
	LDA MC_AINC+1
	JSR Display_hex_byte
	LDA MC_AINC
	JSR Display_hex_byte
	JSR +
	LDA MD_AINC+1
	JSR Display_hex_byte
	LDA MD_AINC
	JSR Display_hex_byte
	RTS

+:
	LDA Menu1_ValuesIndexes.W,X
	STA VMADDL
	INX
	LDA Menu1_ValuesIndexes.W,X
	STA VMADDH
	INX
	RTS

Display_matrix_values:
	LDX #0
-	JSR +
	LDA H_Scroll+1
	JSR Display_hex_byte
	LDA H_Scroll
	JSR Display_hex_byte
	JSR +
	LDA V_Scroll+1
	JSR Display_hex_byte
	LDA V_Scroll
	JSR Display_hex_byte
	JSR +
	LDA Matrix_X+1
	JSR Display_hex_byte
	LDA Matrix_X
	JSR Display_hex_byte
	JSR +
	LDA Matrix_Y+1
	JSR Display_hex_byte
	LDA Matrix_Y
	JSR Display_hex_byte
	JSR +
	LDA Matrix_A+1
	JSR Display_hex_byte
	LDA Matrix_A
	JSR Display_hex_byte
	JSR +
	LDA Matrix_B+1
	JSR Display_hex_byte
	LDA Matrix_B
	JSR Display_hex_byte
	JSR +
	LDA Matrix_C+1
	JSR Display_hex_byte
	LDA Matrix_C
	JSR Display_hex_byte
	JSR +
	LDA Matrix_D+1
	JSR Display_hex_byte
	LDA Matrix_D
	JSR Display_hex_byte
	RTS

+:
	LDA Menu1_ValuesIndexes.W,X
	STA VMADDL
	INX
	LDA Menu1_ValuesIndexes.W,X
	STA VMADDH
	INX
	RTS

Display_matrix_edition_values:
	LDX #0
-	JSR +
	LDA H_Edit+1
	JSR Display_hex_byte
	LDA H_Edit
	JSR Display_hex_byte
	JSR +
	LDA V_Edit+1
	JSR Display_hex_byte
	LDA V_Edit
	JSR Display_hex_byte
	JSR +
	LDA MX_Edit+1
	JSR Display_hex_byte
	LDA MX_Edit
	JSR Display_hex_byte
	JSR +
	LDA MY_Edit+1
	JSR Display_hex_byte
	LDA MY_Edit
	JSR Display_hex_byte
	JSR +
	LDA MA_Edit+1
	JSR Display_hex_byte
	LDA MA_Edit
	JSR Display_hex_byte
	JSR +
	LDA MB_Edit+1
	JSR Display_hex_byte
	LDA MB_Edit
	JSR Display_hex_byte
	JSR +
	LDA MC_Edit+1
	JSR Display_hex_byte
	LDA MC_Edit
	JSR Display_hex_byte
	JSR +
	LDA MD_Edit+1
	JSR Display_hex_byte
	LDA MD_Edit
	JSR Display_hex_byte
	RTS

+:
	LDA Menu1_ValuesIndexes.W,X
	STA VMADDL
	INX
	LDA Menu1_ValuesIndexes.W,X
	STA VMADDH
	INX
	RTS

Cleanup_menu_screen:
	LDA #%10000000
	STA VMAINC
	LDX #0
	LDY #8/2
	LDA #$44
	STZ VMADDL
	STA VMADDH
-	STZ VMDATALW
	STZ VMDATAHW
	DEX
	BNE -
	DEY
	BNE -
	RTS

Update_cursor:
	JSR Remove_cursor
	LDA #$81
	STA CGRAM_ADDRESS
	LDA #$1F
	STA CGRAM_DATAW
	STZ CGRAM_DATAW
	LDA Cursor_Params
	AND #%10000000
	BNE +
	RTS
+	LDA Cursor_Params
	AND #%01000000
	BNE +
	JMP Skip_cursor_arrows
+	LDA Menu_Index
	AND #%00001111
	TAX
	LDA Menu1_CursorXPOSIndexes.W,X
	STA OAM_DATA_WORD
	LDA Menu_Index
	AND #%00010000
	BNE +
	LDA #$50 ; Position Y (ligne 1)
	STA OAM_DATA_WORD
	BRA ++
+	LDA #$70 ; Position Y (ligne 2)
	STA OAM_DATA_WORD
++	LDA #$0F ; Carré
	STA OAM_DATA_WORD
	LDA #%00100000 ; Priorité d'affichage
	STA OAM_DATA_WORD
	LDA Cursor_Params
	AND #%00000001 ; On vérifie si il faut afficher les flèches
	BNE +
	JMP +++
+	LDA Menu1_CursorXPOSIndexes.W,X
	STA OAM_DATA_WORD
	LDA Menu_Index
	AND #%00010000
	BNE +
	LDA #$48 ; Position Y (ligne 1)
	STA OAM_DATA_WORD
	BRA ++
+	LDA #$68
	STA OAM_DATA_WORD
++	LDA #$06 ; Flèche pointant vers le haut
	STA OAM_DATA_WORD
	LDA #%00100000 ; Priorité d'affichage
	STA OAM_DATA_WORD
+	LDA Menu1_CursorXPOSIndexes.W,X
	STA OAM_DATA_WORD
	LDA Menu_Index
	AND #%00010000
	BNE +
	LDA #$58 ; Position Y (ligne 1)
	STA OAM_DATA_WORD
	BRA ++
+	LDA #$78
	STA OAM_DATA_WORD
++	LDA #$07 ; Flèche pointant vers le haut
	STA OAM_DATA_WORD
	LDA #%00100000 ; Priorité d'affichage
	STA OAM_DATA_WORD
+++	STZ OAM_ADDRESS_LOW
	RTS
Skip_cursor_arrows:
	LDX Menu_Index
	LDA #$18 ; Position X
	STA OAM_DATA_WORD
	LDA Menu0_CursorYPOSIndexes.W,X
	STA OAM_DATA_WORD
	LDA #$05 ; Flèche pointant vers la droite
	STA OAM_DATA_WORD
	STZ OAM_DATA_WORD
	STZ OAM_ADDRESS_LOW
	RTS

Remove_cursor:
	LDX #$10
	STZ OAM_ADDRESS_LOW
-	STZ OAM_DATA_WORD
	DEX
	BNE -
	STZ OAM_ADDRESS_LOW
	RTS

Display_hex_byte:
	TAY
	LSR
	LSR
	LSR
	LSR
	JSR Convert_hex_ascii
	STA VMDATALW
	TYA
	AND #%00001111
	JSR Convert_hex_ascii
	STA VMDATALW
	RTS

Convert_hex_ascii:
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

Inc_selected_digit:
	LDA Menu_Index
	BNE +
	LDA H_Edit+1
	CLC
	ADC #$10
	STA H_Edit+1
	RTS
+	CMP #$01
	BNE +
	LDA H_Edit+1
	JSR Inc_byte_lowdigit
	STA H_Edit+1
	RTS
+	CMP #$02
	BNE +
	LDA H_Edit
	CLC
	ADC #$10
	STA H_Edit
	RTS
+	CMP #$03
	BNE +
	LDA H_Edit
	JSR Inc_byte_lowdigit
	STA H_Edit
	RTS
+	CMP #$04
	BNE +
	LDA V_Edit+1
	CLC
	ADC #$10
	STA V_Edit+1
	RTS
+	CMP #$05
	BNE +
	LDA V_Edit+1
	JSR Inc_byte_lowdigit
	STA V_Edit+1
	RTS
+	CMP #$06
	BNE +
	LDA V_Edit
	CLC
	ADC #$10
	STA V_Edit
	RTS
+	CMP #$07
	BNE +
	LDA V_Edit
	JSR Inc_byte_lowdigit
	STA V_Edit
	RTS
+	CMP #$08
	BNE +
	LDA MX_Edit+1
	CLC
	ADC #$10
	STA MX_Edit+1
	RTS
+	CMP #$09
	BNE +
	LDA MX_Edit+1
	JSR Inc_byte_lowdigit
	STA MX_Edit+1
	RTS
+	CMP #$0A
	BNE +
	LDA MX_Edit
	CLC
	ADC #$10
	STA MX_Edit
	RTS
+	CMP #$0B
	BNE +
	LDA MX_Edit
	JSR Inc_byte_lowdigit
	STA MX_Edit
	RTS
+	CMP #$0C
	BNE +
	LDA MY_Edit+1
	CLC
	ADC #$10
	STA MY_Edit+1
	RTS
+	CMP #$0D
	BNE +
	LDA MY_Edit+1
	JSR Inc_byte_lowdigit
	STA MY_Edit+1
	RTS
+	CMP #$0E
	BNE +
	LDA MY_Edit
	CLC
	ADC #$10
	STA MY_Edit
	RTS
+	CMP #$0F
	BNE +
	LDA MY_Edit
	JSR Inc_byte_lowdigit
	STA MY_Edit
	RTS
+	CMP #$10
	BNE +
	LDA MA_Edit+1
	CLC
	ADC #$10
	STA MA_Edit+1
	RTS
+	CMP #$11
	BNE +
	LDA MA_Edit+1
	JSR Inc_byte_lowdigit
	STA MA_Edit+1
	RTS
+	CMP #$12
	BNE +
	LDA MA_Edit
	CLC
	ADC #$10
	STA MA_Edit
	RTS
+	CMP #$13
	BNE +
	LDA MA_Edit
	JSR Inc_byte_lowdigit
	STA MA_Edit
	RTS
+	CMP #$14
	BNE +
	LDA MB_Edit+1
	CLC
	ADC #$10
	STA MB_Edit+1
	RTS
+	CMP #$15
	BNE +
	LDA MB_Edit+1
	JSR Inc_byte_lowdigit
	STA MB_Edit+1
	RTS
+	CMP #$16
	BNE +
	LDA MB_Edit
	CLC
	ADC #$10
	STA MB_Edit
	RTS
+	CMP #$17
	BNE +
	LDA MB_Edit
	JSR Inc_byte_lowdigit
	STA MB_Edit
	RTS
+	CMP #$18
	BNE +
	LDA MC_Edit+1
	CLC
	ADC #$10
	STA MC_Edit+1
	RTS
+	CMP #$19
	BNE +
	LDA MC_Edit+1
	JSR Inc_byte_lowdigit
	STA MC_Edit+1
	RTS
+	CMP #$1A
	BNE +
	LDA MC_Edit
	CLC
	ADC #$10
	STA MC_Edit
	RTS
+	CMP #$1B
	BNE +
	LDA MC_Edit
	JSR Inc_byte_lowdigit
	STA MC_Edit
	RTS
+	CMP #$1C
	BNE +
	LDA MD_Edit+1
	CLC
	ADC #$10
	STA MD_Edit+1
	RTS
+	CMP #$1D
	BNE +
	LDA MD_Edit+1
	JSR Inc_byte_lowdigit
	STA MD_Edit+1
	RTS
+	CMP #$1E
	BNE +
	LDA MD_Edit
	CLC
	ADC #$10
	STA MD_Edit
	RTS
+	CMP #$1F
	BNE +
	LDA MD_Edit
	JSR Inc_byte_lowdigit
	STA MD_Edit
+	RTS

Dec_selected_digit:
	LDA Menu_Index
	BNE +
	LDA H_Edit+1
	SEC
	SBC #$10
	STA H_Edit+1
	RTS
+	CMP #$01
	BNE +
	LDA H_Edit+1
	JSR Dec_byte_lowdigit
	STA H_Edit+1
	RTS
+	CMP #$02
	BNE +
	LDA H_Edit
	SEC
	SBC #$10
	STA H_Edit
	RTS
+	CMP #$03
	BNE +
	LDA H_Edit
	JSR Dec_byte_lowdigit
	STA H_Edit
	RTS
+	CMP #$04
	BNE +
	LDA V_Edit+1
	SEC
	SBC #$10
	STA V_Edit+1
	RTS
+	CMP #$05
	BNE +
	LDA V_Edit+1
	JSR Dec_byte_lowdigit
	STA V_Edit+1
	RTS
+	CMP #$06
	BNE +
	LDA V_Edit
	SEC
	SBC #$10
	STA V_Edit
	RTS
+	CMP #$07
	BNE +
	LDA V_Edit
	JSR Dec_byte_lowdigit
	STA V_Edit
	RTS
+	CMP #$08
	BNE +
	LDA MX_Edit+1
	SEC
	SBC #$10
	STA MX_Edit+1
	RTS
+	CMP #$09
	BNE +
	LDA MX_Edit+1
	JSR Dec_byte_lowdigit
	STA MX_Edit+1
	RTS
+	CMP #$0A
	BNE +
	LDA MX_Edit
	SEC
	SBC #$10
	STA MX_Edit
	RTS
+	CMP #$0B
	BNE +
	LDA MX_Edit
	JSR Dec_byte_lowdigit
	STA MX_Edit
	RTS
+	CMP #$0C
	BNE +
	LDA MY_Edit+1
	SEC
	SBC #$10
	STA MY_Edit+1
	RTS
+	CMP #$0D
	BNE +
	LDA MY_Edit+1
	JSR Dec_byte_lowdigit
	STA MY_Edit+1
	RTS
+	CMP #$0E
	BNE +
	LDA MY_Edit
	SEC
	SBC #$10
	STA MY_Edit
	RTS
+	CMP #$0F
	BNE +
	LDA MY_Edit
	JSR Dec_byte_lowdigit
	STA MY_Edit
	RTS
+	CMP #$10
	BNE +
	LDA MA_Edit+1
	SEC
	SBC #$10
	STA MA_Edit+1
	RTS
+	CMP #$11
	BNE +
	LDA MA_Edit+1
	JSR Dec_byte_lowdigit
	STA MA_Edit+1
	RTS
+	CMP #$12
	BNE +
	LDA MA_Edit
	SEC
	SBC #$10
	STA MA_Edit
	RTS
+	CMP #$13
	BNE +
	LDA MA_Edit
	JSR Dec_byte_lowdigit
	STA MA_Edit
	RTS
+	CMP #$14
	BNE +
	LDA MB_Edit+1
	SEC
	SBC #$10
	STA MB_Edit+1
	RTS
+	CMP #$15
	BNE +
	LDA MB_Edit+1
	JSR Dec_byte_lowdigit
	STA MB_Edit+1
	RTS
+	CMP #$16
	BNE +
	LDA MB_Edit
	SEC
	SBC #$10
	STA MB_Edit
	RTS
+	CMP #$17
	BNE +
	LDA MB_Edit
	JSR Dec_byte_lowdigit
	STA MB_Edit
	RTS
+	CMP #$18
	BNE +
	LDA MC_Edit+1
	SEC
	SBC #$10
	STA MC_Edit+1
	RTS
+	CMP #$19
	BNE +
	LDA MC_Edit+1
	JSR Dec_byte_lowdigit
	STA MC_Edit+1
	RTS
+	CMP #$1A
	BNE +
	LDA MC_Edit
	SEC
	SBC #$10
	STA MC_Edit
	RTS
+	CMP #$1B
	BNE +
	LDA MC_Edit
	JSR Dec_byte_lowdigit
	STA MC_Edit
	RTS
+	CMP #$1C
	BNE +
	LDA MD_Edit+1
	SEC
	SBC #$10
	STA MD_Edit+1
	RTS
+	CMP #$1D
	BNE +
	LDA MD_Edit+1
	JSR Dec_byte_lowdigit
	STA MD_Edit+1
	RTS
+	CMP #$1E
	BNE +
	LDA MD_Edit
	SEC
	SBC #$10
	STA MD_Edit
	RTS
+	CMP #$1F
	BNE +
	LDA MD_Edit
	JSR Dec_byte_lowdigit
	STA MD_Edit
+	RTS

Inc_byte_lowdigit:
	PHA
	XBA
	PLA
	AND #%00001111
	CMP #$0F
	BNE +
	XBA
	AND #%11110000
	RTS
+	XBA
	INA
	RTS

Dec_byte_lowdigit:
	PHA
	XBA
	PLA
	AND #%00001111
	BNE +
	XBA
	CLC
	ADC #$0F
	RTS
+	XBA
	DEA
	RTS