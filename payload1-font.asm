;PETSCII Robots font Loader (X16 version)
;by David Murray 2021
;dfwgreencars@gmail.com

!to "PAYLOAD1.PRG",cbm

;This program is designed to be loaded into address $5D00
;then it is executed at $5D00 and copies the needed data
;to video-RAM.  After that, this area can be overwritten.

*=$5D00		;START ADDRESS IS $5D00
VERA_L		=$9F20	;VERA setup VRAM access low-byte
VERA_M		=$9F21	;VERA setup VRAM access middle-byte
VERA_H		=$9F22	;VERA setup VRAM increment+high-byte
VERA_DATA	=$9F23	;Write data to VRAM

;*** Zero Page locations used ***
SOURCE_L	=$02	;for reading from a data source inderectly
SOURCE_H	=$03	;for reading from a data source inderectly

COPY_TO_VRAM:
;NOW COPY TO VRAM ADDRESS $F800 IN BANK 0
	LDA	#$F8
	STA	VERA_M
	LDA	#$00
	STA	VERA_L
	LDA	#%00010000
	STA	VERA_H
	LDA	#<FONT_DATA
	STA	SOURCE_L
	LDA	#>FONT_DATA
	STA	SOURCE_H
	ldx	#$00	
	LDY	#$00
VCOPY1:	LDA	(SOURCE_L),Y
	STA	VERA_DATA
	INY
	CPY	#00
	BNE	VCOPY1
	INC	SOURCE_H
	INX	
	CPX	#08
	BNE	VCOPY1	
	RTS

FONT_DATA:
	!BINARY"gfxfont.bin"
