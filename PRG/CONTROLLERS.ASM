CHECK_C1: ; On lit les données de la manette
	LDA STDCNTRL1L
	STA Controller_1
	LDA STDCNTRL1H
	STA Controller_1+1
Check_Start: ; On vérifie si le bouton start a été pressé
	LDA Controller_1+1
	AND #%00010000
	BEQ Check_Select
	LDA #$0C
	STA Controller_Timer
	JSR Start_Pressed
Check_Select: ; On vérifie si le bouton select a été pressé
	LDA Controller_1+1
	AND #%00100000
	BEQ Check_A
	LDA #$0C
	STA Controller_Timer
	JSR Select_Pressed
Check_A:
	LDA Controller_1
	AND #%10000000
	BEQ Check_X
	LDA #$0C
	STA Controller_Timer
	JSR A_Pressed
Check_X:
	LDA Controller_1
	AND #%01000000
	BEQ Check_DPAD_Left
	LDA #$0C
	STA Controller_Timer
	JSR X_Pressed
Check_DPAD_Left:
	LDA Controller_1+1
	AND #%00000010
	BEQ Check_DPAD_Right
	LDA #$0C
	STA Controller_Timer
	JSR DPAD_Left_Pressed
Check_DPAD_Right:
	LDA Controller_1+1
	AND #%00000001
	BEQ Check_DPAD_Up
	LDA #$0C
	STA Controller_Timer
	JSR DPAD_Right_Pressed
Check_DPAD_Up:
	LDA Controller_1+1
	AND #%00001000
	BEQ Check_DPAD_Down
	LDA #$0C
	STA Controller_Timer
	JSR DPAD_Up_Pressed
Check_DPAD_Down:
	LDA Controller_1+1
	AND #%00000100
	BEQ Controller_Check_End
	LDA #$0C
	STA Controller_Timer
	JSR DPAD_Down_Pressed
Controller_Check_End:
	RTS

Start_Pressed:
	LDA Menu_Params
	AND #%10000000 ; On vérifie si un menu est ouvert
	BNE + ; Si oui, on vérifie si c'est le menu principal
	JSR Open_Main_Menu ; Sinon, on ouvre le menu principal
	RTS
+	LDA Menu_Params
	AND #%00000011 ; On vérifie si c'est le menu principal
	BEQ Execute_Menu_Selected ; Si oui, on exécute ce qui est sélectionné
	CMP #$01
	BNE ++
	JSR Autoinc_edition_leave
	LDA #%10000000
	STA Menu_Params
	JSR Display_menu
	RTS
++	CMP #$02
	BNE ++
	JSR M7Edit_edition_leave
	LDA #%10000000
	STA Menu_Params
	JSR Display_menu
++	RTS
Execute_Menu_Selected: ; On exécute ce qui est sélectionné dans le menu principal
	LDA Menu_Index
	BNE + ; On passe si ce n'est pas égal à zéro
	LDA #%10000001
	STA Menu_Params
	JSR Display_menu
	JSR Autoinc_edition_enter
	RTS
+	CMP #1
	BNE + ; On passe si ce n'est pas égal à 1
	LDA #%10000010
	STA Menu_Params
	JSR Display_menu
	JSR M7Edit_edition_enter
	RTS
+	JSR Close_main_menu
	RTS

Select_Pressed:
	LDA Menu_Params
	AND #%10000000 ; On vérifie si le menu est ouvert
	BNE + ; Si c'est le cas, on ne s'en va pas
	RTS ; Sinon, on s'en va
+	LDA Menu_Params
	AND #%00000011 ; On vérifie si le menu actuel est le menu principal
	BNE ++ ; Si ce n'est pas le cas, on saute
	LDA Menu_Index
	INA
	CMP #$03 ; On remet l'index à zéro en cas de dépassement
	BNE +
	STZ Menu_Index
	JSR Update_cursor
	RTS
+	STA Menu_Index
	JSR Update_cursor
	RTS
++	LDA Menu_Index
	EOR #%00010000
	STA Menu_Index
	JSR Update_cursor
+++	RTS

A_Pressed:
	LDA Menu_Params
	AND #%10000000 ; On vérifie si le menu est ouvert
	BNE + ; Si c'est le cas, on ne s'en va pas
	RTS ; Sinon, on s'en va
