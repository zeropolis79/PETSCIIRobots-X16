;PETSCII Robots bitmap graphics loader (X16 version)
;by David Murray 2021
;dfwgreencars@gmail.com

!to "PAYLOAD5.PRG",cbm

*=$5D00		;START ADDRESS IS $5D00

VERA_L		=$9F20	;VERA setup VRAM access low-byte
VERA_M		=$9F21	;VERA setup VRAM access middle-byte
VERA_H		=$9F22	;VERA setup VRAM increment+high-byte
VERA_DATA	=$9F23	;Write data to VRAM
SOURCE_L	=$02	;for reading from a data source inderectly
SOURCE_H	=$03	;for reading from a data source inderectly

COLOR		=$2D	;Color data read from data stream
REPEAT		=$2E	;number of repeats to use
STEP		=$2F	;step 0=first byte, step 1= second byte
OUTPUT		=$30	;data that will be sent to VERA
EOF		=$31	;1=end of file
SOURCE_BYTE	=$32

	LDA	#$0
	STA	VERA_L
	LDA	#$00		;set vram address to $1:0000
	STA	VERA_M
	LDA	#%00010001	;set increment to 1
	STA	VERA_H
	LDA	#<RLE_DATA
	STA	SOURCE_L
	LDA	#>RLE_DATA
	STA	SOURCE_H
	LDY	#0
	STY	STEP
	STY	EOF

;This is the main loop of the decompression routine.
DECOMPRESS:
	JSR	GET_NEXT_SOURCE_BYTE
	;Now split up byte into 4 bits for repeat, 4 bits color
	LDA	SOURCE_BYTE
	AND	#%11110000
	LSR
	LSR
	LSR
	LSR
	STA	REPEAT
	LDA	SOURCE_BYTE
	AND	#%00001111
	STA	COLOR
	;now examine repeat number
	LDA	REPEAT
	CMP	#15	;15 means load in another byte for repeat data
	BNE	REPEAT_LOOP
	JSR	GET_NEXT_SOURCE_BYTE
	LDA	SOURCE_BYTE
	CLC
	ADC	REPEAT
	STA	REPEAT

;At this point we have COLOR and REPEAT properly defined.
REPEAT_LOOP:
	JSR	PUSH_COLOR_TO_VERA
	LDA	VERA_M
	LDA	REPEAT
	CMP	#0
	BEQ	RL2
	DEC	REPEAT
	JMP	REPEAT_LOOP
RL2:	LDA	EOF
	CMP	#1
	BEQ	FINISHED
	JMP	DECOMPRESS
FINISHED:	;RETURN TO BASIC
	RTS

;This routine is in charge of pushing the next pixel to the vera.  Since
;we are using 4 BPP, we can't push anything to the vera until we have
;at least 2 pixels rendered.
PUSH_COLOR_TO_VERA:
	LDA	COLOR
	LDX	STEP
	CPX	#1
	BEQ	STEP2
STEP1:	ASL
	ASL
	ASL
	ASL	
	STA	OUTPUT
	INC	STEP
	RTS
STEP2:	ORA	OUTPUT
	STA	VERA_DATA
	LDA	#0
	STA	STEP
	RTS

;This routine simply reads in the next byte in the RLE data stream
;and then increments the source location by 1.
GET_NEXT_SOURCE_BYTE:
	LDA	(SOURCE_L),Y
	STA	SOURCE_BYTE
	INY
	CPY	#0
	BNE	GNS5
	INC	SOURCE_H
GNS5:	;now check if we are at EOF
	LDA	SOURCE_H
	CMP	#>EOF_LOCATION
	BNE	GNS6
	CPY	#<EOF_LOCATION
	BNE	GNS6
	LDA	#1
	STA	EOF
GNS6:	RTS
	
RLE_DATA:
!BINARY "gamepic.rle"	;CONTAINS RLE ENCODED GRAPHICS
EOF_LOCATION:

;The way the RLE encoding works is like this:
;Only a 4-bit (16 color) value is available for the color itslef, which is bits 0-3
;Bit 4-7 contain the number of repeats for that color (0-15)
;If the repeat is 15, then the second byte after will also contain a number from 0 to 255 which is added to the ;repeat count.
	