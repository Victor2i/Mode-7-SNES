.define Matrix_A   = $00
.define Matrix_B   = $02
.define Matrix_C   = $04
.define Matrix_D   = $06
.define Matrix_X   = $08
.define Matrix_Y   = $0A
.define H_Scroll   = $0C
.define V_Scroll   = $0E
.define MA_AINC    = $10
.define MB_AINC    = $12
.define MC_AINC    = $14
.define MD_AINC    = $16
.define MX_AINC    = $18
.define MY_AINC    = $1A
.define H_AINC     = $1C
.define V_AINC     = $1E
.define MA_Edit    = $20
.define MB_Edit    = $22
.define MC_Edit    = $24
.define MD_Edit    = $26
.define MX_Edit    = $28
.define MY_Edit    = $2A
.define H_Edit     = $2C
.define V_Edit     = $2E

.define Controller_Timer = $38
.define Controller_1     = $3E

.define Menu_Params   = $30 ; %E00000MM
.define Menu_Index    = $31
.define Cursor_Params = $32 ; %ET00000A
.define Cursor_PosX   = $33
.define Cursor_PosY   = $34

.define MSGIndex = $40

START:
	REP #%00110000
	LDA #$0000
	LDX #$0000
	LDY #$0000
	SEP #%00110000
Transfer_graphics_data:
	STZ DMA_SETTINGS
	LDA #<VMDATAHW
	STA DMA_BADD
	LDA #<Graphics_data
	STA DMA_AADDL
	LDA #>Graphics_data
	STA DMA_AADDM
	STZ DMA_AADDH
	STZ DMA_SIZEL
	LDA #$20
	STA DMA_SIZEH
	STZ DMA_SETTINGS+$10
	LDA #<CGRAM_DATAW
	STA DMA_BADD+$10
	LDA #<Color_data
	STA DMA_AADDL+$10
	LDA #>Color_data
	STA DMA_AADDM+$10
	STZ DMA_AADDH+$10
	LDA #$44
	STA DMA_SIZEL+$10
	STZ DMA_SIZEH+$10
	LDA #%00000011
	STA DMA_ENABLE
Transfer_menu_graphics_data:
	LDA #%00000001
	STA DMA_SETTINGS
	LDA #<VMDATALW
	STA DMA_BADD
	LDA #<Menu_Graphics_data
	STA DMA_AADDL
	LDA #>Menu_Graphics_data
	STA DMA_AADDM
	STZ DMA_AADDH
	STZ DMA_SIZEL
	LDA #$08
	STA DMA_SIZEH
	LDA #%10000000
	STA VMAINC
	STZ VMADDL
	LDA #$40
	STA VMADDH
	LDA #%00000001
	STA DMA_ENABLE
Transfer_character_data:
	STZ VMAINC
	STZ VMADDL
	STZ VMADDH
	LDA #4 ; Nombre de groupes de couleurs
	STA 1
	LDA #8
	XBA
	LDA #2
	STA 0
ChrTransferLoop: ; écrit 8 lignes (ordre +)
	LDY #4
	JSR Chr_transfer_loop
	XBA
	DEA
	BEQ ChrTransferLoop2
	XBA
	SEC
	SBC #8
	JMP ChrTransferLoop
ChrTransferLoop2:
	LDA #8
	XBA
	SEC
	SBC #7
ChrTransferLoop2_2: ; écrit 8 lignes (ordre -)
	LDY #4
	JSR Chr_transfer_loop2
	XBA
	DEA
	BEQ ChrTransferLoop3
	XBA
	SEC
	SBC #8
	JMP ChrTransferLoop2_2
ChrTransferLoop3: ; Vérifie si 32 lignes ont été écrites
	DEC 0
	BEQ ChrTransferLoop4
	LDA #8 ; Réinitialise les accumulateurs A et B
	XBA
	SEC
	SBC #9 ; Remet la couleur avec laquelle on a commencé
	JMP ChrTransferLoop
ChrTransferLoop4:
	DEC 1
	BEQ ChrTransferEnd
	LDA #2
	STA 0
	LDA #8
	XBA
	DEA
	JMP ChrTransferLoop
ChrTransferEnd:
	LDA #%10000001
	STA NMITIMEN
	JMP M7_Setup

ChrT1:
	LDX #8
ChrT2:
	STA VMDATALW
	DEX
	BNE ChrT2
	INA
	LDX #8
ChrT3:
	STA VMDATALW
	DEX
	BNE ChrT3
	DEA
	LDX #8
ChrT4:
	STA VMDATALW
	DEX
	BNE ChrT4
	INA
	LDX #8