+	LDA Menu_Params
	AND #%00000011 ; On vérifie si c'est le menu principal
	BNE + ; Si ce n'est pas le cas, on saute
	JMP Execute_Menu_Selected ; Sinon, on exécute ce qui est sélectionné
+	LDA Cursor_Params
	AND #%00000001
	BEQ + ; Si le résultat est zéro, on active les flèches
	LDA Cursor_Params
	AND #%11111110
	STA Cursor_Params
	JSR Update_cursor
	RTS
+	INC Cursor_Params
	JSR Update_cursor
	RTS

X_Pressed:
	LDA Menu_Params
	AND #%10000000
	BNE +
	RTS
+	LDA Menu_Params
	AND #%00000011
	BNE +
	RTS
+	LDA #%10000000
	STA Menu_Params
	JSR Display_menu
	RTS

DPAD_Left_Pressed:
	LDA Menu_Params ; On vérifie si on est dans les menus
	AND #%10000000
	BNE +
	RTS
+	LDA Menu_Params
	AND #%00000011
	BNE +
	RTS
+	LDA Menu_Index
	BNE +
	LDA #$0F
	STA Menu_Index
	JSR Update_cursor
	RTS
+	CMP #$10
	BNE +
	LDA #$1F
	STA Menu_Index
	JSR Update_cursor
	RTS
+	DEC Menu_Index
	JSR Update_cursor
	RTS

DPAD_Right_Pressed:
	LDA Menu_Params ; On vérifie si on est dans les menus
	AND #%10000000
	BNE +
	RTS
+	LDA Menu_Params
	AND #%00000011
	BNE +
	RTS
+	LDA Menu_Index
	CMP #$0F
	BNE +
	STZ Menu_Index
	JSR Update_cursor
	RTS
+	CMP #$1F
	BNE +
	LDA #$10
	STA Menu_Index
	JSR Update_cursor
	RTS
+	INC Menu_Index
	JSR Update_cursor
	RTS

DPAD_Up_Pressed:
	LDA Menu_Params
	AND #%10000000
	BNE +
	RTS
+	LDA Menu_Params
	AND #%00000011
	BNE ++
	LDA Menu_Index
	DEA
	CMP #$FF ; On remet l'index à zéro en cas de dépassement
	BNE +
	LDA #$02
	STA Menu_Index
	JSR Update_cursor
	RTS
+	STA Menu_Index
	JSR Update_cursor
	RTS
++	LDA Cursor_Params
	AND #%00000001
	BNE ++
	LDA Menu_Index
	EOR #$10
	STA Menu_Index
	JSR Update_cursor
	RTS
++	JSR Inc_selected_digit
	JSR Display_matrix_edition_values
	RTS

DPAD_Down_Pressed:
	LDA Menu_Params
	AND #%10000000
	BNE +
	RTS
+	LDA Menu_Params
	AND #%00000011
	BNE ++
	LDA Menu_Index
	INA
	CMP #$03 ; On remet l'index à zéro en cas de dépassement
	BNE +
	STZ Menu_Index
	JSR Update_cursor
	RTS
+	STA Menu_Index
	JSR Update_cursor
	RTS
++	LDA Cursor_Params
	AND #%00000001
	BNE ++
	LDA Menu_Index
	EOR #$10
	STA Menu_Index
	JSR Update_cursor
	RTS
++	JSR Dec_selected_digit
	JSR Display_matrix_edition_values
	RTS

Autoinc_edition_enter:
	LDX #$10
	LDY #$10
-	DEX
	LDA MA_AINC,X
	STA MA_Edit,X
	DEY
	BNE -
	RTS

Autoinc_edition_leave:
	LDX #$10
	LDY #$10
-	DEX
	LDA MA_Edit,X
	STA MA_AINC,X
	DEY
	BNE -
	RTS

M7Edit_edition_enter:
	LDX #$10
	LDY #$10
-	DEX
	LDA Matrix_A,X
	STA MA_Edit,X
	DEY
	BNE -
	RTS

M7Edit_edition_leave:
	LDX #$10
	LDY #$10
-	DEX
	LDA MA_Edit,X
	STA Matrix_A,X
	DEY
	BNE -
	RTS