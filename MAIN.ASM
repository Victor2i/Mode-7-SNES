.define INIDISP          = $2100
.define OBJSEL           = $2101
.define OAM_ADDRESS_LOW  = $2102
.define OAM_ADDRESS_HIGH = $2103
.define OAM_DATA_WORD    = $2104 ; deux écritures
.define BG_MODE          = $2105
.define MOSAIC           = $2106
.define BG1SC            = $2107
.define BG2SC            = $2108
.define BG3SC            = $2109
.define BG4SC            = $210A
.define BG12NBA          = $210B
.define BG34NBA          = $210C
.define BG1HOFS          = $210D
.define BG1VOFS          = $210E
.define BG2HOFS          = $210F
.define BG2VOFS          = $2110
.define BG3HOFS          = $2111
.define BG3VOFS          = $2112
.define BG4HOFS          = $2113
.define BG4VOFS          = $2114
.define VMAINC           = $2115
.define VMADD            = $2116
.define VMADDL           = $2116
.define VMADDH           = $2117
.define VMDATAW          = $2118
.define VMDATALW         = $2118
.define VMDATAHW         = $2119
.define M7SEL            = $211A
.define MULTIPLY_VALUE   = $211B ; deux écritures
.define MULTIPLIER_VALUE = $211C ; deux écritures
.define M7A              = $211B ; deux écritures
.define M7B              = $211C ; deux écritures
.define M7C              = $211D ; deux écritures
.define M7D              = $211E ; deux écritures
.define M7X              = $211F ; deux écritures
.define M7Y              = $2120 ; deux écritures
.define CGRAM_ADDRESS    = $2121
.define CGRAM_DATAW      = $2122 ; deux écritures
.define W12SEL           = $2123
.define W34SEL           = $2124
.define WOBJSEL          = $2125
.define WIN1_LEFT_POS    = $2126
.define WIN1_RIGHT_POS   = $2127
.define WIN2_LEFT_POS    = $2128
.define WIN2_RIGHT_POS   = $2129
.define WBGLOG           = $212A
.define WOBJLOG          = $212B
.define TM               = $212C
.define TS               = $212D
.define TMW              = $212E
.define TSW              = $212F
.define CGSWSEL          = $2130
.define CGADSUB          = $2131
.define COLDATA          = $2132
.define INISET           = $2133
.define MULTI_PROD_L     = $2134
.define MULTI_PROD_M     = $2135
.define MULTI_PROD_H     = $2136
.define HV_LATCH         = $2137
.define OAM_READ_DATA    = $2138 ; deux lectures
.define VRAM_READ_DATA_L = $2139
.define VRAM_READ_DATA_H = $213A
.define CGRAM_READ_DATA  = $213B ; deux lectures
.define OPHCT            = $213C
.define OPVCT            = $213D
.define PPU_STATUS_FLAG1 = $213E
.define PPU_STATUS_FLAG2 = $213F
.define APUIO1           = $2140
.define APUIO2           = $2141
.define APUIO3           = $2142
.define APUIO4           = $2143
.define WRAMDATA         = $2180
.define WRAMADDL         = $2181
.define WRAMADDM         = $2182
.define WRAMADDH         = $2183

.define OLDSTYLE_JOYPAD1 = $4016
.define OLDSTYLE_JOYPAD2 = $4017

.define NMITIMEN         = $4200
.define WRIO             = $4201
.define WRMPYA           = $4202
.define WRMPYB           = $4203
.define WRDIVL           = $4204
.define WRDIVH           = $4205
.define WRDIVB           = $4206
.define HTIMEL           = $4207
.define HTIMEH           = $4208
.define VTIMEL           = $4209
.define VTIMEH           = $420A
.define DMA_ENABLE       = $420B
.define HDMA_ENABLE      = $420C
.define MEMSEL           = $420D
.define RDNMI            = $4210
.define TIMEUP           = $4211
.define HVBJOY           = $4212
.define RDIO             = $4213
.define RDDIVL           = $4214
.define RDDIVH           = $4215
.define RDMPYL           = $4216
.define RDMPYH           = $4217
.define STDCNTRL1L       = $4218
.define STDCNTRL1H       = $4219
.define STDCNTRL2L       = $421A
.define STDCNTRL2H       = $421B
.define STDCNTRL3L       = $421C
.define STDCNTRL3H       = $421D
.define STDCNTRL4L       = $421E
.define STDCNTRL4H       = $421F

.define DMA_SETTINGS     = $4300
.define DMA_BADD         = $4301
.define DMA_AADDL        = $4302
.define DMA_AADDM        = $4303
.define DMA_AADDH        = $4304
.define DMA_SIZEL        = $4305
.define DMA_SIZEH        = $4306

	.MEMORYMAP
	SLOTSIZE $8000
	DEFAULTSLOT 0
	SLOT 0 $8000
	.ENDME
	
	.ROMBANKSIZE $8000
	.ROMBANKS 1

	.bank 0

	.include "HEADER.TXT"
	.include "PRG/HANDLER.ASM" ; Exception handler
	.include "PRG/INIT.ASM"
	.include "PRG/ENTRYPOINT.ASM"
	.include "PRG/MENU.ASM"
	.include "PRG/MENUDATA/MENUINDEXES.ASM"
	.include "PRG/MENUDATA/MENUMSGS.ASM"
	.include "PRG/CONTROLLERS.ASM"

Graphics_data:
	.incbin "CHR/GRAPHICS.CHR"
Menu_Graphics_data:
	.incbin "CHR/MENUGFX.CHR"
Color_data:
	.incbin "CHR/COLORS.PAL"