ChrT5:
	STA VMDATALW
	DEX
	BNE ChrT5
	DEA
	RTS

ChrT2_1:
	LDX #8
ChrT2_2:
	STA VMDATALW
	DEX
	BNE ChrT2_2
	DEA
	LDX #8
ChrT2_3:
	STA VMDATALW
	DEX
	BNE ChrT2_3
	INA
	LDX #8
ChrT2_4:
	STA VMDATALW
	DEX
	BNE ChrT2_4
	DEA
	LDX #8
ChrT2_5:
	STA VMDATALW
	DEX
	BNE ChrT2_5
	INA
	RTS

Chr_transfer_loop: ; écrit 1 ligne (ordre +)
	JSR ChrT1
	INA
	INA
	DEY
	BNE Chr_transfer_loop
	RTS

Chr_transfer_loop2: ; écrit une ligne (ordre -)
	JSR ChrT2_1
	INA
	INA
	DEY
	BNE Chr_transfer_loop2
	RTS

M7_Setup:
	LDA #1
	STA Matrix_A+1
	STA Matrix_D+1
	LDA #$FF
	STA V_Scroll
	STA V_Scroll+1

END:
	JMP END

VBLANK:
	LDA #%10000000
	STA INIDISP
	LDA Controller_Timer
	BEQ + ; Si il est à zéro, on passe
	DEA
	STA Controller_Timer
	JMP ++
+	JSR CHECK_C1
++	LDA Menu_Params ; On vérifie si le menu est affiché
	AND #%10000000
	BNE Skip_M7_matrix_update ; Si oui, on ne met pas à jour les matrices du mode 7, mais on met à jour le scrolling du mode 0
	JSR Autoinc_M7_matrixes ; Sinon, on met à jour les matrices du mode 7... Et on commence par l'auto-incrémentation
	JSR Update_M7_matrixes
	BRA Skip_M0_scroll_update ; ...Et on ne met pas à jour le scroll du mode 0
Skip_M7_matrix_update:
	LDA #$FF
	STZ BG1HOFS
	STZ BG1HOFS
	STA BG1VOFS
	STA BG1VOFS ; BG1VOFS = $FFFF = -1
Skip_M0_scroll_update:
	LDA #%00001111
	STA INIDISP
	RTI

Update_M7_matrixes:
	LDA Matrix_A
	STA M7A
	LDA Matrix_A+1
	STA M7A
	LDA Matrix_B
	STA M7B
	LDA Matrix_B+1
	STA M7B
	LDA Matrix_C
	STA M7C
	LDA Matrix_C+1
	STA M7C
	LDA Matrix_D
	STA M7D
	LDA Matrix_D+1
	STA M7D
	LDA Matrix_X
	STA M7X
	LDA Matrix_X+1
	STA M7X
	LDA Matrix_Y
	STA M7Y
	LDA Matrix_Y+1
	STA M7Y
	LDA H_Scroll
	STA BG1HOFS
	LDA H_Scroll+1
	STA BG1HOFS
	LDA V_Scroll
	STA BG1VOFS
	LDA V_Scroll+1
	STA BG1VOFS
	RTS

Autoinc_M7_matrixes:
	CLC
	LDA Matrix_A
	ADC MA_AINC
	STA Matrix_A
	LDA Matrix_A+1
	ADC MA_AINC+1
	STA Matrix_A+1
	CLC
	LDA Matrix_B
	ADC MB_AINC
	STA Matrix_B
	LDA Matrix_B+1
	ADC MB_AINC+1
	STA Matrix_B+1
	CLC
	LDA Matrix_C
	ADC MC_AINC
	STA Matrix_C
	LDA Matrix_C+1
	ADC MC_AINC+1
	STA Matrix_C+1
	CLC
	LDA Matrix_D
	ADC MD_AINC
	STA Matrix_D
	LDA Matrix_D+1
	ADC MD_AINC+1
	STA Matrix_D+1
	CLC
	LDA Matrix_X
	ADC MX_AINC
	STA Matrix_X
	LDA Matrix_X+1
	ADC MX_AINC+1
	STA Matrix_X+1
	CLC
	LDA Matrix_Y
	ADC MY_AINC
	STA Matrix_Y
	LDA Matrix_Y+1
	ADC MY_AINC+1
	STA Matrix_Y+1
	CLC
	LDA H_Scroll
	ADC H_AINC
	STA H_Scroll
	LDA H_Scroll+1
	ADC H_AINC+1
	STA H_Scroll+1
	CLC
	LDA V_Scroll
	ADC V_AINC
	STA V_Scroll
	LDA V_Scroll+1
	ADC V_AINC+1
	STA V_Scroll+1
	RTS