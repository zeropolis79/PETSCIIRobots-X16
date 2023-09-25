;PETSCII Robots (X16 version)
;by David Murray 2020
;dfwgreencars@gmail.com

!to "X16ROBOTS.PRG",cbm
!cpu 65c02

*=$0801		;START ADDRESS IS $0801
DESTRUCT_PATH	=$8000	;Destruct path array (256 bytes)
TILE_ATTRIB	=$8100	;Tile attrib array (256 bytes)
TILE_DATA_TL	=$8200	;Tile character top-left (256 bytes)
TILE_DATA_TM	=$8300	;Tile character top-middle (256 bytes)
TILE_DATA_TR	=$8400	;Tile character top-right (256 bytes)
TILE_DATA_ML	=$8500	;Tile character middle-left (256 bytes)
TILE_DATA_MM	=$8600	;Tile character middle-middle (256 bytes)
TILE_DATA_MR	=$8700	;Tile character middle-right (256 bytes)
TILE_DATA_BL	=$8800	;Tile character bottom-left (256 bytes)
TILE_DATA_BM	=$8900	;Tile character bottom-middle (256 bytes)
TILE_DATA_BR	=$8A00	;Tile character bottom-right (256 bytes)
TILE_COLOR_TL	=$8B00	;Tile character top-left (256 bytes) (C64/VIC/TED VERSION ONLY)
TILE_COLOR_TM	=$8C00	;Tile character top-middle (256 bytes) (C64/VIC/TED VERSION ONLY)
TILE_COLOR_TR	=$8D00	;Tile character top-right (256 bytes) (C64/VIC/TED VERSION ONLY)
TILE_COLOR_ML	=$8E00	;Tile character middle-left (256 bytes) (C64/VIC/TED VERSION ONLY)
TILE_COLOR_MM	=$8F00	;Tile character middle-middle (256 bytes) (C64/VIC/TED VERSION ONLY)
TILE_COLOR_MR	=$9000	;Tile character middle-right (256 bytes) (C64/VIC/TED VERSION ONLY)
TILE_COLOR_BL	=$9100	;Tile character bottom-left (256 bytes) (C64/VIC/TED VERSION ONLY)
TILE_COLOR_BM	=$9200	;Tile character bottom-middle (256 bytes) (C64/VIC/TED VERSION ONLY)
TILE_COLOR_BR	=$9300	;Tile character bottom-right (256 bytes) (C64/VIC/TED VERSION ONLY)
VERA_L		=$9F20	;VERA setup VRAM access low-byte
VERA_M		=$9F21	;VERA setup VRAM access middle-byte
VERA_H		=$9F22	;VERA setup VRAM increment+high-byte
VERA_DATA	=$9F23	;Write data to VRAM
VERA_IEN  =$9F26  ;VERA IRQ Enable Register
VERA_ISR  =$9F27  ;VERA IRQ Status Register
VERA_LINE =$9F28  ;VERA IRQ Line low byte. (bit8 is MSB of VERA_IEN)

;***These arrays can go anywhere in RAM***
UNIT_TIMER_A	=$0600	;Primary timer for units (64 bytes)
UNIT_TIMER_B	=$0640	;Secondary timer for units (64 bytes)
UNIT_TILE	=$0680	;Current tile assigned to unit (32 bytes)
;UNIT_ALT_MOVE	=$06A0	;For moving around objects (32 bytes)
;UNIT_DEST_X	=$06C0	;Destination X coordinate (32 bytes)
;UNIT_DEST_Y	=$06E0	;Destination X coordinate (32 bytes)
EXP_BUFFER	=$0700	;Explosion Buffer (16 bytes)
MAP_PRECALC	=$0710	;Stores pre-calculated objects for map window (77 bytes)
PLAYER_DIRECTION	=$078E	;0=up 3=down 6=left 9=right 12=DEAD
PLAYER_ANIMATE	=$078F	;0-2 ANMATIONS

;The following addresses are used to store the current
;state of the SNES buttons.
SNES_B		=$075D
SNES_Y		=$075E
SNES_SELECT	=$075F
SNES_START	=$0760
SNES_UP	=$0761
SNES_DOWN	=$0762
SNES_LEFT	=$0763
SNES_RIGHT	=$0764
SNES_A		=$0765
SNES_X		=$0766
SNES_BACK_L	=$0767
SNES_BACK_R	=$0768
;The following addresses are used to store the last
;state of the SNES buttons so that we can determine
;if a button was released.
LAST_B		=$0769
LAST_Y		=$076A
LAST_SELECT	=$076B
LAST_START	=$076C
LAST_UP		=$076D
LAST_DOWN	=$076E
LAST_LEFT	=$076F
LAST_RIGHT	=$0770
LAST_A		=$0771
LAST_X		=$0772
LAST_BACK_L	=$0773
LAST_BACK_R	=$0774

;The following addresses are used to store new
;presses of the SNES buttons.  Once they are set
;as a 1, it requires the game to reset them to
;0 when it is ready to be read again.
NEW_B		=$0775
NEW_Y		=$0776
NEW_SELECT	=$0777
NEW_START	=$0778
NEW_UP		=$0779
NEW_DOWN	=$077A
NEW_LEFT	=$077B
NEW_RIGHT	=$077C
NEW_A		=$077D
NEW_X		=$077E
NEW_BACK_L	=$077F
NEW_BACK_R	=$0780

;The following are the locations where the current
;key controls are stored.  These must be set before
;the game can start.
KEY_MOVE_UP		=$0781
KEY_MOVE_DOWN		=$0782
KEY_MOVE_LEFT		=$0783
KEY_MOVE_RIGHT		=$0784
KEY_FIRE_UP		=$0785
KEY_FIRE_DOWN		=$0786
KEY_FIRE_LEFT		=$0787
KEY_FIRE_RIGHT		=$0788
KEY_CYCLE_WEAPONS	=$0789
KEY_CYCLE_ITEMS		=$078A
KEY_USE			=$078B
KEY_SEARCH		=$078C
KEY_MOVE		=$078D


;***MAP FILES CONSIST OF EVERYTHING FROM THIS POINT ON***
UNIT_TYPE	=$5D00	;Unit type 0=none (64 bytes)
UNIT_LOC_X	=$5D40	;Unit X location (64 bytes)
UNIT_LOC_Y	=$5D80	;Unit X location (64 bytes)
UNIT_A		=$5DC0
UNIT_B		=$5E00
UNIT_C		=$5E40
UNIT_D		=$5E80
UNIT_HEALTH	=$5EC0	;Unit health (0 to 11) (64 bytes)
MAP		=$6000	;Location of MAP (8K)
;***END OF MAP FILE***

;*** Zero Page locations used ***
TILE		=$23	;The tile number to be plotted
TEMP_X		=$24	;Temporarily used for loops
TEMP_Y		=$25	;Temporarily used for loops
MAP_X		=$26	;Current X location on map
MAP_Y		=$27	;Current Y location on map
MAP_WINDOW_X	=$28	;Top left location of what is displayed in map window
MAP_WINDOW_Y	=$29	;Top left location of what is displayed in map window
DECNUM		=$2A	;a decimal number to be displayed onscreen as 3 digits.
ATTRIB		=$2B	;Tile attribute value
UNIT		=$2C	;Current unit being processed
TEMP_A		=$2D	;used within some routines
TEMP_B		=$2E	;used within some routines
TEMP_C		=$2F	;used within some routines
TEMP_D		=$30	;used within some routines
CURSOR_X	=$31	;For on-screen cursor
CURSOR_Y	=$32	;For on-screen cursor
CURSOR_ON	=$33	;Is cursor active or not? 1=yes 0=no
REDRAW_WINDOW	=$34	;1=yes 0=no
MOVE_RESULT	=$35	;1=Move request success, 0=fail.
UNIT_FIND	=$36	;255=no unit present.
MOVE_TYPE	=$37	;%00000001=WALK %00000010=HOVER
SCREEN_SHAKE 	=$38	;0=NO 1=YES
PRECALC_COUNT	=$39	;part of screen draw routine
CUR_PATTERN_L	=$3A	;stores the memory location of the current
CUR_PATTERN_H	=$3B	;musical pattern being played.
SOURCE_L	=$02	;for reading from a data source inderectly
SOURCE_H	=$03	;for reading from a data source inderectly

!SOURCE "zsound.inc" ; Zsound API addresses
!SOURCE "sounds.inc" ; names for the audio assets' indexes in the pointer table
										 ;    that is included from sounds.asm which is included
										 ;    below where the other data tables reside.


BASIC:	!BYTE $0B,$08,$01,$00,$9E,$32,$30,$36,$31,$00,$00,$00
	;Adds BASIC line:  1 SYS 2061
	JSR	DISPLAY_WARNING
	LDA	#0
	STA	SCREEN_SHAKE
	;**** load payload files ****
	JSR	LOAD_PAYLOAD	;load charset first. Gets overwritten after copy to VRAM
	LDA	#49
	JSR	$FFD2		;add "1" to loading message
	LDA	#50
	STA	FILENAME_PAYLOAD+7
	JSR	LOAD_PAYLOAD	;load sprites, gets overwritten after copy to VRAM
	LDA	#50
	JSR	$FFD2		;add "2" to loading message
	LDA	#51
	STA	FILENAME_PAYLOAD+7
	JSR	LOAD_PAYLOAD	;load sprites, gets overwritten after copy to VRAM
	LDA	#51
	JSR	$FFD2		;add "3" to loading message
	LDA	#52
	STA	FILENAME_PAYLOAD+7
	JSR	LOAD_PAYLOAD	;load intro graphics, gets overwritten after copy to VRAM
	LDA	#52
	JSR	$FFD2		;add "4" to loading message
	LDA	#53
	STA	FILENAME_PAYLOAD+7
	JSR	LOAD_PAYLOAD	;load gamescreen graphics, gets overwritten after copy to VRAM
	LDA	#53
	JSR	$FFD2		;add "5" to loading message
	LDA #13
	; call sound loader. It starts a new "LOADING SOUNDS" message and handles
	; the numbers itself, so omitting the "6" from loading message
	JSR $FFD2 ; carriage return
	LDA #54
	STA FILENAME_PAYLOAD+7
	JSR LOAD_PAYLOAD
	LDA #0
	ROL ; retreive Carry flag as DYNAMIC MODE (0=no, 1=yes)
	STA MUSIC_DYNAMIC_MODE ; store the state returned by loader.
	LDA #SONG_MAIN				 ; MUSIC.BIN contains the MAIN screen song.
	STA MUSIC_DYNAMIC_SONG ; use that to initialize the dynamic loader state.
	JSR	INIT_SPRITES
	JSR	TILE_LOAD_ROUTINE
	JSR	SETUP_INTERRUPT
	JSR	SET_CONTROLS	;copy initial key controls
	JSR	SETUP_VERA	;change to 40 columns, erase bottom extra screen area
	JSR ZSM_INIT
	JSR PCM_INIT
	LDX #<MUSIC_LOOP_CALLBACK
	LDY #>MUSIC_LOOP_CALLBACK
	JSR ZSM_SETCALLBACK	; enable the callback that clears MUSIC_PLAYING
	LDA #1
	STA MUSIC_ENABLED
	JMP	INTRO_SCREEN

DISABLE_SPRITES:
	LDA	#%0010001
	STA	VERA_H
	LDA	#$FC
	STA	VERA_M
	LDA	#14	;sprite 1 z-depth
	STA	VERA_L
	LDA	#%00000000	;DISABLE sprite
	STA	VERA_DATA
	LDA	#6	;sprite 0 z-depth
	STA	VERA_L
	LDA	#%00000000	;DISABLE sprite
	STA	VERA_DATA
	LDA	#22	;sprite 2 z-depth
	STA	VERA_L
	LDA	#%00000000	;DISABLE sprite
	STA	VERA_DATA
	LDA	#30	;sprite 3 z-depth
	STA	VERA_L
	LDA	#%00000000	;DISABLE sprite
	STA	VERA_DATA
	RTS

INIT_SPRITES:
	LDA	#%00010001
	STA	VERA_H
	LDA	#$FC
	STA	VERA_M
	LDA	#00
	STA	VERA_L
	LDX	#0
INTSP1:	LDA	SPRITE_ATTRIB,X
	STA	VERA_DATA
	INX
	CPX	#32
	BNE	INTSP1
	LDA	$9F29		;DCVIDEO REGISTER
	ORA	#%01000000	;enable sprites
	STA	$9F29
	RTS
SPRITE_ATTRIB:
	;SPRITE 0
	!BYTE	%00000000	;ADDRESS 12:5
	!BYTE	%00000111	;MODE (BIT 7) ADRESS 16:13 (BITS 3:0)
	!BYTE	07		;X 7:0
	!BYTE	%00000001	;X 9:8
	!BYTE	24		;Y 7:0
	!BYTE	%00000000	;Y 9:8
	!BYTE	%00000000	;COLLISION MASK, Z-DEPTH, V-FLIP,H-FLIP
	!BYTE	%10110000	;HEIGHT, WIDTH, PALETTE OFFSET (BITS 3:0)
	;SPRITE 1
	!BYTE	%01100000	;ADDRESS 12:5
	!BYTE	%00000111	;MODE (BIT 7) ADRESS 16:13 (BITS 3:0)
	!BYTE	07		;X 7:0
	!BYTE	%00000001	;X 9:8
	!BYTE	114		;Y 7:0
	!BYTE	%00000000	;Y 9:8
	!BYTE	%00000000	;COLLISION MASK, Z-DEPTH, V-FLIP,H-FLIP
	!BYTE	%10110000	;HEIGHT, WIDTH, PALETTE OFFSET (BITS 3:0)
	;SPRITE 2	(cursors)
	!BYTE	%00000000	;ADDRESS 12:5
	!BYTE	%00000110	;MODE (BIT 7) ADRESS 16:13 (BITS 3:0)
	!BYTE	122		;X 7:0
	!BYTE	%00000000	;X 9:8
	!BYTE	89		;Y 7:0
	!BYTE	%00000000	;Y 9:8
	!BYTE	%00000000	;COLLISION MASK, Z-DEPTH, V-FLIP,H-FLIP
	!BYTE	%10100001	;HEIGHT, WIDTH, PALETTE OFFSET (BITS 3:0)
	;SPRITE 3	(player sprite)
	!BYTE	%00110000	;ADDRESS 12:5
	!BYTE	%00000110	;MODE (BIT 7) ADRESS 16:13 (BITS 3:0)
	!BYTE	122		;X 7:0
	!BYTE	%00000000	;X 9:8
	!BYTE	89		;Y 7:0
	!BYTE	%00000000	;Y 9:8
	!BYTE	%00000000	;COLLISION MASK, Z-DEPTH, V-FLIP,H-FLIP
	!BYTE	%10100001	;HEIGHT, WIDTH, PALETTE OFFSET (BITS 3:0)


;This routine is dual purpose.  It's designed to attempt to detect
;what video output mode the user is already running in by looking at $9f29.
;And then it configures the screen as needed for that mode.  Also the mode
;is also set again in the sub-routines, because these can be called from
;the main menu to change modes as well.

SETUP_VERA:
	JSR	CLEAR_TEXT_SCREEN
	;First, figure out which video output mode
	;the user is using composite/vga/rgb
	LDA	$9F29
	AND	#%00000011
	CMP	#01
	BNE	SETVA
	JSR	MODE_VGA
	JMP	SETV1
SETVA: CMP	#02
	BNE	SETVB
	JSR	MODE_COMPOSITE
	JMP	SETV1
SETVB:	JSR	MODE_RGB
	;now setup the graphics modes.
SETV1:	LDA	#$A0
	STA	$9F34	;set layer 1 (text mode)
	LDA	#0
	STA	$9F35	;set text mode vram base address to $0000
	LDA	#$7C
	STA	$9F36	;SET character bitmap vram location to $F800
	;NOW COPY MODIFIED PALETTE
	LDA	#%00010001
	STA	VERA_H
	LDA	#$FA
	STA	VERA_M
	LDA	#00
	STA	VERA_L
	LDY	#0
SETV2:	LDX	#0
SETV3:	LDA	PALETTE,X
	STA	VERA_DATA
	INX
	CPX	#32
	BNE	SETV3
	INY
	CPY	#2
	BNE	SETV2
	LDA	#$28
	STA	VERA_L
	LDA	#00
	STA	VERA_DATA
	STA	VERA_DATA
	RTS

;This is needed to clear beyond the 40x30 boundary so that when in
;composite mode, there are no junk characters at the border:

CLEAR_TEXT_SCREEN:
	LDA	#%00010000
	STA	VERA_H
	LDA	#0
	STA	VERA_M
	LDA	#0
	STA	VERA_L
	LDX	#0
	LDY	#0
	LDA	#0
CTL1:	STA	VERA_DATA
	INX
	CPX	#0
	BNE	CTL1
	INY
	CPY	#$20
	BNE	CTL1
	RTS

MODE_RGB:
	LDA	$9F29
	AND	#%11111100
	ORA	#%00000011	;set RGB mode
	STA	$9F29
	JMP	MDCP	;everything else is the same with composite mode.
	RTS

MODE_COMPOSITE:
	LDA	$9F29
	AND	#%11111100
	ORA	#%00000010	;set composite mode
	STA	$9F29
MDCP:	LDA	#74
	STA	$9F2A	;VERA H-SCALE
	LDA	#69
	STA	$9F2B	;VERA V-SCALE
	SEI
	LDA	#%00000010
	STA	$9F25	;enable DC select
	LDA	#9
	STA	$9F29	;H-START
	LDA	#169	
	STA	$9F2A	;H-STOP
	LDA	#7	
	STA	$9F2B	;V-START
	LDA	#240	
	STA	$9F2C	;V-STOP	
	LDA	#%00000000
	STA	$9F25	;disable DC select
	CLI
	RTS

MODE_VGA:
	LDA	$9F29
	AND	#%11111100
	ORA	#%00000001	;set VGA mode
	STA	$9F29
	LDA	#64
	STA	$9F2A	;VERA H-SCALE
	STA	$9F2B	;VERA V-SCALE
	SEI
	LDA	#%00000010
	STA	$9F25	;enable DC select
	LDA	#0
	STA	$9F29	;H-START
	LDA	#160	
	STA	$9F2A	;H-STOP
	LDA	#0	
	STA	$9F2B	;V-START
	LDA	#240	
	STA	$9F2C	;V-STOP	
	LDA	#%00000000
	STA	$9F25	;disable DC select
	CLI
	RTS

PALETTE:
	!BYTE	0	;COLOR 0 (7:4 GREEN) (3:0) BLUE
	!BYTE	0	;COLOR 0 (RED)
	!BYTE	255	;COLOR 1 (7:4 GREEN) (3:0) BLUE
	!BYTE	15	;COLOR 1 (RED)
	!BYTE	34	;COLOR 2 (7:4 GREEN) (3:0) BLUE
	!BYTE	15	;COLOR 2 (RED)
	!BYTE	190	;COLOR 3 (7:4 GREEN) (3:0) BLUE
	!BYTE	0	;COLOR 3 (RED)
	!BYTE	15	;COLOR 4 (7:4 GREEN) (3:0) BLUE
	!BYTE	15	;COLOR 4 (RED)
	!BYTE	160	;COLOR 5 (7:4 GREEN) (3:0) BLUE
	!BYTE	0	;COLOR 5 (RED)
	!BYTE	44	;COLOR 6 (7:4 GREEN) (3:0) BLUE
	!BYTE	2	;COLOR 6 (RED)
	!BYTE	244	;COLOR 7 (7:4 GREEN) (3:0) BLUE
	!BYTE	15	;COLOR 7 (RED)
	!BYTE	128	;COLOR 8 (7:4 GREEN) (3:0) BLUE
	!BYTE	15	;COLOR 8 (RED)
	!BYTE	96	;COLOR 9 (7:4 GREEN) (3:0) BLUE
	!BYTE	6	;COLOR 9 (RED)
	!BYTE	102	;COLOR 10 (7:4 GREEN) (3:0) BLUE
	!BYTE	215	;COLOR 10 (RED)
	!BYTE	85	;COLOR 11 (7:4 GREEN) (3:0) BLUE
	!BYTE	5	;COLOR 11 (RED)
	!BYTE	136	;COLOR 12 (7:4 GREEN) (3:0) BLUE
	!BYTE	8	;COLOR 12 (RED)
	!BYTE	248	;COLOR 13 (7:4 GREEN) (3:0) BLUE
	!BYTE	8	;COLOR 13 (RED)
	!BYTE	143	;COLOR 14 (7:4 GREEN) (3:0) BLUE
	!BYTE	8	;COLOR 14 (RED)
	!BYTE	204	;COLOR 15 (7:4 GREEN) (3:0) BLUE
	!BYTE	12	;COLOR 15 (RED)

INIT_GAME:
	JSR	RESET_KEYS_AMMO
	JSR	DISPLAY_GAME_SCREEN
	JSR	MAP_LOAD_ROUTINE
	JSR	SET_DIFF_LEVEL
	JSR	ANIMATE_PLAYER
	JSR	CACULATE_AND_REDRAW
	JSR	DRAW_MAP_WINDOW
	LDA	#03
	STA	PLAYER_DIRECTION
	LDA	#00
	STA	PLAYER_ANIMATE
	JSR	DISPLAY_PLAYER_SPRITE
	JSR	DISPLAY_PLAYER_HEALTH
	JSR	DISPLAY_KEYS
	JSR	DISPLAY_WEAPON
	LDA	#1
	STA	UNIT_TYPE
	JSR	SET_INITIAL_TIMERS
	JSR	PRINT_INTRO_MESSAGE
	LDA	#30
	STA	KEYTIMER
	LDA #0
	STA MUSIC_SPEED
	JSR START_IN_GAME_MUSIC
	JMP	MAIN_GAME_LOOP

TILENAME  		!PET"tileset.gfx"
MAPNAME  		!PET"level-a"
SNDNAME  		!PET"pdrv-c64"
FILENAME_PAYLOAD	!PET"payload1.prg"
KEYS			!BYTE 	00	;bit0=spade bit2=heart bit3=star
AMMO_PISTOL		!BYTE	00	;how much ammo for the pistol
AMMO_PLASMA		!BYTE	00	;how many shots of the plasmagun
INV_BOMBS		!BYTE	00	;How many bombs do we have
INV_EMP			!BYTE	00	;How many EMPs do we have
INV_MEDKIT		!BYTE	00	;How many medkits do we have?
INV_MAGNET		!BYTE	00	;How many magnets do we have?
SELECTED_WEAPON		!BYTE	00	;0=none 1=pistol 2=plasmagun
SELECTED_ITEM		!BYTE	00	;0=none 1=bomb 2=emp 3=medkit
ANIMATE			!BYTE 	01	;0=DISABLED 1=ENABLED
BIG_EXP_ACT		!BYTE	00	;0=No explosion active 1=big explosion active
MAGNET_ACT		!BYTE	00	;0=no magnet active 1=magnet active
PLASMA_ACT		!BYTE	00	;0=No plasma fire active 1=plasma fire active
RANDOM			!BYTE	00	;used for random number generation
CONTROL			!BYTE	00	;0=keyboard 1=custom keys 2=snes
INTRO_MESSAGE		!SCR"welcome to x16-robots!",255
			!SCR"by david murray 2021",0
MSG_PETMODEON		!SCR"pet mode enabled",0
MSG_PETMODEOFF		!SCR"pet mode disabled",0
MSG_PETGREEN		!SCR"pet color=green",0
MSG_PETWHITE		!SCR"pet color=white",0
MSG_PETAMBER		!SCR"pet color=amber",0
MSG_CANTMOVE		!SCR"can't move that!",0
MSG_BLOCKED		!SCR"blocked!",0
MSG_SEARCHING		!SCR"searching",0
MSG_NOTFOUND		!SCR"nothing found here.",0
MSG_FOUNDKEY		!SCR"you found a key card!",0
MSG_FOUNDGUN		!SCR"you found a pistol!",0
MSG_FOUNDEMP		!SCR"you found an emp device!",0
MSG_FOUNDBOMB		!SCR"you found a timebomb!",0
MSG_FOUNDPLAS		!SCR"you found a plasma gun!",0
MSG_FOUNDMED		!SCR"you found a medkit!",0
MSG_FOUNDMAG		!SCR"you found a magnet!",0
MSG_MUCHBET		!SCR"ahhh, much better!",0
MSG_EMPUSED		!SCR"emp activated!",255
			!SCR"nearby robots are rebooting.",0
MSG_TERMINATED		!SCR"you're terminated!",0
MSG_TRANS1		!SCR"transporter will not activate",255
			!SCR"until all robots destroyed.",0
SELECTED_MAP		!BYTE	00
MAP_NAMES	!SCR"01-research lab "
		!SCR"02-headquarters "
		!SCR"03-the village  "
		!SCR"04-the islands  "
		!SCR"05-downtown     "
		!SCR"06-pi university"
		!SCR"07-more islands "
		!SCR"08-robot hotel  "
		!SCR"09-forest moon  "
		!SCR"10-death tower  "
		!SCR"11-bunker       "
		!SCR"12-castle robot "
		!SCR"13-rocket center"
		!SCR"14-pilands      "
MSG_ELEVATOR		!SCR"[ elevator panel ]  down",255
			!SCR"[  select level  ]  opens",0
MSG_LEVELS		!SCR"[                ]  door",0
MSG_PAUSED		!SCR"game paused.",255
			!SCR"exit game (y/n)",0
MSG_MUSICON		!SCR"music on.",0
MSG_MUSICOFF		!SCR"music off.",0
MSG_VOLUME !SCR"new fx volume:  0x",0 ; x replaced by routine

;***THE FOLLOWING ARE USED BY THE SOUND SYSTEM***
TEMPO_TIMER	!BYTE	00	;used for counting down to the next tick
TEMPO		!BYTE	07	;How many IRQs between ticks
DATA_LINE	!BYTE	00	;used for playback to keep track of which line we are executing.
ARP_MODE	!BYTE	00	;0=no 1=major 2=minor 3=sus4
CHORD_ROOT	!BYTE	00	;root note of the chord
MUSIC_ENABLED	!BYTE	01	;0=off 1=on
MUSIC_PLAYING !BYTE 00  ;0=off else on
MUSIC_DYNAMIC_MODE !BYTE 00 ;0=off 1=on
MUSIC_DYNAMIC_SONG !byte SONG_MAIN ; ID of Currently-loaded song
MUSIC_SPEED !BYTE 00 ; 0=normal, 1, 2 = low health speeds
SFX_VOLUME !byte $0A ; valid values 0-F
SOUND_EFFECT	!BYTE	$FF	;FF=OFF or number of effect in progress

;This warning message is being used to inform anyone
;playing this, that it is a pre-release copy.
DISPLAY_WARNING:
	LDY	#0
DLW1:	LDA	WARNMSG,Y
	CMP	#0
	BEQ	DLW2
	JSR	$FFD2
	INY
	JMP	DLW1
	RTS
DLW2:	;JSR	$FFE4
	;CMP	#0
	;BEQ	DLW2
	;LOADING MESSAGE
	LDY	#0
DLW3:	LDA	LOADMSG,Y
	BEQ DLW4
	JSR	$FFD2
	INY
	BRA	DLW3
DLW4:
	RTS
WARNMSG:	!BYTE 13,13
		!PET"warning: this is a pre-release version!",13
		!PET"for the commander x16.",13
		!PET"check with the 8-bit guy for updates.",13
		!PET"dfwgreencars@gmail.com",13,13
		!PET"version 09-19-2022",13,13,0
;		!PET"press any key to continue.",13,13,0
LOADMSG:	!PET"loading graphics ",0

SETUP_INTERRUPT:
	SEI			; Disable interrupt routine
	LDA	$0314		; get old address
	STA	IRQ32+1
	LDA	$0315		; get old address
	STA	IRQ32+2
	LDA	#<RUNIRQ	; Setup IRQ to visit my routine RUNIRQ before
	STA	$0314		; doing the usual IRQ routine.
	LDA	#>RUNIRQ
	STA	$0315
	LDA #$FF   ; SET VERA LineIRQ to trigger on line 255.
	STA VERA_LINE
	LDA #3  ; Enable VBLANK and LINE IRQs on VERA
	STA VERA_IEN
	CLI			; Reenable routine.
	RTS

;This is the routine that runs the Zsound per-frame sound advance routines
;The music player would be fine to run at more or less any time once per frame
;but PCM playback is less likely to get buffer underflow when run at a consistent
;interval between updates, which is why the line IRQ is here.

RUNLINEIRQ:	;Zsound IRQ (triggered by LINE IRQs)
	STA VERA_ISR ; Acknowledge the line IRQ (.A holds $02 from initial check)
	JSR PCM_PLAY
  JSR ZSM_PLAYIRQ
	PLY ; Directly exit the IRQ, since the Kernal IRQ handler should only run
	PLX ; once per frame. It usually restores the registers, so we need
	PLA ; to do so here in order to maintain the stack and registers properly.
	RTI

;This is the routine that runs 60 times per second from the IRQ.
;BGTIMER1 is always set to 1 every cycle, after which the main
;program will reset it to 0 when it is done with it's work for
;that cycle.  BGTIMER2 is a count-down to zero and then stays
;there.
RUNIRQ:
	LDA #$02  ; Check for Line IRQ, and if so, handle it.
	AND VERA_ISR
	BNE RUNLINEIRQ
	JSR	UPDATE_GAME_CLOCK
	JSR	ANIMATE_WATER
	LDA	#1
	STA	BGTIMER1
	LDA	BGTIMER2
	CMP	#0
	BEQ	IRQ1
	DEC	BGTIMER2
IRQ1:	LDA	KEYTIMER
	CMP	#0
	BEQ	IRQ2
	DEC	KEYTIMER
IRQ2:	;BORDER FLASHER
	LDX	BORDER
	CPX	#0
	BEQ	IRQ3
	LDA	BORDER,X
	LDX	#%00000001
	STX	VERA_H
	LDX	#$FA
	STX	VERA_M
	LDX	#$01
	STX	VERA_L
	STA	VERA_DATA
	DEC	BORDER
	;BACKGROUND FLASHER
IRQ3:	LDX	BGFLASH
	CPX	#0
	BEQ	IRQ10
	LDA	BGFLASH,X
	LDX	#%00000001
	STX	VERA_H
	LDX	#$FA
	STX	VERA_M
	LDX	#$00
	STX	VERA_L
	STA	VERA_DATA
	DEC	BGFLASH
IRQ10:	;SCREEN_SHAKER
	LDA	SCREEN_SHAKE
	CMP	#$00
	BEQ	SHAKE4
SHAKE2:	INC	SSCOUNT
	LDA	SSCOUNT
	CMP	#5
	BNE	SHAKE3
	LDA	#0
	STA	SSCOUNT
SHAKE3:	LDY	SSCOUNT
	AND	#%00000001
	ASL
	ASL
	STA	$9F37
	JMP	IRQ20
SHAKE4:	LDA	#00
	STA	$9F37
	;CHECK TO SEE IF KEYBOARD WAS DISABLED
	;This routine causes the kernal to skip keyboard
	;input for one cycle to help "debounce" the
	;keyboard.
IRQ20:	LDA	$0289	;1=normal 0=disabled
	CMP	#0
	BNE	IRQ30
	LDA	KEYSOFF
	CMP	#00
	BEQ	IRQ21
	LDA	#0
	;STA	KEYSOFF
	LDA	#1
	STA	$0289	;turn keyboard back on
	JMP	IRQ30:
IRQ21:	INC	KEYSOFF
IRQ30:	;Animate Sprite Color (used for menu flashing atm)
	DEC	SPRITECOLTIMER
	LDA	SPRITECOLTIMER
	CMP	#0
	BNE	IRQ32
	LDA	#7
	STA	SPRITECOLTIMER
	INC 	SPRITECOLSTATE
	LDA	SPRITECOLSTATE
	CMP	#8
	BNE	IRQ32
	LDA	#0
IRQ31:	STA	SPRITECOLSTATE
IRQ32:	JMP	$EA31		; Back to usual IRQ routine

BGTIMER1	!BYTE 00
BGTIMER2	!BYTE 00
KEYTIMER	!BYTE 00
KEYSOFF		!BYTE 00
BORDER		!BYTE 00,00,8,15,25,31,31,25,15,08,00
BGFLASH		!BYTE 00,00,8,15,79,159,159,79,15,08,00
SPRITECOLCHART	!BYTE 00,11,12,15,1,15,12,11
SPRITECOLSTATE	!BYTE 00
SPRITECOLTIMER	!BYTE 8
SSHAKE		!BYTE 00,02,04,02,00
SSCOUNT		!BYTE 00
DELAY1		!BYTE 00

;Since the PET OR VIC-20 has no real-time clock, and the Jiffy clock
;is a pain to read from assembly language, I have created my own.
;This could be updated in future to use the 6510's real-time clock
;for C64.
UPDATE_GAME_CLOCK:
	LDA	CLOCK_ACTIVE
	CMP	#1
	BNE	UGC5
	INC	CYCLES
	LDA	CYCLES
	CMP	#60	;60 for ntsc or 50 for pal
	BNE	UGC5
	LDA	#0
	STA	CYCLES
	INC	SECONDS
	LDA	SECONDS
	CMP	#60
	BNE	UGC5
	LDA	#0
	STA	SECONDS
	INC	MINUTES
	LDA	MINUTES
	CMP	#60
	BNE	UGC5
	LDA	#0
	STA	SECONDS
	STA	MINUTES
	INC	HOURS
UGC5:	RTS

HOURS		!BYTE	00
MINUTES		!BYTE	00
SECONDS		!BYTE	00
CYCLES		!BYTE	00
CLOCK_ACTIVE	!BYTE	00

;Sorry, this is sort of a hack-job to get the X16
;built-in SNES routines to work with Petscii Robots.
SNES_CONTROLER_READ:
;First copy last time's results to the LAST variables.
	LDY	#0
SNCL:	LDA	SNES_B,Y
	STA	LAST_B,Y
	INY
	CPY	#12
	BNE	SNCL
	;now read the joystick button status from the kernel.
	LDA	#1		;joystick #1
	JSR	$FF56		;kernal call - JOYSTICK_GET
	EOR	#$FF
	STA	SNES_TEMP_A	;Accumulator returns first 8 bits
	TXA
	EOR	#$FF
	STA	SNES_TEMP_B	;X register returns second 8 bits
	;Now break out the first 8 bits
	LDX	#0
SCR1:	LDA	SNES_TEMP_A
	ROL
	ROL
	AND	#%00000001
	STA	SNES_B,X
	ROL	SNES_TEMP_A
	INX
	CPX	#8
	BNE	SCR1
	;Now break out the next 4 bits
	LDX	#0
SCR2:	LDA	SNES_TEMP_B
	ROL
	ROL
	AND	#%00000001
	STA	SNES_A,X
	ROL	SNES_TEMP_B
	INX
	CPX	#4
	BNE	SCR2
	;now process any new presses
	LDY	#0
SRL09:	LDA	NEW_B,Y
	CMP	#1
	BEQ	SRL10
	LDA	SNES_B,Y
	CMP	#1
	BNE	SRL10
	LDA	LAST_B,Y
	CMP	#0
	BNE	SRL10
	LDA	#1
	STA	NEW_B,Y
SRL10:	INY
	CPY	#12
	BNE	SRL09
	RTS

SNES_TEMP_A		!BYTE 0
SNES_TEMP_B		!BYTE 0

;This routine spaces out the timers so that not everything
;is running out once. It also starts the game_clock.
SET_INITIAL_TIMERS:
	LDA	#1
	STA	CLOCK_ACTIVE
	LDX	#01
SIT1	TXA
	STA	UNIT_TIMER_A,X
	LDA	#0
	STA	UNIT_TIMER_B,X
	INX
	CPX	#48
	BNE	SIT1
	RTS

MAIN_GAME_LOOP:
	JSR	BACKGROUND_TASKS
	LDA	UNIT_TYPE
	CMP	#1	;Is player unit alive
	BEQ	MG00
	JMP	GAME_OVER
MG00:	LDA	CONTROL
	CMP	#2
	BNE	KY01
	JMP	SC01
KY01:	;Keyboard controls here.
	JSR	KEY_REPEAT
	JSR	$FFE4
	CMP	#$00
	BEQ	MAIN_GAME_LOOP
MG01:	CMP	#$1D	;CURSOR RIGHT
	BNE	MG02
MG01A:	LDA	#9
	STA	PLAYER_DIRECTION
	LDA	#0
	STA	UNIT
	LDA	#%00000001
	STA	MOVE_TYPE
	JSR	REQUEST_WALK_RIGHT
	JMP	AFTER_MOVE
MG02:	CMP	#$9D	;CURSOR LEFT
	BNE	MG03
MG02A:	LDA	#6
	STA	PLAYER_DIRECTION
	LDA	#0
	STA	UNIT
	LDA	#%00000001
	STA	MOVE_TYPE
	JSR	REQUEST_WALK_LEFT
	JMP	AFTER_MOVE
MG03:	CMP	#$11	;CURSOR DOWN
	BNE	MG04
MG03A:	LDA	#3
	STA	PLAYER_DIRECTION
	LDA	#0
	STA	UNIT
	LDA	#%00000001
	STA	MOVE_TYPE
	JSR	REQUEST_WALK_DOWN
	JMP	AFTER_MOVE
MG04:	CMP	#$91	;CURSOR UP
	BNE	MG05
MG04A:	LDA	#0
	STA	PLAYER_DIRECTION
	LDA	#0
	STA	UNIT
	LDA	#%00000001
	STA	MOVE_TYPE
	JSR	REQUEST_WALK_UP
	JMP	AFTER_MOVE
MG05:	CMP	KEY_CYCLE_WEAPONS
	BNE	MG06
	JSR	CYCLE_WEAPON
	JSR	CLEAR_KEY_BUFFER
	JMP	MAIN_GAME_LOOP
MG06:	CMP	KEY_CYCLE_ITEMS
	BNE	MG07
	JSR	CYCLE_ITEM
	JSR	CLEAR_KEY_BUFFER
	JMP	MAIN_GAME_LOOP
MG07:	CMP	KEY_MOVE
	BNE	MG08
	JSR	MOVE_OBJECT
	JSR	CLEAR_KEY_BUFFER
	JMP	MAIN_GAME_LOOP
MG08:	CMP	KEY_SEARCH
	BNE	MG09
	JSR	SEARCH_OBJECT
	JSR	CLEAR_KEY_BUFFER
	JMP	MAIN_GAME_LOOP
MG09:	CMP	KEY_USE
	BNE	MG10
	JSR	USE_ITEM
	JSR	CLEAR_KEY_BUFFER
	JMP	MAIN_GAME_LOOP
MG10:	CMP	KEY_MOVE_LEFT
	BNE	MG11
	JMP	MG02A
MG11:	CMP	KEY_MOVE_DOWN
	BNE	MG12
	JMP	MG03A
MG12:	CMP	KEY_MOVE_RIGHT
	BNE	MG13
	JMP	MG01A
MG13:	CMP	KEY_MOVE_UP
	BNE	MG14
	JMP	MG04A
MG14:	CMP	KEY_FIRE_UP
	BNE	MG15
	JSR	FIRE_UP
	LDA	#20
	STA	KEYTIMER
	JMP	MAIN_GAME_LOOP
MG15:	CMP	KEY_FIRE_LEFT
	BNE	MG16
	JSR	FIRE_LEFT
	LDA	#20
	STA	KEYTIMER
	JMP	MAIN_GAME_LOOP
MG16:	CMP	KEY_FIRE_DOWN
	BNE	MG17
	JSR	FIRE_DOWN
	LDA	#20
	STA	KEYTIMER
	JMP	MAIN_GAME_LOOP
MG17:	CMP	KEY_FIRE_RIGHT
	BNE	MG18
	JSR	FIRE_RIGHT
	LDA	#20
	STA	KEYTIMER
	JMP	MAIN_GAME_LOOP
MG18:	CMP	#03	;RUN/STOP
	BNE	MG19
	JMP	PAUSE_GAME
MG19:	CMP	#195	;SHIFT-C	;C= + * (cheat mode)
	BNE	MG20
	JSR	CHEATER
	JMP	MAIN_GAME_LOOP
MG20:	CMP	#205	;SHIFT-M
	BNE	MG21
	JSR	TOGGLE_MUSIC
	JSR	CLEAR_KEY_BUFFER
	JMP	MAIN_GAME_LOOP
MG21:	CMP	#9	;TAB KEY
	BNE	MG22
	JSR	DISPLAY_MAP
	JMP MAIN_GAME_LOOP
MG22:	CMP #186 ; '{'  shift+[
	BNE MG23
	LDA SFX_VOLUME
	PHA
	JSR DECREASE_PCM_VOLUME
	JMP MG24 ; see if volume changed....
MG23: CMP #192 ; '}'  shift+]
	BNE MG26  ; MG24 and MG25 are used in the FX volume message decisions...
	LDA SFX_VOLUME
	PHA
	JSR INCREASE_PCM_VOLUME
MG24: ; check if SFX volume changed and if so, show console message.
	PLA
	CMP SFX_VOLUME
	BEQ MG25
	JSR SHOW_NEW_VOLUME
	LDA #SFX_BEEP2
	JSR PLAY_DIGI_SOUND ; play a "confirmation" sound
	JMP MAIN_GAME_LOOP
MG25: ; new volume key pressed but already at max/min - play error sound.
	LDA #SFX_ERROR
	JSR PLAY_DIGI_SOUND
MG26: JMP MAIN_GAME_LOOP

SHOW_NEW_VOLUME:
	LDA SFX_VOLUME
	CMP #$0A
	BCS NEWV1
	ORA #$30 ; convert value to 0-9 screen code
	BRA NEWV2
NEWV1:
	CLC
	SBC #8 ; convert to screen code A-F
NEWV2:
	STA MSG_VOLUME+17 ; write hex char into volume message string
	LDA #<MSG_VOLUME
	STA $02
	LDA #>MSG_VOLUME
	STA $03
	JMP PRINT_INFO ; go to PRINT_MSG and let it RTS to caller.

SC01:	;SNES CONTROLLER starts here
	JSR	SNES_CONTROLER_READ
	;check keytimer for repeat time.
	LDA	KEYTIMER
	CMP	#0
	BEQ	SC02
	JMP	SC40
SC02:	LDA	#0
	STA	NEW_UP
	STA	NEW_DOWN
	STA	NEW_LEFT
	STA	NEW_RIGHT
	STA	SNES_UP
	STA	SNES_DOWN
	STA	SNES_LEFT
	STA	SNES_RIGHT
	JSR	SNES_CONTROLER_READ
SC05:	;first we start with the 4 directional buttons.
	LDA	NEW_LEFT
	CMP	#01
	BNE	SC10
	LDA	SNES_SELECT	;find out if select is being held down
	CMP	#0
	BEQ	SC06
	LDA	#0
	STA	NEW_LEFT
	JSR	DISPLAY_MAP
	JMP	MAIN_GAME_LOOP
SC06:	LDA	#6
	STA	PLAYER_DIRECTION
	LDA	#0
	STA	UNIT
	LDA	#%00000001
	STA	MOVE_TYPE
	JSR	REQUEST_WALK_LEFT
	JMP	AFTER_MOVE_SNES
SC10:	LDA	NEW_RIGHT
	CMP	#01
	BNE	SC20
	LDA	#9
	STA	PLAYER_DIRECTION
	LDA	#0
	STA	UNIT
	LDA	#%00000001
	STA	MOVE_TYPE
	JSR	REQUEST_WALK_RIGHT
	JMP	AFTER_MOVE_SNES
SC20:	LDA	NEW_UP
	CMP	#01
	BNE	SC30
	LDA	#0
	STA	PLAYER_DIRECTION
	LDA	#0
	STA	UNIT
	LDA	#%00000001
	STA	MOVE_TYPE
	JSR	REQUEST_WALK_UP
	JMP	AFTER_MOVE_SNES
SC30:	LDA	NEW_DOWN
	CMP	#01
	BNE	SC35
	LDA	#3
	STA	PLAYER_DIRECTION
	LDA	#0
	STA	UNIT
	LDA	#%00000001
	STA	MOVE_TYPE
	JSR	REQUEST_WALK_DOWN
	JMP	AFTER_MOVE_SNES
SC35:	LDA	#0
	STA	KEY_FAST
SC40:	;Now check for non-repeating buttons
	LDA	NEW_Y
	CMP	#1
	BNE	SC45
	JSR	FIRE_LEFT
	LDA	#0
	STA	NEW_Y
SC45:	LDA	NEW_A
	CMP	#1
	BNE	SC50
	JSR	FIRE_RIGHT
	LDA	#0
	STA	NEW_A
SC50:	LDA	NEW_X
	CMP	#1
	BNE	SC55
	JSR	FIRE_UP
	LDA	#0
	STA	NEW_X
SC55:	LDA	NEW_B
	CMP	#1
	BNE	SC60
	JSR	FIRE_DOWN
	LDA	#0
	STA	NEW_B
SC60:	LDA	NEW_BACK_L
	CMP	#1
	BNE	SC65
	LDA	SNES_SELECT
	CMP	#1
	BNE	SC62
	JSR	CYCLE_ITEM
	JMP	SC63
SC62:	JSR	SEARCH_OBJECT
SC63:	LDA	#0
	STA	NEW_BACK_L
	LDA	#15
	STA	KEYTIMER
SC65:	LDA	NEW_BACK_R
	CMP	#1
	BNE	SC70
	LDA	SNES_SELECT
	CMP	#1
	BNE	SC67
	JSR	CYCLE_WEAPON
	JMP	SC68
SC67:	JSR	MOVE_OBJECT
SC68:	LDA	#0
	STA	NEW_BACK_R
	LDA	#15
	STA	KEYTIMER
SC70:	LDA	NEW_START
	CMP	#1
	BNE	SC75
	JSR	USE_ITEM
	LDA	#0
	STA	NEW_START
	LDA	#15
	STA	KEYTIMER
SC75:	;STILL USE KEYBOARD TO CHECK FOR RUN/STOP AND PET MODE
	JSR	$FFE4
	CMP	#03	;RUN/STOP
	BNE	SC82
	JMP	PAUSE_GAME
SC82:	JMP	MAIN_GAME_LOOP

;This routine handles things that are in common to
;all 4 directions of movement.
AFTER_MOVE_SNES:
	LDA	MOVE_RESULT
	CMP	#1
	BNE	AMS01
	JSR	ANIMATE_PLAYER
	JSR	CACULATE_AND_REDRAW
AMS01:	LDA	KEY_FAST
	CMP	#0
	BNE	AMS02
	LDA	#15
	STA	KEYTIMER
	LDA	#1
	STA	KEY_FAST
	JMP	AMS03
AMS02:	LDA	#6
	STA	KEYTIMER
	LDA	#0
	STA	NEW_UP
	STA	NEW_DOWN
	STA	NEW_LEFT
	STA	NEW_RIGHT
AMS03:	JMP	MAIN_GAME_LOOP

TOGGLE_MUSIC:
	LDA	MUSIC_ENABLED
	BEQ	TGMUS1
	LDA	#<MSG_MUSICOFF
	STA	$02
	LDA	#>MSG_MUSICOFF
	STA	$03
	JSR	PRINT_INFO
	LDA #0
	STA	MUSIC_ENABLED
	JSR ZSM_STOP
	RTS
TGMUS1:
	LDA	#<MSG_MUSICON
	STA	$02
	LDA	#>MSG_MUSICON
	STA	$03
	JSR	PRINT_INFO
	LDA	#1
	STA	MUSIC_ENABLED
	JMP	START_IN_GAME_MUSIC

START_INTRO_SCREEN_MUSIC:
	LDA #0
	STA MUSIC_SPEED ; ensure music is normal speed
	LDA #SONG_MAIN
	JMP SIGM1

START_IN_GAME_MUSIC:
	LDY	SELECTED_MAP
	LDA	LEVEL_MUSIC,Y       ; choose actual song index from LEVEL_MUSIC table
SIGM1:
	LDY MUSIC_ENABLED       ; check if music is enabled before potentially
	BNE SIGM2               ; loading a dynamic music trac (to not waste time)
	RTS
SIGM2:
	LDY MUSIC_DYNAMIC_MODE
	BEQ START_MUSIC         ; If MUSIC_DYNAMIC_MODE=0, just play the song ID
;	CMP MUSIC_DYNAMIC_SONG  ; If not - check whether it's the one already loaded
;	BEQ SIGM3				        ; If so, then don't bother loading it again
	JSR LOAD_DYNAMIC_SONG
SIGM3:
	LDA #SONG_DYNAMIC ; Use the ID of the dynamic song when starting music
	;JMP START_MUSIC  ; not necessary but here for ease-of-reading

START_MUSIC:
	PHA ; Save the song number
	JSR ZSM_STOP ; just in case a song is already playing.
	JSR CLEAR_YM ; clean up YM after the previous song
	LDA MUSIC_ENABLED ; check whether music is disabled
	BNE STM1
	PLA	 	  		 ; keep the stack tidy
	RTS
STM1:
	PLX						 ; song ID number into X
	LDA ZSM_LO,X	 ; Get the HiRam bank:address for song index.
	PHA						 ; ZSM_LO -> stack -> X
	LDY ZSM_HI,X
	LDA ZSM_BANK,X
	PLX
	JSR ZSM_START  ; Start the music. A=bank, XY=memory location
	LDA #1
	STA MUSIC_PLAYING
	LDA MUSIC_SPEED
STM2:
	TAY
	LDX MUSIC_SPEED_HZ_TABLE,Y
	LDY #0 ; we will not be using any 16-bit values in this game. :)
	JMP ZSM_SETSPEED ; ZSOUND.PRG routine XY=tick rate (hz)

CHANGE_MUSIC_SPEED:  ; call this with A=0-3 for faster playback (0=normal)
	CMP #4
	BCC CMSPD1
	LDA #0 ; invalid speed values default to 0 (normal speed)
CMSPD1:
	STA MUSIC_SPEED
	JMP STM2:

;Music playback tick rate in Hz (60=normal speed)
MUSIC_SPEED_HZ_TABLE:
	!BYTE 60, 63, 70, 75

STOP_MUSIC:
	STZ MUSIC_PLAYING
	JSR ZSM_STOP
	RTS

; Zsound optionally makes a callback whenever music loops/finishes playing.
; It passes:
;   Z flag=1 for music state=playing (i.e. tune has looped)
;   Z flag=0 for music stopped. (tune has ended)
;   A = number of loops remaining (0=infinite, 1=this is last time, etc...)
; Thus BEQ asks the question: "is the music playing? (branches if playing)"
;
; We use it here to clear the MUSIC_PLAYING flag if a non-looping tune finishes
; playing. This "just happens" so there is no need to poll the music player
; for its status. Just read this flag.
;
MUSIC_LOOP_CALLBACK:
	BNE MLCALL1
	STZ MUSIC_PLAYING ; clear MUSIC_PLAYING if the song has finished.
MLCALL1:
	RTS

; This routine expects A = song index e.g. #SONG_MAIN, #SONG_LEVELA, etc.
LOAD_DYNAMIC_SONG:
	CMP MUSIC_DYNAMIC_SONG  ; Check whether it's the song already loaded
	BNE LDS0				        ; If so, then don't bother loading it again
	RTS
LDS0:
	STA MUSIC_DYNAMIC_SONG ; update the currently-loaded ID value
	CMP #SONG_MAIN
	BNE LDS1
	LDX #<INTRO_MUSIC_FILENAME ; XY = pointer to file name for SETNAM
	LDY #>INTRO_MUSIC_FILENAME
	LDA #8                     ; name length for SETNAM
	JMP LDS2
LDS1:
	TAX ; use the song ID as index into "music letter" string
	LDA MUSIC_LETTER,X
	STA MUSIC_FILENAME+5
	LDX #<MUSIC_FILENAME		; XY = pointer to file name for SETNAM
	LDY #>MUSIC_FILENAME
	LDA #10									; name length for SETNAM
LDS2:
	JSR	$FFBD	;SETNAM A=FILE NAME LENGTH X/Y=POINTER TO FILENAME
	LDA #0    ; 0 is the LFN for LOAD
	LDX #8    ; device 8
	LDY #2		; use SA=2 for headerless load (ZSM has no PRG-style header)
	JSR	$FFBA	;SETFLS A=LOGICAL NUMBER X=DEVICE NUMBER Y=SECONDARY
	LDX #SONG_DYNAMIC ; use the memory location for dynamic song loads....
	LDA ZSM_BANK,X
	STA $00           ; select the correct HiRAM bank before calling LOAD
	LDY ZSM_HI,X
	LDA ZSM_LO,X
	TAX
	LDA #0
	JSR	$FFD5	;LOAD FILE A=0 FOR LOAD X/Y=LOAD ADDRESS
	RTS

CLEAR_YM:
  LDA #$0F
  LDX #$E0
NEXT_RR:         ; Set Release Rate = max
  JSR YMWRITE
  INX
  BNE NEXT_RR
  LDA #7
  LDX #8
NEXT_KEYUP:      ; Release all 8 voices
  JSR YMWRITE
  DEC
  BPL NEXT_KEYUP
  ; Register $19 behaves differently. Values $00-$7F affect PMD parameter
  ; and values $80-$FF affect AMD. We will write the $80 here to clear
  ; AMD and let the main FULL_CLEAR loop write the PMD value later.
  LDA #$80
  LDX #$19
  JSR YMWRITE
  LDA #02
  LDX #01
  JSR YMWRITE  ; reset LFO
  ; special-cases handled. Now write 0 into every register.
  LDA #0
  LDX #$0F     ; loop regs $0F -> $FF -> $00 -> $01.
FULL_CLEAR:    ; $02-$07 and $09-$0E are unused. $08 is already cleared.
  JSR YMWRITE
  INX
  CPX #2
  BNE FULL_CLEAR
  RTS

YMreg = $9f40
YMval = $9f41

YMWRITE:
  ; YM Status busy flag check (bit7 set = YM is busy.)
  BIT YMval
  BMI YMWRITE
  ; pre-write delay (currently 0)
  STX YMreg
  ; reg/val delay (minimum 5 NOPS)
  NOP
  NOP
  NOP
  NOP
  NOP
  STA YMval
  RTS


LEVEL_MUSIC:
	!BYTE SONG_LEVELA, SONG_LEVELB, SONG_LEVELC, SONG_LEVELF
	!BYTE SONG_LEVELA, SONG_LEVELB, SONG_LEVELC, SONG_LEVELF
	!BYTE SONG_LEVELA, SONG_LEVELB, SONG_LEVELC, SONG_LEVELF
	!BYTE SONG_LEVELA, SONG_LEVELB

INTRO_MUSIC_FILENAME:
	!pet"main.zsm"
MUSIC_FILENAME:
	!PET"level_.zsm" ; LOAD_DYNAMIC_SONG overwrites the _ with the correct letter.
MUSIC_LETTER:
	!PET"xxxabcdef" ; level_.zsm letter  (first 3 names don't match the scheme)

;TEMP ROUTINE TO GIVE ME ALL ITEMS AND WEAPONS
CHEATER:
	LDA	#SFX_CYCLEWEAPON		;CHANGE WEAPON-SOUND
	JSR	PLAY_DIGI_SOUND	;SOUND PLAY
	LDA	#7
	STA	KEYS
	LDA	#100
	STA	AMMO_PISTOL
	STA	AMMO_PLASMA
	STA	INV_BOMBS
	STA	INV_EMP
	STA	INV_MEDKIT
	STA	INV_MAGNET
	LDA	#1
	STA	SELECTED_WEAPON
	STA	SELECTED_ITEM
	JSR	DISPLAY_KEYS
	JSR	DISPLAY_WEAPON
	JSR	DISPLAY_ITEM
	RTS

PAUSE_GAME:
	LDA	#SFX_BEEP2		;menu beep
	JSR	PLAY_DIGI_SOUND	;SOUND PLAY
	;pause clock
	LDA	#0
	STA	CLOCK_ACTIVE
	;display message to user
	JSR	SCROLL_INFO
	LDA	#<MSG_PAUSED
	STA	$02
	LDA	#>MSG_PAUSED
	STA	$03
	JSR	PRINT_INFO
	JSR	CLEAR_KEY_BUFFER
PG1:	JSR	$FFE4
	CMP	#$00
	BEQ	PG1
	CMP	#03	;RUN/STOP
	BEQ	PG5
	CMP	#78	;N-KEY
	BEQ	PG5
	CMP	#89	;Y-KEY
	BEQ	PG6
	JMP	PG1
PG5:	LDA	#SFX_BEEP2		;menu beep
	JSR	PLAY_DIGI_SOUND	;SOUND PLAY
	JSR	SCROLL_INFO
	JSR	SCROLL_INFO
	JSR	SCROLL_INFO
	JSR	CLEAR_KEY_BUFFER
	LDA	#1
	STA	CLOCK_ACTIVE
	JMP	MAIN_GAME_LOOP
PG6:	LDA	#0
	STA	UNIT_TYPE	;make player dead
	JMP	GOM4

CLEAR_KEY_BUFFER:
  ; -- leaving this unchanged, since modifying it doesn't affect the
	;    in-game behavior as far as I can tell, but here is code to truly
	;    empty the KBD buffer in X16 using Kernal API which doesn't change
	;    with Kernal/Emu version updates. (peeking into KVARS directly being
	;    discouraged until Kernal becomes "finalized" and unchanging.)
  ;JSR $FFE4 ; GETIN
	;CMP #0
 	;BNE CLEAR_KEY_BUFFER

	LDA	#0
	STA	$0289	;disable keyboard input
	LDA	#0
	; NOTE - this address is no longer the KBD buffer index.
	STA	$00C6	;CLEAR KEYBOARD BUFFER
	LDA	#20
	STA	KEYTIMER
	RTS

USE_ITEM:
	;First figure out which item to use.
	LDA	SELECTED_ITEM
	CMP	#1	;BOMB
	BNE	UI02
	JMP	USE_BOMB
UI02:	CMP	#2	;EMP
	BNE	UI03
	JMP	USE_EMP
UI03:	CMP	#3	;MEDKIT
	BNE	UI04
	JMP	USE_MEDKIT
UI04:	CMP	#4	;MAGNET
	BNE	UI05
	JMP	USE_MAGNET
UI05:	RTS

USE_BOMB:
	LDA	#1	;COMPASS
	STA	CURSOR_ON
	JSR	USER_SELECT_OBJECT
	;NOW TEST TO SEE IF THAT SPOT IS OPEN
	JSR	BOMB_MAGNET_COMMON1
	BEQ	BM30
	JMP	BM3A				;If not, then exit routine.
BM30:	;Now scan for any units at that location:
	JSR	CHECK_FOR_UNIT
	LDA	UNIT_FIND
	CMP	#255			;255 means no unit found.
	BEQ	BM31
BM3A:	JMP	BOMB_MAGNET_COMMON2
BM31:	LDX	#28	;Start of weapons units
BOMB1:	LDA	UNIT_TYPE,X
	CMP	#0
	BEQ	BOMB2
	INX
	CPX	#32
	BNE	BOMB1
	RTS	;no slots available right now, abort.
BOMB2:	LDA	#6	;bomb AI
	STA	UNIT_TYPE,X
	LDA	#130	;bomb tile
	STA	UNIT_TILE,X
	LDA	MAP_X
	STA	UNIT_LOC_X,X
	LDA	MAP_Y
	STA	UNIT_LOC_Y,X
	LDA	#100		;How long until exposion?
	STA	UNIT_TIMER_A,X
	LDA	#0
	STA	UNIT_A,X
	DEC	INV_BOMBS
	JSR	DISPLAY_ITEM
	LDA	#01
	STA	REDRAW_WINDOW
	LDA	#SFX_MOVE		;move sound
	JSR	PLAY_DIGI_SOUND	;SOUND PLAY
	RTS

USE_MAGNET:
	LDA	MAGNET_ACT	;only one magnet active at a time.
	CMP	#0
	BEQ	MG32
	RTS
MG32:	LDA	#1	;COMPASS
	STA	CURSOR_ON
	JSR	USER_SELECT_OBJECT
	;NOW TEST TO SEE IF THAT SPOT IS OPEN
	JSR	BOMB_MAGNET_COMMON1
	BEQ	MG31
	JMP	BOMB_MAGNET_COMMON2
MG31:	LDX	#28	;Start of weapons units
MAG1:	LDA	UNIT_TYPE,X
	CMP	#0
	BEQ	MAG2
	INX
	CPX	#32
	BNE	MAG1
	RTS	;no slots available right now, abort.
MAG2:	LDA	#20	;MAGNET AI
	STA	UNIT_TYPE,X
	LDA	#134	;MAGNET tile
	STA	UNIT_TILE,X
	LDA	MAP_X
	STA	UNIT_LOC_X,X
	LDA	MAP_Y
	STA	UNIT_LOC_Y,X
	LDA	#1		;How long until ACTIVATION
	STA	UNIT_TIMER_A,X
	LDA	#255		;how long does it live -A
	STA	UNIT_TIMER_B,X
	LDA	#5		;how long does it live -B
	STA	UNIT_A,X
	LDA	#1
	STA	MAGNET_ACT	;only one magnet allowed at a time.
	DEC	INV_MAGNET
	JSR	DISPLAY_ITEM
	LDA	#01
	STA	REDRAW_WINDOW
	LDA	#SFX_MOVE		;move sound
	JSR	PLAY_DIGI_SOUND	;SOUND PLAY
	RTS

BOMB_MAGNET_COMMON1:
	LDA	#0
	STA	CURSOR_ON
	JSR	REVERSE_TILE
	JSR	DRAW_MAP_WINDOW		;ERASE THE CURSOR
	LDA	CURSOR_X
	CLC
	ADC	MAP_WINDOW_X
	STA	MAP_X
	STA	MOVTEMP_UX
	LDA	CURSOR_Y
	CLC
	ADC	MAP_WINDOW_Y
	STA	MAP_Y
	STA	MOVTEMP_UY
	JSR	GET_TILE_FROM_MAP
	LDA	TILE
	TAY
	LDA	TILE_ATTRIB,Y
	AND	#%00000001		;is that spot available
	CMP	#%00000001		;for something to move onto it?
	RTS

BOMB_MAGNET_COMMON2:
	LDA	#<MSG_BLOCKED
	STA	$02
	LDA	#>MSG_BLOCKED
	STA	$03
	JSR	PRINT_INFO
	LDA	#SFX_ERROR		;ERROR SOUND
	JSR	PLAY_DIGI_SOUND	;SOUND PLAY
	RTS

USE_EMP:
	LDA	#SFX_EMP		;EMP sound
	JSR	PLAY_DIGI_SOUND	;SOUND PLAY
	LDA	#10
	STA	BGFLASH
	DEC	INV_EMP
	JSR	DISPLAY_ITEM
	LDX	#1	;start with unit#1 (skip player)
EMP1:	;CHECK THAT UNIT EXISTS
	LDA	UNIT_TYPE,X
	CMP	#0
	BEQ	EMP5
	;CHECK HORIZONTAL POSITION
	LDA	UNIT_LOC_X,X
	CMP	MAP_WINDOW_X
	BCC	EMP5
	LDA	MAP_WINDOW_X
	CLC
	ADC	#10
	CMP	UNIT_LOC_X,X
	BCC	EMP5
	;NOW CHECK VERTICAL
	LDA	UNIT_LOC_Y,X
	CMP	MAP_WINDOW_Y
	BCC	EMP5
	LDA	MAP_WINDOW_Y
	CLC
	ADC	#6
	CMP	UNIT_LOC_Y,X
	BCC	EMP5
	LDA	#255
	STA	UNIT_TIMER_A,X
	;test to see if unit is above water
	LDA	UNIT_LOC_X,X
	STA	MAP_X
	LDA	UNIT_LOC_Y,X
	STA	MAP_Y
	JSR	GET_TILE_FROM_MAP
	LDA	TILE
	CMP	#204	;WATER
	BNE	EMP5
	LDA	#5
	STA	UNIT_TYPE,X
	STA	UNIT_TIMER_A,X
	LDA	#60
	STA	UNIT_A,X
	LDA	#140	;Electrocuting tile
	STA	UNIT_TILE,X
EMP5:	INX
	CPX	#28
	BNE	EMP1
	LDA	#<MSG_EMPUSED
	STA	$02
	LDA	#>MSG_EMPUSED
	STA	$03
	JSR	PRINT_INFO
	RTS

USE_MEDKIT:
	LDA	UNIT_HEALTH
	CMP	#12	;Do we even need the medkit?
	BNE	UMK1
	RTS
UMK1:	;Now figure out how many HP we need to be healthy.
	LDA	#12
	SEC
	SBC	UNIT_HEALTH
	STA	TEMP_A		;how many we need.
	LDA	INV_MEDKIT	;how many do we have?
	SEC
	SBC	TEMP_A
	BCC	UMK2
	;we had more than we need, so go to full health.
	LDA	#12
	STA	UNIT_HEALTH
	LDA	INV_MEDKIT
	SEC
	SBC	TEMP_A
	STA	INV_MEDKIT
	JMP	UMK3
UMK2:	;we had less than we need, so we'll use what is available.
	LDA	INV_MEDKIT
	CLC
	ADC	UNIT_HEALTH
	STA	UNIT_HEALTH
	LDA	#0
	STA	INV_MEDKIT
UMK3:	JSR	DISPLAY_PLAYER_HEALTH
	JSR	DISPLAY_ITEM
	LDA	#SFX_MEDKIT		;MEDKIT SOUND
	JSR	PLAY_DIGI_SOUND	;SOUND PLAY
	LDA	#<MSG_MUCHBET
	STA	$02
	LDA	#>MSG_MUCHBET
	STA	$03
	JSR	PRINT_INFO
	RTS

FIRE_UP:
	LDA	#0	;FACE UP
	STA	PLAYER_DIRECTION
	JSR	DISPLAY_PLAYER_SPRITE
	LDA	SELECTED_WEAPON
	CMP	#0
	BNE	FRU0
	RTS
FRU0:		CMP	#1
	BNE	FRU1
	JMP	FIRE_UP_PISTOL
FRU1:	JMP	FIRE_UP_PLASMA

FIRE_UP_PISTOL:
	LDA	AMMO_PISTOL
	CMP	#0
	BNE	FU00
	RTS
FU00:	LDX	#28
FU01:	LDA	UNIT_TYPE,X
	CMP	#0
	BEQ	FU02
	INX
	CPX	#32	;max unit for weaponsfire
	BNE	FU01
	RTS
FU02:	LDA	#12	;Fire pistol up AI routine
	STA	UNIT_TYPE,X
	LDA	#244	;tile for vertical weapons fire
	STA	UNIT_TILE,X
	LDA	#3		;travel distance.
	STA	UNIT_A,X
	LDA	#0		;weapon-type = pistol
	STA	UNIT_B,X
	JMP	AFTER_FIRE

FIRE_UP_PLASMA:
	LDA	BIG_EXP_ACT
	CMP	#1
	BEQ	FUP3
	LDA	PLASMA_ACT
	CMP	#1
	BEQ	FUP3
	LDA	AMMO_PLASMA
	CMP	#0
	BNE	FUP0
FUP3:	RTS
FUP0:	LDX	#28
FUP1:	LDA	UNIT_TYPE,X
	CMP	#0
	BEQ	FUP2
	INX
	CPX	#32	;max unit for weaponsfire
	BNE	FUP1
	RTS
FUP2:	LDA	#12	;Fire pistol up AI routine
	STA	UNIT_TYPE,X
	LDA	#240	;tile for vertical plasma bolt
	STA	UNIT_TILE,X
	LDA	#3		;travel distance.
	STA	UNIT_A,X
	LDA	#1		;weapon-type = plasma
	STA	UNIT_B,X
	STA	PLASMA_ACT
	JMP	AFTER_FIRE

FIRE_DOWN:
	LDA	#3	;FACE DOWN
	STA	PLAYER_DIRECTION
	JSR	DISPLAY_PLAYER_SPRITE
	LDA	SELECTED_WEAPON
	CMP	#0
	BNE	FRD0
	RTS
FRD0:	CMP	#1
	BNE	FRD1
	JMP	FIRE_DOWN_PISTOL
FRD1:	JMP	FIRE_DOWN_PLASMA

FIRE_DOWN_PISTOL:
	LDA	AMMO_PISTOL
	CMP	#0
	BNE	FD00
	RTS
FD00:	LDX	#28
FD01:	LDA	UNIT_TYPE,X
	CMP	#0
	BEQ	FD02
	INX
	CPX	#32	;max unit for weaponsfire
	BNE	FD01
	RTS
FD02:	LDA	#13	;Fire pistol DOWN AI routine
	STA	UNIT_TYPE,X
	LDA	#244	;tile for vertical weapons fire
	STA	UNIT_TILE,X
	LDA	#3		;travel distance.
	STA	UNIT_A,X
	LDA	#0		;weapon-type = pistol
	STA	UNIT_B,X
	JMP	AFTER_FIRE

FIRE_DOWN_PLASMA:
	LDA	BIG_EXP_ACT
	CMP	#1
	BEQ	FDP3
	LDA	PLASMA_ACT
	CMP	#1
	BEQ	FDP3
	LDA	AMMO_PLASMA
	CMP	#0
	BNE	FDP0
FDP3:	RTS
FDP0:	LDX	#28
FDP1:	LDA	UNIT_TYPE,X
	CMP	#0
	BEQ	FDP2
	INX
	CPX	#32	;max unit for weaponsfire
	BNE	FDP1
	RTS
FDP2:	LDA	#13	;Fire pistol DOWN AI routine
	STA	UNIT_TYPE,X
	LDA	#240	;tile for vertical weapons fire
	STA	UNIT_TILE,X
	LDA	#3		;travel distance.
	STA	UNIT_A,X
	LDA	#1		;weapon-type = plasma
	STA	UNIT_B,X
	STA	PLASMA_ACT
	JMP	AFTER_FIRE

FIRE_LEFT:
	LDA	#6	;FACE LEFT
	STA	PLAYER_DIRECTION
	JSR	DISPLAY_PLAYER_SPRITE
	LDA	SELECTED_WEAPON
	CMP	#0
	BNE	FRL0
	RTS
FRL0:	CMP	#1
	BNE	FRL1
	JMP	FIRE_LEFT_PISTOL
FRL1:	JMP	FIRE_LEFT_PLASMA

FIRE_LEFT_PISTOL:
	LDA	AMMO_PISTOL
	CMP	#0
	BNE	FL00
	RTS
FL00:	LDX	#28
FL01:	LDA	UNIT_TYPE,X
	CMP	#0
	BEQ	FL02
	INX
	CPX	#32	;max unit for weaponsfire
	BNE	FL01
	RTS
FL02:	LDA	#14	;Fire pistol LEFT AI routine
	STA	UNIT_TYPE,X
	LDA	#245	;tile for horizontal weapons fire
	STA	UNIT_TILE,X
	LDA	#5		;travel distance.
	STA	UNIT_A,X
	LDA	#0		;weapon-type = pistol
	STA	UNIT_B,X
	JMP	AFTER_FIRE

FIRE_LEFT_PLASMA:
	LDA	BIG_EXP_ACT
	CMP	#1
	BEQ	FLP3
	LDA	PLASMA_ACT
	CMP	#1
	BEQ	FLP3
	LDA	AMMO_PLASMA
	CMP	#0
	BNE	FLP0
FLP3:	RTS
FLP0:	LDX	#28
FLP1:	LDA	UNIT_TYPE,X
	CMP	#0
	BEQ	FLP2
	INX
	CPX	#32	;max unit for weaponsfire
	BNE	FLP1
	RTS
FLP2:	LDA	#14	;Fire pistol LEFT AI routine
	STA	UNIT_TYPE,X
	LDA	#241	;tile for horizontal weapons fire
	STA	UNIT_TILE,X
	LDA	#5		;travel distance.
	STA	UNIT_A,X
	LDA	#1		;weapon-type = plasma
	STA	UNIT_B,X
	STA	PLASMA_ACT
	JMP	AFTER_FIRE

FIRE_RIGHT:
	LDA	#9	;FACE RIGHT
	STA	PLAYER_DIRECTION
	JSR	DISPLAY_PLAYER_SPRITE	
	LDA	SELECTED_WEAPON
	CMP	#0
	BNE	FRR0
	RTS
FRR0:	CMP	#1
	BNE	FRR1
	JMP	FIRE_RIGHT_PISTOL
FRR1:	JMP	FIRE_RIGHT_PLASMA

FIRE_RIGHT_PISTOL:
	LDA	AMMO_PISTOL
	CMP	#0
	BNE	FR00
	RTS
FR00:	LDX	#28
FR01:	LDA	UNIT_TYPE,X
	CMP	#0
	BEQ	FR02
	INX
	CPX	#32	;max unit for weaponsfire
	BNE	FR01
	RTS
FR02:	LDA	#15	;Fire pistol RIGHT AI routine
	STA	UNIT_TYPE,X
	LDA	#245	;tile for horizontal weapons fire
	STA	UNIT_TILE,X
	LDA	#5		;travel distance.
	STA	UNIT_A,X
	LDA	#0		;weapon-type = pistol
	STA	UNIT_B,X
	JMP	AFTER_FIRE

FIRE_RIGHT_PLASMA:
	LDA	BIG_EXP_ACT
	CMP	#1
	BEQ	FRP3
	LDA	PLASMA_ACT
	CMP	#1
	BEQ	FRP3
	LDA	AMMO_PLASMA
	CMP	#0
	BNE	FRP0
FRP3:	RTS
FRP0:	LDX	#28
FRP1:	LDA	UNIT_TYPE,X
	CMP	#0
	BEQ	FRP2
	INX
	CPX	#32	;max unit for weaponsfire
	BNE	FRP1
	RTS
FRP2:	LDA	#15	;Fire pistol RIGHT AI routine
	STA	UNIT_TYPE,X
	LDA	#241	;tile for horizontal weapons fire
	STA	UNIT_TILE,X
	LDA	#5		;travel distance.
	STA	UNIT_A,X
	LDA	#1		;weapon-type = plasma
	STA	UNIT_B,X
	STA	PLASMA_ACT
	JMP	AFTER_FIRE

AFTER_FIRE:
	LDA	#0
	STA	UNIT_TIMER_A,X
	LDA	UNIT_LOC_X
	STA	UNIT_LOC_X,X
	LDA	UNIT_LOC_Y
	STA	UNIT_LOC_Y,X
	STX	UNIT
	LDA	SELECTED_WEAPON
	CMP	#2
	BEQ	AF01
	LDA	#SFX_PISTOL		;PISTOL-SOUND
	JSR	PLAY_DIGI_SOUND	;SOUND PLAY
	DEC	AMMO_PISTOL
	JSR	DISPLAY_WEAPON
	RTS
AF01:	LDA	#SFX_PLASMA		;PLASMA-GUN-SOUND
	JSR	PLAY_DIGI_SOUND	;SOUND PLAY
	DEC	AMMO_PLASMA
	JSR	DISPLAY_WEAPON
	RTS

KEY_REPEAT:
	LDA	#16
	STA	$028C	;reset kernal repeat timer (to prevent repeats)
	LDA	KEYTIMER
	CMP	#0
	BNE	KEYR2
	LDA	$C5
	CMP	#64	;no key pressed
	BEQ	KEYR1
	LDA	#64	;clear LSTX register
	STA	$C5	;clear LSTX register
	LDA	#7
	STA	KEYTIMER
	RTS
KEYR1:	;No key pressed, reset all to defaults
	LDA	#0
	STA	KEY_FAST
	LDA	#7
	STA	KEYTIMER
KEYR2:	RTS

;This routine handles things that are in common to
;all 4 directions of movement.
AFTER_MOVE:
	LDA	MOVE_RESULT
	CMP	#1
	BNE	AM01
	JSR	ANIMATE_PLAYER
	JSR	CACULATE_AND_REDRAW
AM01:	;now reset key-repeat rate
	LDA	KEY_FAST
	CMP	#0
	BNE	KEYR3
	;FIRST REPEAT
	LDA	#15
	STA	KEYTIMER
	INC	KEY_FAST
KEYR4:	JMP	MAIN_GAME_LOOP
KEYR3:	;SUBSEQUENT REPEATS
	LDA	#7
	STA	KEYTIMER
	JMP	MAIN_GAME_LOOP
KEY_FAST	!BYTE	0	;0=DEFAULT STATE

;This routine is invoked when the user presses S to search
;an object such as a crate, chair, or plant.
SEARCH_OBJECT:
	LDA	#2	;MAGNIFIER
	STA	CURSOR_ON
	JSR	USER_SELECT_OBJECT
	JSR	REVERSE_TILE
	LDA	#1
	STA	REDRAW_WINDOW
CHS1:	;first check of object is searchable
	JSR	CALC_COORDINATES
	JSR	GET_TILE_FROM_MAP
	LDX	TILE
	LDA	TILE_ATTRIB,X
	AND	#%01000000	;can search attribute
	CMP	#%01000000
	BEQ	CHS2
	LDA	#0
	STA	CURSOR_ON
	JSR	REVERSE_TILE
	JMP	CHS3
CHS2:	;is the tile a crate?
	LDX	TILE
	CPX	#041	;BIG CRATE
	BEQ	CHS2B
	CPX	#045	;small CRATE
	BEQ	CHS2B
	CPX	#199	;"Pi" CRATE
	BEQ	CHS2B
	JMP	CHS2C
CHS2B:	LDA	DESTRUCT_PATH,X
	STA	TILE
	JSR	PLOT_TILE_TO_MAP
CHS2C:	;Now check if there is an object there.
	LDA	#0
	STA	SEARCHBAR
	LDA	#<MSG_SEARCHING
	STA	$02
	LDA	#>MSG_SEARCHING
	STA	$03
	JSR	PRINT_INFO
SOBJ1:	LDA	#18	;delay time between search periods.
	STA	BGTIMER2
SOBJ2:	JSR	BACKGROUND_TASKS
	LDA	BGTIMER2
	CMP	#0
	BNE	SOBJ2
	LDA	#0
	STA	VERA_H
	LDA	#29
	STA	VERA_M
	LDA	SEARCHBAR
	ASL	;MULTIPLY BY TWO
	CLC
	ADC	#18
	STA	VERA_L
	LDA	#46	;PERIOD
	STA	VERA_DATA

	STA	$E3C9,X
	INC	SEARCHBAR
	LDA	SEARCHBAR
	CMP	#8
	BNE	SOBJ1
	LDA	#0
	STA	CURSOR_ON
	JSR	REVERSE_TILE
	JSR	DRAW_MAP_WINDOW		;ERASE THE CURSOR
	JSR	CALC_COORDINATES
	JSR	CHECK_FOR_HIDDEN_UNIT
	LDA	UNIT_FIND
	CMP	#255
	BNE	SOBJ5
CHS3:	LDA	#<MSG_NOTFOUND
	STA	$02
	LDA	#>MSG_NOTFOUND
	STA	$03
	JSR	PRINT_INFO
	RTS
SOBJ5:	LDX	UNIT_FIND
	LDA	UNIT_TYPE,X
	STA	TEMP_A		;store object type
	LDA	UNIT_A,X
	STA	TEMP_B		;store secondary info
	LDA	#0	;DELETE ITEM ONCE FOUND
	STA	UNIT_TYPE,X
	;***NOW PROCESS THE ITEM FOUND***
	LDA	#SFX_FOUNDITEM		;ITEM-FOUND-SOUND
	JSR	PLAY_DIGI_SOUND	;SOUND PLAY
	LDA	TEMP_A
	CMP	#128	;key
	BEQ	SOBJ10
	JMP	SOBJ15
SOBJ10:	LDA	TEMP_B		;WHICH SORT OF KEY?
	CMP	#00
	BNE	SOBJK1
	LDA	KEYS
	ORA	#%00000001	;Add spade key
	STA	KEYS
	JMP	SOBJ12
SOBJK1:	CMP	#01
	BNE	SOBJK2
	LDA	KEYS
	ORA	#%00000010	;Add heart key
	STA	KEYS
	JMP	SOBJ12
SOBJK2:	LDA	KEYS
	ORA	#%00000100	;Add star key
	STA	KEYS
SOBJ12:	LDA	#<MSG_FOUNDKEY
	STA	$02
	LDA	#>MSG_FOUNDKEY
	STA	$03
	JSR	PRINT_INFO
	JSR	DISPLAY_KEYS
	RTS
SOBJ15:	CMP	#129	;TIME BOMB
	BNE	SOBJ17
	LDA	TEMP_B
	CLC
	ADC	INV_BOMBS
	STA	INV_BOMBS
	LDA	#<MSG_FOUNDBOMB
	STA	$02
	LDA	#>MSG_FOUNDBOMB
	STA	$03
	JSR	PRINT_INFO
	JSR	DISPLAY_ITEM
	RTS
SOBJ17:	CMP	#130	;EMP
	BNE	SOBJ20
	LDA	TEMP_B
	CLC
	ADC	INV_EMP
	STA	INV_EMP
	LDA	#<MSG_FOUNDEMP
	STA	$02
	LDA	#>MSG_FOUNDEMP
	STA	$03
	JSR	PRINT_INFO
	JSR	DISPLAY_ITEM
	RTS
SOBJ20:	CMP	#131	;PISTOL
	BNE	SOBJ21
	LDA	TEMP_B
	CLC
	ADC	AMMO_PISTOL
	STA	AMMO_PISTOL
	BCC	SOBJ2A	;If we rolled over past 255
	LDA	#255	;set it to 255.
	STA	AMMO_PISTOL
SOBJ2A:	LDA	#<MSG_FOUNDGUN
	STA	$02
	LDA	#>MSG_FOUNDGUN
	STA	$03
	JSR	PRINT_INFO
	JSR	DISPLAY_WEAPON
SOBJ21:	CMP	#132	;PLASMA GUN
	BNE	SOBJ22
	LDA	TEMP_B
	CLC
	ADC	AMMO_PLASMA
	STA	AMMO_PLASMA
	LDA	#<MSG_FOUNDPLAS
	STA	$02
	LDA	#>MSG_FOUNDPLAS
	STA	$03
	JSR	PRINT_INFO
	JSR	DISPLAY_WEAPON
SOBJ22:	CMP	#133	;MEDKIT
	BNE	SOBJ23
	LDA	TEMP_B
	CLC
	ADC	INV_MEDKIT
	STA	INV_MEDKIT
	LDA	#<MSG_FOUNDMED
	STA	$02
	LDA	#>MSG_FOUNDMED
	STA	$03
	JSR	PRINT_INFO
	JSR	DISPLAY_ITEM
SOBJ23:	CMP	#134	;MAGNET
	BNE	SOBJ99
	LDA	TEMP_B
	CLC
	ADC	INV_MAGNET
	STA	INV_MAGNET
	LDA	#<MSG_FOUNDMAG
	STA	$02
	LDA	#>MSG_FOUNDMAG
	STA	$03
	JSR	PRINT_INFO
	JSR	DISPLAY_ITEM
SOBJ99:	;ADD CODE HERE FOR OTHER OBJECT TYPES
	RTS
SEARCHBAR	!BYTE 00	;to count how many periods to display.

;combines cursor location with window location
;to determine coordinates for MAP_X and MAP_Y
CALC_COORDINATES:
	LDA	CURSOR_X
	CLC
	ADC	MAP_WINDOW_X
	STA	MAP_X
	LDA	CURSOR_Y
	CLC
	ADC	MAP_WINDOW_Y
	STA	MAP_Y
	RTS

;This routine is called by routines such as the move, search,
;or use commands.  It displays a cursor and allows the user
;to pick a direction of an object.
USER_SELECT_OBJECT:
	LDA	#SFX_BEEP		;short beep sound
	JSR	PLAY_DIGI_SOUND	;SOUND PLAY
	LDA	#5
	STA	CURSOR_X
	LDA	#3
	STA	CURSOR_Y
	JSR	REVERSE_TILE
	;First ask user which object to move
MV01:	JSR	BACKGROUND_TASKS
	LDA	UNIT_TYPE
	CMP	#0	;Did player die wile moving something?
	BNE	MVCONT
	LDA	#0
	STA	CURSOR_ON
	JSR	REVERSE_TILE
	RTS
MVCONT:	LDA	CONTROL
	CMP	#2
	BNE	MV01A
	JMP	MVSNES
MV01A:	JSR	$FFE4
	CMP	#$00
	BEQ	MV02
MV02:	CMP	#$1D	;CURSOR RIGHT
	BNE	MV03
	INC	CURSOR_X
	LDA	#9	;FACE RIGHT
	STA	PLAYER_DIRECTION
	JSR	DISPLAY_PLAYER_SPRITE
	RTS
MV03:	CMP	#$9D	;CURSOR LEFT
	BNE	MV04
	DEC	CURSOR_X
	LDA	#6	;FACE LEFT
	STA	PLAYER_DIRECTION
	JSR	DISPLAY_PLAYER_SPRITE
	RTS
MV04:	CMP	#$11	;CURSOR DOWN
	BNE	MV05
	INC	CURSOR_Y
	LDA	#3	;FACE DOWN
	STA	PLAYER_DIRECTION
	JSR	DISPLAY_PLAYER_SPRITE
	RTS
MV05:	CMP	#$91	;CURSOR UP
	BNE	MV06
	DEC	CURSOR_Y
	LDA	#0	;FACE UP
	STA	PLAYER_DIRECTION
	JSR	DISPLAY_PLAYER_SPRITE
	RTS
MV06:	CMP	KEY_MOVE_LEFT
	BNE	MV07
	DEC	CURSOR_X
	RTS
MV07:	CMP	KEY_MOVE_DOWN
	BNE	MV08
	INC	CURSOR_Y
	RTS
MV08:	CMP	KEY_MOVE_RIGHT
	BNE	MV09
	INC	CURSOR_X
	RTS
MV09:	CMP	KEY_MOVE_UP
	BNE	MV0A
	DEC	CURSOR_Y
	RTS
MV0A:	JMP	MV01

MVSNES:	;SNES controls for this routine
	JSR	SNES_CONTROLER_READ
	LDA	NEW_RIGHT
	CMP	#1
	BNE	MVS03
	INC	CURSOR_X
	LDA	#0
	STA	NEW_RIGHT
	RTS
MVS03:	LDA	NEW_LEFT
	CMP	#1
	BNE	MVS04
	DEC	CURSOR_X
	LDA	#0
	STA	NEW_LEFT
	RTS
MVS04:	LDA	NEW_DOWN
	CMP	#1
	BNE	MVS05
	INC	CURSOR_Y
	LDA	#0
	STA	NEW_DOWN
	RTS
MVS05:	LDA	NEW_UP
	CMP	#1
	BNE	MVS06
	DEC	CURSOR_Y
	LDA	#0
	STA	NEW_UP
	RTS
MVS06:	JMP	MV01

MOVE_OBJECT:
	LDA	#3	;HAND
	STA	CURSOR_ON
	JSR	USER_SELECT_OBJECT
	LDA	UNIT
	;now test that object to see if it
	;is allowed to be moved.
MV10:	LDA	#0
	STA	CURSOR_ON
	JSR	REVERSE_TILE
	JSR	DRAW_MAP_WINDOW		;ERASE THE CURSOR
	JSR	CALC_COORDINATES
	JSR	CHECK_FOR_HIDDEN_UNIT
	LDA	UNIT_FIND
	STA	MOVTEMP_U
	JSR	GET_TILE_FROM_MAP
	LDA	TILE
	TAY
	LDA	TILE_ATTRIB,Y
	AND	#%00000100		;can it be moved?
	CMP	#%00000100
	BEQ	MV11
	LDA	#<MSG_CANTMOVE
	STA	$02
	LDA	#>MSG_CANTMOVE
	STA	$03
	JSR	PRINT_INFO
	LDA	#SFX_ERROR		;ERROR SOUND
	JSR	PLAY_DIGI_SOUND	;SOUND PLAY
	RTS
MV11:	LDA	TILE
	STA	MOVTEMP_O	;Store which tile it is we are moving
	LDA	MAP_X
	STA	MOVTEMP_X	;Store original location of object
	LDA	MAP_Y
	STA	MOVTEMP_Y
	LDA	#3	;HAND
	STA	CURSOR_ON
	JSR	REVERSE_TILE
	LDA	#SFX_BEEP		;beep sound
	JSR	PLAY_DIGI_SOUND	;SOUND PLAY
	;NOW ASK THE USER WHICH DIRECTION TO MOVE IT TO
MV15:	JSR	BACKGROUND_TASKS
	LDA	UNIT_TYPE
	CMP	#0	;Did player die wile moving something?
	BNE	MVCONT2
	LDA	#0
	STA	CURSOR_ON
	JSR	REVERSE_TILE
	RTS
MVCONT2:	;which controller are we using?
	LDA	CONTROL
	CMP	#2
	BNE	MV15B
	JMP	SMV30

MV15B:	;keyboard control
	JSR	$FFE4
	CMP	#$00
	BEQ	MV15
MV16:	CMP	#$1D	;CURSOR RIGHT
	BNE	MV17
	INC	CURSOR_X
	JMP	MV25
MV17:	CMP	#$9D	;CURSOR LEFT
	BNE	MV18
	DEC	CURSOR_X
	JMP	MV25
MV18:	CMP	#$11	;CURSOR DOWN
	BNE	MV19
	INC	CURSOR_Y
	JMP	MV25
MV19:	CMP	#$91	;CURSOR UP
	BNE	MV20
	DEC	CURSOR_Y
	JMP	MV25
MV20:	CMP	KEY_MOVE_LEFT
	BNE	MV2A
	DEC	CURSOR_X
	JMP	MV25
MV2A:	CMP	KEY_MOVE_DOWN
	BNE	MV2B
	INC	CURSOR_Y
	JMP	MV25
MV2B:	CMP	KEY_MOVE_RIGHT
	BNE	MV2C
	INC	CURSOR_X
	JMP	MV25
MV2C:	CMP	KEY_MOVE_UP
	BNE	MV2D
	DEC	CURSOR_Y
	JMP	MV25
MV2D:	JMP	MV15

SMV30:	;SNES controls
	JSR	SNES_CONTROLER_READ
	LDA	NEW_RIGHT
	CMP	#1
	BNE	SMV31
	INC	CURSOR_X
	LDA	#0
	STA	NEW_RIGHT
	JMP	MV25
SMV31:	LDA	NEW_LEFT
	CMP	#1
	BNE	SMV32
	DEC	CURSOR_X
	LDA	#0
	STA	NEW_LEFT
	JMP	MV25
SMV32:	LDA	NEW_DOWN
	CMP	#1
	BNE	SMV33
	INC	CURSOR_Y
	LDA	#0
	STA	NEW_DOWN
	JMP	MV25
SMV33:	LDA	NEW_UP
	CMP	#1
	BNE	SMV34
	DEC	CURSOR_Y
	LDA	#0
	STA	NEW_UP
	JMP	MV25
SMV34:	JMP	MV15

	;NOW TEST TO SEE IF THAT SPOT IS OPEN
MV25:	LDA	#0
	STA	CURSOR_ON
	JSR	REVERSE_TILE
	JSR	DRAW_MAP_WINDOW		;ERASE THE CURSOR
	LDA	CURSOR_X
	CLC
	ADC	MAP_WINDOW_X
	STA	MAP_X
	STA	MOVTEMP_UX
	LDA	CURSOR_Y
	CLC
	ADC	MAP_WINDOW_Y
	STA	MAP_Y
	STA	MOVTEMP_UY
	JSR	GET_TILE_FROM_MAP
	LDA	TILE
	TAY
	LDA	TILE_ATTRIB,Y
	AND	#%00100000		;is that spot available
	CMP	#%00100000		;for something to move onto it?
	BEQ	MV30
	JMP	MV3A				;If not, then exit routine.
MV30:	;Now scan for any units at that location:
	JSR	CHECK_FOR_UNIT
	LDA	UNIT_FIND
	CMP	#255			;255 means no unit found.
	BEQ	MV31
MV3A:	LDA	#<MSG_BLOCKED
	STA	$02
	LDA	#>MSG_BLOCKED
	STA	$03
	JSR	PRINT_INFO
	LDA	#SFX_ERROR		;ERROR SOUND
	JSR	PLAY_DIGI_SOUND	;SOUND PLAY
	RTS
MV31:	LDA	#SFX_MOVE		;move sound
	JSR	PLAY_DIGI_SOUND	;SOUND PLAY
	LDY	#0
	LDA	($04),Y			;Grab current object
	STA	MOVTEMP_D
	LDA	MOVTEMP_O
	STA	($04),Y			;replace with obect we are moving
	LDA	MOVTEMP_X		;RETRIEVE original location of object
	STA	MAP_X
	LDA	MOVTEMP_Y
	STA	MAP_Y
	JSR	GET_TILE_FROM_MAP
	LDA	MOVTEMP_D
	CMP	#148		;trash compactor tile
	BNE	MV31A
	LDA	#09		;Floor tile
MV31A:	STA	($04),Y			;Replace former location
	LDA	#1
	STA	REDRAW_WINDOW		;See the result
	LDA	MOVTEMP_U
	CMP	#255
	BNE	MV32
	RTS
MV32:	LDX	MOVTEMP_U
	LDA	MOVTEMP_UX
	STA	UNIT_LOC_X,X
	LDA	MOVTEMP_UY
	STA	UNIT_LOC_Y,X
	RTS
MOVTEMP_O:	!BYTE 00	;origin tile
MOVTEMP_D:	!BYTE 00	;destination tile
MOVTEMP_X:	!BYTE 00	;x-coordinate
MOVTEMP_Y:	!BYTE 00	;y-coordinate
MOVTEMP_U:	!BYTE 00	;unit number (255=none)
MOVTEMP_UX	!BYTE 00
MOVTEMP_UY	!BYTE 00
CACULATE_AND_REDRAW:
	LDA	UNIT_LOC_X	;no index needed since it's player unit
	SEC
	SBC	#5
	STA	MAP_WINDOW_X
	LDA	UNIT_LOC_Y	;no index needed since it's player unit
	SEC
	SBC	#3
	STA	MAP_WINDOW_Y
	LDA	#1
	STA	REDRAW_WINDOW
	RTS

;This routine checks all units from 0 to 31 and figures out if it should be dislpayed
;on screen, and then grabs that unit's tile and stores it in the MAP_PRECALC array
;so that when the window is drawn, it does not have to search for units during the
;draw, speeding up the display routine.
MAP_PRE_CALCULATE:
	;CLEAR OLD BUFFER
	LDA	#0
	LDY	#0
PREC0:	STA	MAP_PRECALC,Y
	INY
	CPY	#77
	BNE	PREC0
	LDX	#1
	;JMP	PREC2	;skip the check for unit zero, always draw it.
PREC1:	;CHECK THAT UNIT EXISTS
	LDA	UNIT_TYPE,X
	CMP	#0
	BEQ	PREC5
	;CHECK HORIZONTAL POSITION
	LDA	UNIT_LOC_X,X
	CMP	MAP_WINDOW_X
	BCC	PREC5
	LDA	MAP_WINDOW_X
	CLC
	ADC	#10
	CMP	UNIT_LOC_X,X
	BCC	PREC5
	;NOW CHECK VERTICAL
	LDA	UNIT_LOC_Y,X
	CMP	MAP_WINDOW_Y
	BCC	PREC5
	LDA	MAP_WINDOW_Y
	CLC
	ADC	#6
	CMP	UNIT_LOC_Y,X
	BCC	PREC5
	;Unit found in map window, now add that unit's
	;tile to the precalc map.
PREC2:	LDA	UNIT_LOC_Y,X
	SEC
	SBC	MAP_WINDOW_Y
	TAY
	LDA	UNIT_LOC_X,X
	SEC
	SBC	MAP_WINDOW_X
	CLC
	ADC	PRECALC_ROWS,Y
	TAY
	LDA	UNIT_TILE,X
	CMP	#130	;is it a bomb
	BEQ	PREC6
	CMP	#134	;is it a magnet?
	BEQ	PREC6
PREC4:	STA	MAP_PRECALC,Y
PREC5:	;continue search
	INX
	CPX	#32
	BNE	PREC1
	RTS
PREC6:	;What to do in case of bomb or magnet that should
	;go underneath the unit or robot.
	LDA	MAP_PRECALC,Y
	CMP	#0
	BNE	PREC5
	LDA	UNIT_TILE,X
	JMP	PREC4

PRECALC_ROWS:	!BYTE	0,11,22,33,44,55,66

;This routine is where the MAP is displayed on the screen
;This is a temporary routine, taken from the map editor.
DRAW_MAP_WINDOW:
	JSR	MAP_PRE_CALCULATE
	LDA	#0
	STA	REDRAW_WINDOW
	STA	TEMP_X
	STA	TEMP_Y
	STA	PRECALC_COUNT
DM01:	;FIRST CALCULATE WHERE THE BYTE IS STORED IN THE MAP
	LDY	#0
	LDA	TEMP_Y
	CLC
	ADC	MAP_WINDOW_Y
	ROR
	PHP
	CLC
	ADC	#>MAP
	STA	$05	;HIGH BYTE OF MAP SOURCE
	LDA	#$0
	PLP
	ROR
	CLC
	ADC	TEMP_X
	ADC	MAP_WINDOW_X
	STA	$04	;LOW BYTE OF MAP SOURCE
	LDA	($04),Y
	STA	TILE
	;NOW FIGURE OUT WHERE TO PLACE IT ON SCREEN.
	LDX	TEMP_X
	LDA	MAP_CHART_L,X
	STA	VERA_L
	LDX	TEMP_Y
	LDA	MAP_CHART_H,X
	STA	VERA_M
	JSR	PLOT_TILE
	;now check for sprites in this location
	LDY	PRECALC_COUNT
	LDA	MAP_PRECALC,Y
	CMP	#00
	BEQ	DM02
	STA	TILE
	LDX	TEMP_X
	LDA	MAP_CHART_L,X
	STA	VERA_L
	LDX	TEMP_Y
	LDA	MAP_CHART_H,X
	STA	VERA_M
	JSR	PLOT_TRANSPARENT_TILE
DM02:	INC	TEMP_X
	INC	PRECALC_COUNT
	LDA	TEMP_X
	CMP	#11
	BNE	DM01
DM04:	LDA	#0
	STA	TEMP_X
	INC	TEMP_Y
	LDA	TEMP_Y
	CMP	#7
	BEQ	DM10
	JMP	DM01
DM10:	RTS

;This routine plots a 3x3 tile from the tile database anywhere
;on screen.  But first you must define the tile number in the
;TILE variable, as well as the starting screen address must
;be defined in $02.
PLOT_TILE:
	LDA	#%00010000
	STA	VERA_H
	LDX	TILE
	;DRAW THE TOP 3 CHARACTERS
	LDA	TILE_DATA_TL,X
	STA	VERA_DATA
	LDA	TILE_COLOR_TL,X
	AND	#%00001111
	STA	VERA_DATA
	LDA	TILE_DATA_TM,X
	STA	VERA_DATA
	LDA	TILE_COLOR_TM,X
	AND	#%00001111
	STA	VERA_DATA
	LDA	TILE_DATA_TR,X
	STA	VERA_DATA
	LDA	TILE_COLOR_TR,X
	AND	#%00001111
	STA	VERA_DATA
	;DRAW THE NEXT ROW
	INC	VERA_M
	LDA	VERA_L
	SEC
	SBC	#06
	STA	VERA_L
	LDA	TILE_DATA_ML,X
	STA	VERA_DATA
	LDA	TILE_COLOR_ML,X
	AND	#%00001111
	STA	VERA_DATA
	LDA	TILE_DATA_MM,X
	STA	VERA_DATA
	LDA	TILE_COLOR_MM,X
	AND	#%00001111
	STA	VERA_DATA
	LDA	TILE_DATA_MR,X
	STA	VERA_DATA
	LDA	TILE_COLOR_MR,X
	AND	#%00001111
	STA	VERA_DATA
	;DRAW THE LAST ROW
	INC	VERA_M
	LDA	VERA_L
	SEC
	SBC	#06
	STA	VERA_L
	LDA	TILE_DATA_BL,X
	STA	VERA_DATA
	LDA	TILE_COLOR_BL,X
	AND	#%00001111
	STA	VERA_DATA
	LDA	TILE_DATA_BM,X
	STA	VERA_DATA
	LDA	TILE_COLOR_BM,X
	AND	#%00001111
	STA	VERA_DATA
	LDA	TILE_DATA_BR,X
	STA	VERA_DATA
	LDA	TILE_COLOR_BR,X
	AND	#%00001111
	STA	VERA_DATA
	RTS

;This routine plots a transparent tile from the tile database
;anywhere on screen.  But first you must define the tile number
;in the TILE variable, as well as the starting screen address must
;be defined.  Also, this routine is slower than the usual
;tile routine, so is only used for sprites.  The ":" character ($3A)
;is not drawn.
PLOT_TRANSPARENT_TILE:
	LDA	#%00010000
	STA	VERA_H
	LDX	TILE
	;DRAW THE TOP 3 CHARACTERS
	LDA	TILE_DATA_TL,X
	CMP	#$3A
	BNE	PTT01
	INC	VERA_L
	INC	VERA_L
	JMP	PTT02A
PTT01:	STA	VERA_DATA
	LDA	TILE_COLOR_TL,X
	AND	#%00001111
	STA	VERA_DATA
PTT02A:	LDA	TILE_DATA_TM,X
	CMP	#$3A
	BNE	PTT02B
	INC	VERA_L
	INC	VERA_L
	JMP	PTT03A
PTT02B:	STA	VERA_DATA
	LDA	TILE_COLOR_TM,X
	AND	#%00001111
	STA	VERA_DATA
PTT03A:	LDA	TILE_DATA_TR,X
	CMP	#$3A
	BNE	PTT03B
	INC	VERA_L
	INC	VERA_L
	JMP	PTT04A
PTT03B:	STA	VERA_DATA
	LDA	TILE_COLOR_TR,X
	AND	#%00001111
	STA	VERA_DATA
	;DRAW THE NEXT ROW
PTT04A:	INC	VERA_M
	LDA	VERA_L
	SEC
	SBC	#06
	STA	VERA_L
	LDA	TILE_DATA_ML,X
	CMP	#$3A
	BNE	PTT04B
	INC	VERA_L
	INC	VERA_L
	JMP	PTT05A
PTT04B:	STA	VERA_DATA
	LDA	TILE_COLOR_ML,X
	AND	#%00001111
	STA	VERA_DATA
PTT05A:	LDA	TILE_DATA_MM,X
	CMP	#$3A
	BNE	PTT05B
	INC	VERA_L
	INC	VERA_L
	JMP	PTT06A
PTT05B:	STA	VERA_DATA
	LDA	TILE_COLOR_MM,X
	AND	#%00001111
	STA	VERA_DATA
PTT06A:	LDA	TILE_DATA_MR,X
	CMP	#$3A
	BNE	PTT06B
	INC	VERA_L
	INC	VERA_L
	JMP	PTT07A
PTT06B:	STA	VERA_DATA
	LDA	TILE_COLOR_MR,X
	AND	#%00001111
	STA	VERA_DATA
	;DRAW THE LAST ROW
PTT07A:	INC	VERA_M
	LDA	VERA_L
	SEC
	SBC	#06
	STA	VERA_L
	LDA	TILE_DATA_BL,X
	CMP	#$3A
	BNE	PTT07B
	INC	VERA_L
	INC	VERA_L
	JMP	PTT08A
PTT07B:	STA	VERA_DATA
	LDA	TILE_COLOR_BL,X
	AND	#%00001111
	STA	VERA_DATA
PTT08A:	LDA	TILE_DATA_BM,X
	CMP	#$3A
	BNE	PTT08B
	INC	VERA_L
	INC	VERA_L
	JMP	PTT09A
PTT08B:	STA	VERA_DATA
	LDA	TILE_COLOR_BM,X
	AND	#%00001111
	STA	VERA_DATA
PTT09A:	LDA	TILE_DATA_BR,X
	CMP	#$3A
	BNE	PTT09B
	RTS
PTT09B:	STA	VERA_DATA
	LDA	TILE_COLOR_BR,X
	AND	#%00001111
	STA	VERA_DATA
	RTS

;This routine originally reversed the tiles on the PET version,
;but here on the X16 instead it turns on the appropriate sprite
REVERSE_TILE:
	LDA	#%00010001
	STA	VERA_H
	LDA	#$FC
	STA	VERA_M
	LDA	CURSOR_ON
	CMP	#0
	BEQ	REV2
	;Determine which cursor image to show
	LDA	#16	;sprite 2 addresss high
	STA	VERA_L
	LDX	CURSOR_ON
	LDA	CURSOR_TABLE, X
	STA	VERA_DATA
	;Set X-position
	LDA	#18	;sprite 2 X position
	STA	VERA_L
	LDA	CURSOR_X
	SEC
	SBC	#4
	TAX
	LDA	X_CURSOR_TABLE,X
	STA	VERA_DATA
	;Set Y-position
	LDA	#20	;sprite 2 X position
	STA	VERA_L
	LDA	CURSOR_Y
	SEC
	SBC	#2
	TAX
	LDA	Y_CURSOR_TABLE,X
	STA	VERA_DATA
	;Enable sprite
	LDA	#22	;sprite 3 z-depth
	STA	VERA_L
	LDA	#%00001100	;enable sprite
	STA	VERA_DATA
	RTS
REV2:	;Turn off cursor sprite
	LDA	#22	;sprite 3 z-depth
	STA	VERA_L
	LDA	#%00000000	;enable sprite
	STA	VERA_DATA
	RTS

CURSOR_TABLE	!BYTE	0,0,16,32	;cursor image
X_CURSOR_TABLE	!BYTE 98,122,146	;cursor position
Y_CURSOR_TABLE	!BYTE 65,89,113		;cursor position

;This routine checks to see if UNIT is occupying any space
;that is currently visible in the window.  If so, the
;flag for redrawing the window will be set.
CHECK_FOR_WINDOW_REDRAW:
	LDX	UNIT
	;FIRST CHECK HORIZONTAL
	LDA	UNIT_LOC_X,X
	CMP	MAP_WINDOW_X
	BCC	CFR1
	LDA	MAP_WINDOW_X
	CLC
	ADC	#10
	CMP	UNIT_LOC_X,X
	BCC	CFR1
	;NOW CHECK VERTICAL
	LDA	UNIT_LOC_Y,X
	CMP	MAP_WINDOW_Y
	BCC	CFR1
	LDA	MAP_WINDOW_Y
	CLC
	ADC	#6
	CMP	UNIT_LOC_Y,X
	BCC	CFR1
	LDA	#1
	STA	REDRAW_WINDOW
CFR1:	RTS

DECWRITE:
	LDA	#%00100000
	STA	VERA_H
	LDA	DECNUM
	LDX 	#2
	LDY 	#$4C
DEC1	STY 	DECB
	LSR
DEC2	ROL
	BCS 	DEC3
	CMP	DECA,X
	BCC 	DEC4
DEC3	SBC 	DECA,X
	SEC
DEC4	ROL 	DECB
	BCC 	DEC2
	STA	DECTEMP
	LDA 	DECB
	STA	VERA_DATA
	LDA	DECTEMP
	LDY 	#$13
	DEX
	BPL 	DEC1
	RTS
DECA		!BYTE  	128,160,200
DECB		!BYTE  	1
DECTEMP		!BYTE	$00

; The following routine loads the tileset from disk
; to memory location $8000
TILE_LOAD_ROUTINE:
	LDA	#11	;LENGTH OF FILENAME
	LDX	#<TILENAME
	LDY	#>TILENAME
	JSR	$FFBD	;SETNAM A=FILE NAME LENGTH X/Y=POINTER TO FILENAME
	LDA	#$02
	LDX	#$08
	LDY	#$00
	JSR	$FFBA	;SETFLS A=LOGICAL NUMBER X=DEVICE NUMBER Y=SECONDARY
	LDX	#$00	;LOW BYTE FOR LOAD ADDRESS
	LDY	#$80	;HIGH BYTE FOR LOAD ADDRESS
	LDA	#$00
	JSR	$FFD5	;LOAD FILE A=0 FOR LOAD X/Y=LOAD ADDRESS
	JSR	$FFC3	;CLOSE FILE
	RTS

; The following routine loads the map from disk
MAP_LOAD_ROUTINE:
	LDA	#7	;LENGTH OF FILENAME
	LDX	#<MAPNAME
	LDY	#>MAPNAME
	JSR	$FFBD	;SETNAM A=FILE NAME LENGTH X/Y=POINTER TO FILENAME
	LDA	#$02
	LDX	#$08
	LDY	#$00
	JSR	$FFBA	;SETFLS A=LOGICAL NUMBER X=DEVICE NUMBER Y=SECONDARY
	LDX	#$00	;LOW BYTE FOR LOAD ADDRESS
	LDY	#$5D	;HIGH BYTE FOR LOAD ADDRESS
	LDA	#$00
	JSR	$FFD5	;LOAD FILE A=0 FOR LOAD X/Y=LOAD ADDRESS
	JSR	$FFC3	;CLOSE FILE
	RTS

;This routine loads in the payload files
;It is a "payload" file that loads into $D500 and
;copies the relevant bits to video-RAM.
LOAD_PAYLOAD:
	LDA	#12	;filename-length
	LDX	#<FILENAME_PAYLOAD
	LDY	#>FILENAME_PAYLOAD
	JSR	$FFBD	;SETNAM A=FILE NAME LENGTH X/Y=POINTER TO FILENAME
	LDA	#$02
	LDX	#$08
	LDY	#$00
	JSR	$FFBA	;SETFLS A=LOGICAL NUMBER X=DEVICE NUMBER Y=SECONDARY
	LDX	#$00
	LDY	#$5D	;load into $D500
	LDA	#$00
	JSR	$FFD5	;LOAD FILE A=0 FOR LOAD X/Y=LOAD ADDRESS
	LDA	#$02
	JSR	$FFC3	;CLOSE FILE
	JSR	$5D00
	RTS

GREEN_SCREEN:
CS02:	LDA	#0
	STA	VERA_M
	LDA	#%00100000
	STA	VERA_H
	LDA	#05	;green
CS03:	LDX	#0
	LDY	#1
	STY	VERA_L
CS04:	STA	VERA_DATA
	INX
	CPX	#40
	BNE	CS04
	INC	VERA_M
	LDY	VERA_M
	CPY	#30
	BNE	CS03
	RTS

DISPLAY_GAME_SCREEN:
	JSR	GREEN_SCREEN
	;first do text part of screen
	LDA	#<SCR_TEXT
	STA	SOURCE_L
	LDA	#>SCR_TEXT
	STA	SOURCE_H
	LDA	#00
	STA	EVENODD
	JSR	DECOMPRESS_SCREEN	;Decompress text characters
	LDA	#01			;Switch to odd (color) bytes
	;now activate graphics on layer 0
	LDA	$9F29
	ORA	#%00010000
	STA	$9F29	;enable layer 0
	LDA	#6
	STA	$9F2D	;set layer 0 to bitmap mode 4BPP
	LDA	#128	;(steps of 512 bytes) set base address $1:0000
	STA	$9F2F	;set base address for bitmap
	RTS

RESET_KEYS_AMMO:
	LDA	#$00
	STA	KEYS
	STA	AMMO_PISTOL
	STA	AMMO_PLASMA
	STA	INV_BOMBS
	STA	INV_EMP
	STA	INV_MEDKIT
	STA	INV_MAGNET
	STA	SELECTED_WEAPON
	STA	SELECTED_ITEM
	STA	MAGNET_ACT
	STA	PLASMA_ACT
	STA	BIG_EXP_ACT
	STA	CYCLES
	STA	SECONDS
	STA	MINUTES
	STA	HOURS
	RTS

DISPLAY_INTRO_SCREEN:
	JSR	GREEN_SCREEN
	;first do text part
	LDA	#<INTRO_TEXT
	STA	SOURCE_L
	LDA	#>INTRO_TEXT
	STA	SOURCE_H
	LDA	#00
	STA	EVENODD
	JSR	DECOMPRESS_SCREEN	;Decompress text characters
	;now enable graphics on layer 0
	LDA	$9F29
	ORA	#%00010000
	STA	$9F29	;enable layer 0
	LDA	#6
	STA	$9F2D	;set layer 0 to bitmap mode 4BPP
	LDA	#16
	STA	$9F2F	;set base address for bitmap
	RTS

DISPLAY_ENDGAME_SCREEN:
	JSR	GREEN_SCREEN	;set monochrome screen for now.
	LDA	#<SCR_ENDGAME
	STA	SOURCE_L
	LDA	#>SCR_ENDGAME
	STA	SOURCE_H
	LDA	#00
	STA	EVENODD
	JSR	DECOMPRESS_SCREEN	;Decompress text characters
	;display map name
	LDA	#%00100000
	STA	VERA_H
	LDA	#7
	STA	VERA_M
	LDA	#44
	STA	VERA_L
	JSR	CALC_MAP_NAME
DEG3:	LDA	($02),Y
	STA	VERA_DATA
	INY
	CPY	#16
	BNE	DEG3
	;display elapsed time
	LDA	HOURS
	STA	DECNUM
	LDA	#9
	STA	VERA_M
	LDA	#42
	STA	VERA_L
	JSR	DECWRITE
	LDA	MINUTES
	STA	DECNUM
	JSR	DECWRITE
	LDA	SECONDS
	STA	DECNUM
	JSR	DECWRITE
	LDA	#9
	STA	VERA_M
	LDA	#42
	STA	VERA_L
	LDA	#32	;SPACE
	STA	VERA_DATA
	LDA	#48
	STA	VERA_L
	LDA	#58	;COLON
	STA	VERA_DATA
	LDA	#54
	STA	VERA_L
	LDA	#58	;COLON
	STA	VERA_DATA

	;count robots remaining
	LDX	#1
	LDA	#0
	STA	DECNUM
DEG7:	LDA	UNIT_TYPE,X
	CMP	#0
	BEQ	DEG8
	INC	DECNUM
DEG8:	INX
	CPX	#28
	BNE	DEG7
	LDA	#11
	STA	VERA_M
	LDA	#44
	STA	VERA_L
	JSR	DECWRITE
	;Count secrets remaining
	LDA	#0
	STA	DECNUM
	LDX	#48
DEG9:	LDA	UNIT_TYPE,X
	CMP	#0
	BEQ	DEG10
	INC	DECNUM
DEG10:	INX
	CPX	#64
	BNE	DEG9
	LDA	#13
	STA	VERA_M
	LDA	#44
	STA	VERA_L
	JSR	DECWRITE
	;display difficulty level
	LDA	#15
	STA	VERA_M
	LDA	#44
	STA	VERA_L
	LDY	DIFF_LEVEL
	LDA	DIFF_LEVEL_LEN,Y
	TAY
	LDX	#0
DEG11:	LDA	DIFF_LEVEL_WORDS,Y
	CMP	#0
	BEQ	DEG12
	STA	VERA_DATA
	INY
	INX
	JMP	DEG11
DEG12:	RTS

DIFF_LEVEL_WORDS:
	!SCR "easy",0,"normal",0,"hard",0
DIFF_LEVEL_LEN:
	!BYTE 0,5,12

DECOMPRESS_SCREEN:
	LDA	#00
	STA	VERA_M
	STA	DECOMPRESS_X
	STA	DECOMPRESS_Y
	LDA	#%00100000	;increment by 2
	STA	VERA_H
	LDA	EVENODD
	STA	VERA_L
	LDY	#0
DECON5:	LDA	(SOURCE_L),Y
	CMP	#96	;REPEAT FLAG
	BEQ	DECON8
	;STANDARD DATA COPY
	STA	VERA_DATA
	JSR	INC_SOURCE
	JSR	INC_DEST
	LDA	DECOMPRESS_Y
	CMP	#30	;has it reached line 30 yet?
	BNE	DECON5
DECON6:	RTS
DECON8:	;REPEAT SETUP
	JSR	INC_SOURCE
	LDA	(SOURCE_L),Y
	STA	REPEAT_CHAR
	JSR	INC_SOURCE
	LDA	(SOURCE_L),Y
	TAX
	INX
	JSR	INC_SOURCE
	;PERFORM REPEAT
DECON9:	LDA	REPEAT_CHAR
	STA	VERA_DATA
	JSR	INC_DEST
	LDA	DECOMPRESS_Y
	CMP	#30	;has it reached line 25 yet?
	BEQ	DECON6
	DEX
	CPX	#00
	BNE	DECON9
	JMP	DECON5
INC_SOURCE:
	LDA	SOURCE_L
	CLC
	ADC	#01
	STA	SOURCE_L
	LDA	SOURCE_H
	ADC	#00
	STA	SOURCE_H
	RTS
INC_DEST:
	INC	DECOMPRESS_X
	LDA	DECOMPRESS_X
	CMP	#40
	BNE	INDE5
	INC	VERA_M
	LDA	EVENODD
	STA	VERA_L
	LDA	#0
	STA	DECOMPRESS_X
	INC	DECOMPRESS_Y
INDE5:	RTS

DECOMPRESS_X	!BYTE 00	;keeps track of horizontal progress
DECOMPRESS_Y	!BYTE 00	;keeps track of vertica progress
REPEAT_CHAR	!BYTE 00	;what character are we repeating?
EVENODD		!BYTE 00	;0=even (text) 1=odd (color

DISPLAY_PLAYER_HEALTH:
	LDA	#%00100000
	STA	VERA_H
	LDA	#27
	STA	VERA_M
	LDA	#68
	STA	VERA_L
	LDA	UNIT_HEALTH	;No index needed because it is the player
	LSR			;divide by two
	STA	TEMP_A
	LDY	#00
DPH01:	CPY	TEMP_A
	BEQ	DPH02
	LDA	#$66		;GRAY BLOCK
	STA	VERA_DATA
	INY
	JMP	DPH01
DPH02:	LDA	UNIT_HEALTH
	AND	#%00000001
	CMP	#%00000001
	BNE	DPH03
	LDA	#$5C		;HALF GRAY BLOCK
	STA	VERA_DATA
	INY
DPH03:	CPY	#6
	BEQ	DPH04
	LDA	#$20		;SPACE
	STA	VERA_DATA
	INY
	JMP	DPH03
DPH04:
;	RTS
	; experimental - make music playback speed up when near death
	LDX UNIT_HEALTH
	LDA #0
	CPX #10
	BCS DPH05 ; Speed = 0 (normal) Health = 10-12
	INC
	CPX #7
	BCS DPH05 ; Speed = 1 Health = 7-9
	INC
	CPX #4
	BCS DPH05 ; Speed = 2 Health = 4-6
	INC ; Speed = 3 Health = 0-3
DPH05:
	JSR CHANGE_MUSIC_SPEED
	RTS

CYCLE_ITEM:
	LDA	#SFX_CYCLEITEM		;CHANGE-ITEM-SOUND
	JSR	PLAY_DIGI_SOUND	;SOUND PLAY
	LDA	#20
	STA	KEYTIMER
	INC	SELECTED_ITEM
	LDA	SELECTED_ITEM
	CMP	#5
	BEQ	CYIT1
	JMP	DISPLAY_ITEM
CYIT1:	LDA	#0
	STA	SELECTED_ITEM
	JMP	DISPLAY_ITEM

DISPLAY_ITEM:
	JSR	PRESELECT_ITEM
DSIT00:	LDA	SELECTED_ITEM
	CMP	#0	;no items to show
	BNE	DSIT01
	;add routine to draw blank space
	RTS
DSIT01:	CMP	#5	;number too high!
	BNE	DSIT0A
	LDA	#0
	STA	SELECTED_ITEM
	RTS
DSIT0A:	CMP	#1	;bomb
	BNE	DSIT03
	LDA	INV_BOMBS
	CMP	#0	;did we run out?
	BNE	DSIT02
	INC	SELECTED_ITEM
	JMP	DSIT00
DSIT02:	JSR	DISPLAY_TIMEBOMB
	RTS
DSIT03:	CMP	#2	;emp
	BNE	DSIT05
	LDA	INV_EMP
	CMP	#0	;did we run out?
	BNE	DSIT04
	INC	SELECTED_ITEM
	JMP	DSIT00
DSIT04:	JSR	DISPLAY_EMP
	RTS
DSIT05:	CMP	#3	;medkit
	BNE	DSIT07
	LDA	INV_MEDKIT
	CMP	#0	;did we run out?
	BNE	DSIT06
	INC	SELECTED_ITEM
	JMP	DSIT00
DSIT06:	JSR	DISPLAY_MEDKIT
	RTS
DSIT07:	CMP	#4	;magnet
	BNE	DSIT09
	LDA	INV_MAGNET
	CMP	#0	;did we run out?
	BNE	DSIT08
	INC	SELECTED_ITEM
	JMP	DSIT09
DSIT08:	JSR	DISPLAY_MAGNET
	RTS
DSIT09:	LDA	#0
	STA	SELECTED_ITEM
	JSR	PRESELECT_ITEM
	JMP	DISPLAY_ITEM

;This routine checks to see if currently selected
;item is zero.  And if it is, then it checks inventories
;of other items to decide which item to automatically
;select for the user.
PRESELECT_ITEM:
	LDA	SELECTED_ITEM
	CMP	#0		;If item already selected, return
	BEQ	PRSI01
	RTS
PRSI01:	LDA	INV_BOMBS
	CMP	#0
	BEQ	PRSI02
	LDA	#1	;BOMB
	STA	SELECTED_ITEM
	RTS
PRSI02:	LDA	INV_EMP
	CMP	#0
	BEQ	PRSI03
	LDA	#2	;EMP
	STA	SELECTED_ITEM
	RTS
PRSI03:	LDA	INV_MEDKIT
	CMP	#0
	BEQ	PRSI04
	LDA	#3	;MEDKIT
	STA	SELECTED_ITEM
	RTS
PRSI04:	LDA	INV_MAGNET
	CMP	#0
	BEQ	PRSI05
	LDA	#4	;MAGNET
	STA	SELECTED_ITEM
	RTS
PRSI05:	;Nothing found in inventory at this point, so set
	;selected-item to zero.
	LDA	#0	;nothing in inventory
	STA	SELECTED_ITEM
	JSR	DISPLAY_BLANK_ITEM
	RTS

DISPLAY_TIMEBOMB:
	LDA	#%00010001
	STA	VERA_H
	LDA	#$FC
	STA	VERA_M
	LDA	#08	;sprite addresss high
	STA	VERA_L
	LDA	#160
	STA	VERA_DATA
	LDA	#14	;sprite z-depth
	STA	VERA_L
	LDA	#%00001100	;enable sprite
	STA	VERA_DATA
	;display QTY
	LDA	INV_BOMBS
	STA	DECNUM
	LDA	#74
	STA	VERA_L
	LDA	#18
	STA	VERA_M
	JSR	DECWRITE
	RTS

DISPLAY_EMP:
	LDA	#%00010001
	STA	VERA_H
	LDA	#$FC
	STA	VERA_M
	LDA	#08	;sprite addresss high
	STA	VERA_L
	LDA	#96
	STA	VERA_DATA
	LDA	#14	;sprite z-depth
	STA	VERA_L
	LDA	#%00001100	;enable sprite
	STA	VERA_DATA
	;display QTY
	LDA	INV_EMP
	STA	DECNUM
	LDA	#74
	STA	VERA_L
	LDA	#18
	STA	VERA_M
	JSR	DECWRITE
	RTS

DISPLAY_MEDKIT:
	LDA	#%00010001
	STA	VERA_H
	LDA	#$FC
	STA	VERA_M
	LDA	#08	;sprite addresss high
	STA	VERA_L
	LDA	#64
	STA	VERA_DATA
	LDA	#14	;sprite z-depth
	STA	VERA_L
	LDA	#%00001100	;enable sprite
	STA	VERA_DATA
	;display QTY
	LDA	INV_MEDKIT
	STA	DECNUM
	LDA	#74
	STA	VERA_L
	LDA	#18
	STA	VERA_M
	JSR	DECWRITE
	RTS

DISPLAY_MAGNET:
	LDA	#%00010001
	STA	VERA_H
	LDA	#$FC
	STA	VERA_M
	LDA	#08	;sprite addresss high
	STA	VERA_L
	LDA	#128
	STA	VERA_DATA
	LDA	#14	;sprite z-depth
	STA	VERA_L
	LDA	#%00001100	;enable sprite
	STA	VERA_DATA
	;display QTY
	LDA	INV_MAGNET
	STA	DECNUM
	LDA	#74
	STA	VERA_L
	LDA	#18
	STA	VERA_M
	JSR	DECWRITE
	RTS

DISPLAY_BLANK_ITEM:
	;disable sprite
	LDA	#%0010001
	STA	VERA_H
	LDA	#$FC
	STA	VERA_M
	LDA	#14	;sprite z-depth
	STA	VERA_L
	LDA	#%00000000	;DISABLE sprite
	STA	VERA_DATA
	;erase quantity from screen
	LDA	#%00100000
	STA	VERA_H
	LDA	#74
	STA	VERA_L
	LDA	#12
	STA	VERA_M
	LDA	#32
	STA	VERA_DATA
	STA	VERA_DATA
	STA	VERA_DATA
	RTS

CYCLE_WEAPON:
	LDA	#SFX_CYCLEWEAPON		;CHANGE WEAPON-SOUND
	JSR	PLAY_DIGI_SOUND	;SOUND PLAY
	LDA	#20
	STA	KEYTIMER
	INC	SELECTED_WEAPON
	LDA	SELECTED_WEAPON
	CMP	#2
	BNE	CYWE1
	JMP	DISPLAY_WEAPON
CYWE1:	LDA	#0
	STA	SELECTED_WEAPON
	JMP	DISPLAY_WEAPON

DISPLAY_WEAPON:
	JSR	PRESELECT_WEAPON
	LDA	SELECTED_WEAPON
	CMP	#0	;no weapon to show
	BNE	DSWP01
	;add routine to draw blank space
	RTS
DSWP01:	CMP	#1	;PISTOL
	BNE	DSWP03
	LDA	AMMO_PISTOL
	CMP	#0	;did we run out?
	BNE	DSWP02
	LDA	#0
	STA	SELECTED_WEAPON
	JMP	DISPLAY_WEAPON
DSWP02:	JSR	DISPLAY_PISTOL
	RTS
DSWP03:	CMP	#2	;PLASMA GUN
	BNE	DSWP05
	LDA	AMMO_PLASMA
	CMP	#0	;did we run out?
	BNE	DSWP04
	LDA	#0
	STA	SELECTED_WEAPON
	JMP	DISPLAY_WEAPON
DSWP04:	JSR	DISPLAY_PLASMA_GUN
	RTS
DSWP05:	LDA	#0
	STA	SELECTED_WEAPON	;should never happen
	JMP	DISPLAY_WEAPON

;This routine checks to see if currently selected
;weapon is zero.  And if it is, then it checks inventories
;of other weapons to decide which item to automatically
;select for the user.
PRESELECT_WEAPON:
	LDA	SELECTED_WEAPON
	CMP	#0		;If item already selected, return
	BEQ	PRSW01
	RTS
PRSW01:	LDA	AMMO_PISTOL
	CMP	#0
	BEQ	PRSW02
	LDA	#1	;PISTOL
	STA	SELECTED_WEAPON
	RTS
PRSW02:	LDA	AMMO_PLASMA
	CMP	#0
	BEQ	PRSW04
	LDA	#2	;PLASMAGUN
	STA	SELECTED_WEAPON
	RTS
PRSW04:	;Nothing found in inventory at this point, so set
	;selected-item to zero.
	LDA	#0	;nothing in inventory
	STA	SELECTED_WEAPON
	JSR	DISPLAY_BLANK_WEAPON
	RTS

DISPLAY_PLASMA_GUN:
	LDA	#%00010001
	STA	VERA_H
	LDA	#$FC
	STA	VERA_M
	LDA	#0	;sprite addresss high
	STA	VERA_L
	LDA	#32
	STA	VERA_DATA
	LDA	#06	;sprite z-depth
	STA	VERA_L
	LDA	#%00001100	;enable sprite
	STA	VERA_DATA
	;display ammo
DPG4:	LDA	AMMO_PLASMA
	STA	DECNUM
	STA	DECNUM
	LDA	#74
	STA	VERA_L
	LDA	#7
	STA	VERA_M
	JSR	DECWRITE
	RTS

DISPLAY_PISTOL:
	LDA	#%00010001
	STA	VERA_H
	LDA	#$FC
	STA	VERA_M
	LDA	#00	;sprite addresss high
	STA	VERA_L
	LDA	#00
	STA	VERA_DATA
	LDA	#06	;sprite z-depth
	STA	VERA_L
	LDA	#%00001100	;enable sprite
	STA	VERA_DATA
	;display ammo
	LDA	AMMO_PISTOL
	STA	DECNUM
	LDA	#74
	STA	VERA_L
	LDA	#7
	STA	VERA_M
	JSR	DECWRITE
	RTS

DISPLAY_BLANK_WEAPON:
	;DISABLE SPRITE
	LDA	#%00010001
	STA	VERA_H
	LDA	#$FC
	STA	VERA_M
	LDA	#06	;sprite z-depth
	STA	VERA_L
	LDA	#%00000000	;disable sprite
	STA	VERA_DATA
	;ERASE QUANTITY FROM SCREEN
	LDA	#%00100000
	STA	VERA_H
	LDA	#74
	STA	VERA_L
	LDA	#5
	STA	VERA_M
	LDA	#32
	STA	VERA_DATA
	STA	VERA_DATA
	STA	VERA_DATA
	RTS

DISPLAY_KEYS:
	;ERASE ALL 3 SPOTS
	LDX	#%00010000
	STX	VERA_H
	LDX	#24
	STX	VERA_M
	LDX	#68
	STX	VERA_L
	LDA	#32
	STA	VERA_DATA	;TEXT
	LDX	#02	;RED
	STX	VERA_DATA	;COLOR
	STA	VERA_DATA	;TEXT
	STX	VERA_DATA	;COLOR
	STA	VERA_DATA	;TEXT
	LDX	#05	;GREEN
	STX	VERA_DATA	;COLOR
	STA	VERA_DATA	;TEXT
	STX	VERA_DATA	;COLOR	
	STA	VERA_DATA	;TEXT
	LDX	#06	;BLUE
	STX	VERA_DATA	;COLOR
	STA	VERA_DATA	;TEXT
	STX	VERA_DATA	;COLOR
	LDX	#25
	STX	VERA_M
	LDX	#68
	STX	VERA_L
	STA	VERA_DATA	;TEXT
	LDX	#02	;RED
	STX	VERA_DATA	;COLOR
	STA	VERA_DATA	;TEXT
	STX	VERA_DATA	;COLOR
	STA	VERA_DATA	;TEXT
	LDX	#05	;GREEN
	STX	VERA_DATA	;COLOR
	STA	VERA_DATA	;TEXT
	STX	VERA_DATA	;COLOR	
	STA	VERA_DATA	;TEXT
	LDX	#06	;BLUE
	STX	VERA_DATA	;COLOR
	STA	VERA_DATA	;TEXT
	STX	VERA_DATA	;COLOR
	LDX	#%00100000
	STX	VERA_H
	;DRAW KEYS
	LDA	KEYS
	AND	#%00000001
	CMP	#%00000001	;Spade key
	BNE	DKS1
	LDX	#24
	STX	VERA_M
	LDX	#68
	STX	VERA_L
	LDA	#$63
	STA	VERA_DATA
	LDA	#$4D
	STA	VERA_DATA
	LDX	#25
	STX	VERA_M
	LDX	#68
	STX	VERA_L
	LDA	#$41
	STA	VERA_DATA
	LDA	#$67
	STA	VERA_DATA
DKS1:	LDA	KEYS
	AND	#%00000010
	CMP	#%00000010	;heart key
	BNE	DKS2
	LDX	#24
	STX	VERA_M
	LDX	#72
	STX	VERA_L
	LDA	#$63
	STA	VERA_DATA
	LDA	#$4D
	STA	VERA_DATA
	LDX	#25
	STX	VERA_M
	LDX	#72
	STX	VERA_L
	LDA	#$53
	STA	VERA_DATA
	LDA	#$67
	STA	VERA_DATA
DKS2:	LDA	KEYS
	AND	#%00000100
	CMP	#%00000100	;star key
	BNE	DKS3
	LDX	#24
	STX	VERA_M
	LDX	#76
	STX	VERA_L
	LDA	#$63
	STA	VERA_DATA
	LDA	#$4D
	STA	VERA_DATA
	LDX	#25
	STX	VERA_M
	LDX	#76
	STX	VERA_L
	LDA	#$2A
	STA	VERA_DATA
	LDA	#$67
	STA	VERA_DATA
DKS3:	RTS

GAME_OVER:
	;stop game clock
	LDA	#0
	STA	CLOCK_ACTIVE
	JSR STOP_MUSIC
	;Did player die or win?
	LDA	UNIT_TYPE
	CMP	#0
	BNE	GOM0
	LDA	#12
	STA	PLAYER_DIRECTION
	LDA	#0
	STA	PLAYER_ANIMATE
	JSR	DISPLAY_PLAYER_SPRITE
	LDA	#100
	STA	KEYTIMER
GOM0:	JSR	BACKGROUND_TASKS
	LDA	KEYTIMER
	CMP	#0
	BNE	GOM0
	;stop screen shake
	LDA	#0
	STA	SCREEN_SHAKE
	;display game over message
	LDA	#%00010000
	STA	VERA_H
	;FIRST ROW
	LDA	#22
	STA	VERA_L
	LDA	#9
	STA	VERA_M
	LDX	#0
GOM1:	LDA	GAMEOVER1,X
	STA	VERA_DATA
	LDA	#01	;COLOR WHITE
	STA	VERA_DATA
	INX
	CPX	#11
	BNE	GOM1
	;SECOND ROW
	LDA	#22
	STA	VERA_L
	LDA	#10
	STA	VERA_M
	LDX	#0
GOM1A:	LDA	GAMEOVER2,X
	STA	VERA_DATA
	LDA	#01	;COLOR WHITE
	STA	VERA_DATA
	INX
	CPX	#11
	BNE	GOM1A
	;SECOND ROW
	LDA	#22
	STA	VERA_L
	LDA	#11
	STA	VERA_M
	LDX	#0
GOM1B:	LDA	GAMEOVER3,X
	STA	VERA_DATA
	LDA	#01	;COLOR WHITE
	STA	VERA_DATA
	INX
	CPX	#11
	BNE	GOM1B
	LDA	#100
	STA	KEYTIMER
GOM2:	LDA	KEYTIMER
	CMP	#0
	BNE	GOM2
	LDA	#0
	STA	$00C6	;CLEAR KEYBOARD BUFFER
	;WAIT FOR USER INPUT
GOM3:	;CHECK FOR SNES ACTIVITY
	JSR	SNES_CONTROLER_READ
	LDA	NEW_B
	CMP	#1
	BNE	GOM3A
	LDA	#0
	STA	NEW_B
	JMP	GOM4
GOM3A:	;CHECK KEYBOARD
	JSR	$FFE4
	CMP	#$00
	BEQ	GOM3
	;DISPLAY GAME OVER STATS
GOM4:	LDA	$9F29
	AND	#%11101111
	STA	$9F29	;disable layer 0
	LDA	#0
	STA	$00C6	;CLEAR KEYBOARD BUFFER
	JSR STOP_MUSIC
	JSR	DISABLE_SPRITES
	JSR	DISPLAY_ENDGAME_SCREEN
	JSR	DISPLAY_WIN_LOSE
GOM5:	;wait for user input & for music to end
	;LDA MUSIC_PLAYING
	LDA #0   ; comment this out and uncomment above LDA for forced music finish...
	BNE GOM5 ; wait for win/lose music to stop before continuing....
	JSR	$FFE4
	CMP	#$00
	BNE	GOM5 ; clear key buffer before waiting for keypress...
GOM5a:	;CHECK FOR SNES ACTIVITY
	JSR	SNES_CONTROLER_READ
	LDA	NEW_B
	CMP	#1
	BNE	GOM5B
	LDA	#0
	STA	NEW_B
	JMP	GOM6
GOM5B:	;CHECK KEYBOARD NOW
	JSR $FFE4
	CMP #$00
	BEQ GOM5a
GOM6:	LDA	#0
	STA	$009E	;CLEAR KEYBOARD BUFFER
	JMP	INTRO_SCREEN

GAMEOVER1:	!BYTE	$70,$40,$40,$40,$40,$40,$40,$40,$40,$40,$6e
GAMEOVER2:	!BYTE	$5d,$07,$01,$0d,$05,$20,$0f,$16,$05,$12,$5d
GAMEOVER3:	!BYTE	$6d,$40,$40,$40,$40,$40,$40,$40,$40,$40,$7d

DISPLAY_WIN_LOSE:
	JSR	STOP_MUSIC
	LDA #0
	STA MUSIC_SPEED
	LDA	#%00100000
	STA	VERA_H
	LDA	#3
	STA	VERA_M
	LDA	#32
	STA	VERA_L
	LDX	#0
	LDA	UNIT_TYPE
	CMP	#0
	BEQ	DWL5
DWL1:	;WIN MESSAGE
	LDA	WIN_MSG,X
	STA	VERA_DATA
	INX
	CPX	#8
	BNE	DWL1
	LDA	#SONG_WIN	;win music
	JSR	START_MUSIC
	JMP DWL6
DWL5:	;LOSE MESSAGE
	LDA	LOS_MSG,X
	STA	VERA_DATA
	INX
	CPX	#9
	BNE	DWL5
	LDA	#SONG_LOSE	;LOSE music
	JSR	START_MUSIC
DWL6:
	; If dynamic music loading mode is active, and music is enabled, start
	; preloading the main music early while the win/lose music plays, since
	; that music is always loaded and pre-loading the dynamic song will not
	; overwrite it. Music player is on an IRQ so it will continue while the
	; load takes place, concealing the load time from the user as a normal
	; "key press disabled while ditty music plays"
	LDA MUSIC_ENABLED
	AND MUSIC_DYNAMIC_MODE
	BNE DWL7
	RTS
DWL7:
	LDA #SONG_MAIN
	JSR LOAD_DYNAMIC_SONG
	RTS

WIN_MSG:	!SCR"you win!"
LOS_MSG:	!SCR"you lose!"

PRINT_INTRO_MESSAGE:
	LDA	#<INTRO_MESSAGE
	STA	$02
	LDA	#>INTRO_MESSAGE
	STA	$03
	JSR	PRINT_INFO
	RTS

;This routine will print something to the "information" window
;at the bottom left of the screen.  You must first define the
;source of the text in $02. The text should terminate with
;a null character.
PRINT_INFO:
	JSR	SCROLL_INFO	;New text always causes a scroll
	LDY	#0
	STY	PRINTX
	STY	VERA_L
	LDA	#29
	STA	VERA_M
	LDA	#%00100000
	STA	VERA_H
PI01:	LDA	($02),Y
	CMP	#0	;null terminates string
	BNE	PI02
	RTS
PI02:	CMP	#255	;return
	BNE	PI03
PI05:	JSR	SCROLL_INFO
	LDX	#0
	STX	PRINTX
	STX	VERA_L
	LDA	#29
	STA	VERA_M
	JMP	PI04
PI03:	STA	VERA_DATA
	INC	PRINTX
	LDA	PRINTX
	CMP	#34
	BEQ	PI05
PI04:	INY
	JMP	PI01
PRINTX:	!BYTE 00	;used to store X-cursor location

;This routine scrolls the info screen by one row, clearing
;a new row at the bottom.
SCROLL_INFO:
	TYA
	PHA
	LDA	#0
	STA	VERA_L
	LDA	#%00000000
	STA	VERA_H
	LDX	#0
SCI2:	LDY	#28
	STY	VERA_M
	LDA	VERA_DATA
	LDY	#27
	STY	VERA_M
	STA	VERA_DATA
	LDY	#29
	STY	VERA_M
	LDA	VERA_DATA
	LDY	#28
	STY	VERA_M
	STA	VERA_DATA
	INC	VERA_L
	INC	VERA_L
	INX
	CPX	#33
	BNE	SCI2
	;NOW CLEAR BOTTOM ROW
	LDA	#29
	STA	VERA_M
	LDA	#0
	STA	VERA_L
	LDA	#%00100000
	STA	VERA_H
	LDA	#32
	LDX	#0
SCI5:	STA	VERA_DATA
	INX
	CPX	#33
	BNE	SCI5
	PLA
	TAY
	RTS

INTRO_SCREEN:
	JSR	DISPLAY_INTRO_SCREEN
	JSR	DISPLAY_MAP_NAME
	;JSR	CHANGE_DIFFICULTY_LEVEL ;don't show By default on X16
	JSR START_INTRO_SCREEN_MUSIC
	LDA	#0
	STA	MENUY
	;LDA	#$50
	;STA	MENUCOL
	;JSR	FLASH_MENU_OPTION
ISLOOP:	JSR	UPDATE_MENU_FLASH
	;FIRST CHECK SNES CONTROLLER
	JSR	SNES_CONTROLER_READ
	LDA	NEW_UP
	CMP	#1
	BNE	ISS1
	LDA	#0
	STA	NEW_UP
	LDA	#$91	;CURSOR_UP
	JMP	ISS9
ISS1:	LDA	NEW_DOWN
	CMP	#1
	BNE	ISS2
	LDA	#0
	STA	NEW_DOWN
	LDA	#$11	;CURSOR_DOWN
	JMP	ISS9
ISS2:	LDA	NEW_B
	CMP	#1
	BNE	ISS3	
	LDA	#2		;SET SNES PAD TO CURRENT CONTROL
	STA	CONTROL	;SINCE USER IS CLEARLY USING IT.
	LDA	#0
	STA	NEW_B
	LDA	#13	;RETURN
	JMP	ISS9
	;NOW CHECK KEYBOARD
ISS3:	JSR	$FFE4
ISS9:	CMP	#00
	BEQ	ISLOOP
	CMP	#$11	;CURSOR DOWN
	BNE	IS001
IS001A:	LDA	MENUY
	CMP	#3
	BEQ	ISLOOP
	LDA	#$05
	STA	MENUCOL
	JSR	FLASH_MENU_OPTION
	INC	MENUY
	LDA	#SFX_BEEP2		;menu beep
	JSR	PLAY_DIGI_SOUND	;SOUND PLAY
	JMP	ISLOOP
IS001:	CMP	#$91	;CURSOR UP
	BNE	IS002
IS002A:	LDA	MENUY
	CMP	#0
	BEQ	ISLOOP
	LDA	#$05
	STA	MENUCOL
	JSR	FLASH_MENU_OPTION
	DEC	MENUY
	LDA	#SFX_BEEP2		;menu beep
	JSR	PLAY_DIGI_SOUND	;SOUND PLAY
	JMP	ISLOOP
IS002:	CMP	#32	;SPACE
	BNE	IS003
	JMP	EXEC_COMMAND
IS003:	CMP	KEY_MOVE_UP
	BNE	IS004
	JMP	IS002A
IS004:	CMP	KEY_MOVE_DOWN
	BNE	IS005
	JMP	IS001A
IS005:	CMP	#13	;RETURN
	BNE	IS006
	JMP	EXEC_COMMAND
IS006:	CMP	#133	;F1
	BNE	IS007
	JSR	MODE_VGA
	LDA	#SFX_BEEP2		;menu beep
	JSR	PLAY_DIGI_SOUND	;SOUND PLAY
	JMP	ISLOOP
IS007:	CMP	#137	;F2
	BNE	IS008
	JSR	MODE_COMPOSITE
	LDA	#SFX_BEEP2		;menu beep
	JSR	PLAY_DIGI_SOUND	;SOUND PLAY
	JMP	ISLOOP
IS008:	CMP	#134	;F3
	BNE	IS009
	JSR	MODE_RGB
	LDA	#SFX_BEEP2		;menu beep
	JSR	PLAY_DIGI_SOUND	;SOUND PLAY
IS009:	JMP	ISLOOP

EXEC_COMMAND:
	LDA	#SFX_BEEP		;SHORT BEEP
	JSR	PLAY_DIGI_SOUND	;SOUND PLAY
	LDA	MENUY
	CMP	#00	;START GAME
	BNE	EXEC1
	JSR	SET_CONTROLS
	JSR STOP_MUSIC
	;disable graphics on layer 0
	LDA	$9F29
	AND	#%00000111
	ORA	#%01100000
	STA	$9F29	;enable layer 0
	JMP	INIT_GAME
EXEC1:	CMP	#2	;DIFF LEVEL
	BNE	EXEC05
	INC	DIFF_LEVEL
	LDA	DIFF_LEVEL
	CMP	#3
	BNE	EXEC02
	LDA	#0
	STA	DIFF_LEVEL
EXEC02:	JSR	CHANGE_DIFFICULTY_LEVEL
	JMP	ISLOOP
EXEC05:	CMP	#1	;cycle map
	BNE	EXEC06
	JSR	CYCLE_MAP
EXEC06:	CMP	#3
	BNE	EXEC07
	JSR	CYCLE_CONTROLS
EXEC07:	JMP	ISLOOP

CYCLE_CONTROLS:
	LDA	#0
	STA	KEYS_DEFINED
	INC	CONTROL
	LDA	CONTROL
	CMP	#3
	BNE	CCON2
	LDA	#0
	STA	CONTROL
CCON2:	;display control method on screen
	LDA	#%00100000
	STA	VERA_H
	LDA	#05
	STA	VERA_M
	LDA	#08
	STA	VERA_L
	LDY	CONTROL
	LDA	CONTROLSTART,Y
	TAY
	LDX	#0
CCON3:	LDA	CONTROLTEXT,Y
	STA	VERA_DATA
	INX
	INY
	CPX	#10
	BNE	CCON3
	RTS

CONTROLTEXT:	!SCR"keyboard  "
		!SCR"custom key"
		!SCR"snes pad  "
CONTROLSTART:	!BYTE 00,10,20

CYCLE_MAP:
	INC	SELECTED_MAP
	LDA	SELECTED_MAP
	CMP	#14	;MAXIMUM MAP NUMBER
	BNE	CYM1
	LDA	#0
	STA	SELECTED_MAP
CYM1:	JSR	DISPLAY_MAP_NAME
	RTS

DISPLAY_MAP_NAME:
	LDA	#9
	STA	VERA_M
	LDA	#4
	STA	VERA_L
	LDA	#%00100000
	STA	VERA_H
	JSR	CALC_MAP_NAME
DMN1:	LDA	($02),Y
	STA	VERA_DATA
	INY
	CPY	#16
	BNE	DMN1
	;now set the mapname for the filesystem load
	LDA	SELECTED_MAP
	CLC
	ADC	#65
	STA	MAPNAME+6
	RTS

CALC_MAP_NAME:
	;FIND MAP NAME
	LDA	SELECTED_MAP
	STA	$02
	LDA	#0
	STA	$03
	;multiply by 16 by shifting 4 times to left.
	ASL	$02
	ROL	$03
	ASL	$02
	ROL	$03
	ASL	$02
	ROL	$03
	ASL	$02
	ROL	$03
	;now add offset for mapnames
	LDA	$02
	CLC
	ADC	#<MAP_NAMES
	STA	$02
	LDA	$03
	ADC	#>MAP_NAMES
	STA	$03
	LDY	#0
	RTS

UPDATE_MENU_FLASH:
	LDY	SPRITECOLSTATE
	LDA	SPRITECOLCHART,Y
	STA	MENUCOL
	JSR	FLASH_MENU_OPTION
	RTS

FLASH_MENU_OPTION:
	LDA	MENUY
	CLC
	ADC	#02
	STA	VERA_M
	LDA	#9
	STA	VERA_L
	LDA	#%00100000
	STA	VERA_H
	LDA	MENUCOL
	LDX	#0
RMO1:	STA	VERA_DATA
	INX
	CPX	#10
	BNE	RMO1
	RTS
MENUY	!BYTE	$00	;CURRENT MENU SELECTION
MENUCOL	!BYTE	$00	;COLOR TO PAINT MENU LINE.

CHANGE_DIFFICULTY_LEVEL:
	;coordinates of face is 234, 95		
	LDA	#%00010000
	STA	VERA_H
	;let's find our starting point in the data
	;based on the diffulty level, and set it to X
	LDX	DIFF_LEVEL
	LDA	FACE_X_CHART,X
	TAX
	;now draw the face.
	LDY	#0
CDL01:	LDA	FACE_Y_CHART_H,Y
	STA	VERA_M
	LDA	FACE_Y_CHART_L,Y
	STA	VERA_L
	LDA	THREE_FACES,X
	STA	VERA_DATA
	INX
	LDA	THREE_FACES,X
	STA	VERA_DATA
	INX
	LDA	THREE_FACES,X
	STA	VERA_DATA
	INX
	LDA	THREE_FACES,X
	STA	VERA_DATA
	INX
	LDA	THREE_FACES,X
	STA	VERA_DATA
	INX
	LDA	THREE_FACES,X
	STA	VERA_DATA
	INX
	LDA	THREE_FACES,X
	STA	VERA_DATA
	INX
	LDA	THREE_FACES,X
	STA	VERA_DATA
	INX
	INY
	CPY	#10
	BNE	CDL01
	RTS

;This chart contains the high and low values of each of the 10
;lines on the screen where the face starts.

FACE_Y_CHART_H:
	!BYTE	$5B,$5C,$5D,$5D,$5E,$5E,$5F,$60,$60,$61
FACE_Y_CHART_L:
	!BYTE	$D5,$75,$15,$B5,$55,$F5,$95,$35,$D5,$75
FACE_X_CHART:
	!BYTE	0,80,160

DIFF_LEVEL	!BYTE 1

;This routine is run after the map is loaded, but before the
;game starts.  If the diffulcty is set to normal, nothing
;actually happens.  But if it is set to easy or hard, then
;some changes occur accordingly.
SET_DIFF_LEVEL:
	LDA	DIFF_LEVEL
	CMP	#0	;easy
	BNE	SDLE1
	JMP	SET_DIFF_EASY
SDLE1:	CMP	#2	;hard
	BNE	SDLE2
	JMP	SET_DIFF_HARD
SDLE2:	RTS

SET_DIFF_EASY:
	;Find all hidden items and double the quantity.
	LDX	#48
SDE1:	LDA	UNIT_TYPE,X
	CMP	#0
	BEQ	SDE2
	CMP	#128	;KEY
	BEQ	SDE2
	ASL	UNIT_A,X	;item qty
SDE2:	INX
	CPX	#64
	BNE	SDE1
	RTS

SET_DIFF_HARD:
	;Find all hoverbots and change AI
	LDX	#0
SDH1:	LDA	UNIT_TYPE,X
	CMP	#2	;hoverbot left/right
	BEQ	SDH4
	CMP	#3	;hoverbot up/down
	BEQ	SDH4
SDH2:	INX
	CPX	#28
	BNE	SDH1
	RTS
SDH4:	LDA	#4	;hoverbot attack mode
	STA	UNIT_TYPE,X
	JMP	SDH2

;This chart used to determine where to set the VERA
;registers to plot a tile.
MAP_CHART_L:
	!BYTE 00,06,12,18,24,30,36,42,48,54,60
MAP_CHART_H
	!BYTE 02,05,08,11,14,17,20

;This routine animates the tile #204 (water)
;and also tile 148 (trash compactor)
;And also the HVAC fan
ANIMATE_WATER:
	LDA	ANIMATE
	CMP	#1
	BEQ	AW00
	RTS
AW00:	INC	WATER_TIMER
	LDA	WATER_TIMER
	CMP	#20
	BEQ	AW01
	RTS
AW01:	LDA	#0
	STA	WATER_TIMER

	LDA	TILE_DATA_BR+204
	STA	WATER_TEMP1
	LDA	TILE_DATA_MM+204
	STA	TILE_DATA_BR+204
	STA	TILE_DATA_BR+221
	LDA	TILE_DATA_TL+204
	STA	TILE_DATA_MM+204
	LDA	WATER_TEMP1
	STA	TILE_DATA_TL+204

	LDA	TILE_DATA_BL+204
	STA	WATER_TEMP1
	LDA	TILE_DATA_MR+204
	STA	TILE_DATA_BL+204
	STA	TILE_DATA_BL+221
	LDA	TILE_DATA_TM+204
	STA	TILE_DATA_MR+204
	LDA	WATER_TEMP1
	STA	TILE_DATA_TM+204
	STA	TILE_DATA_TM+221

	LDA	TILE_DATA_BM+204
	STA	WATER_TEMP1
	LDA	TILE_DATA_ML+204
	STA	TILE_DATA_BM+204
	STA	TILE_DATA_BM+221
	LDA	TILE_DATA_TR+204
	STA	TILE_DATA_ML+204
	LDA	WATER_TEMP1
	STA	TILE_DATA_TR+204
	STA	TILE_DATA_TR+221

	;now do trash compactor
TRSAN1:	LDA	TILE_COLOR_TR+148
	STA	WATER_TEMP1
	LDA	TILE_COLOR_TM+148
	STA	TILE_COLOR_TR+148
	LDA	TILE_COLOR_TL+148
	STA	TILE_COLOR_TM+148
	LDA	WATER_TEMP1
	STA	TILE_COLOR_TL+148

	LDA	TILE_COLOR_MR+148
	STA	WATER_TEMP1
	LDA	TILE_COLOR_MM+148
	STA	TILE_COLOR_MR+148
	LDA	TILE_COLOR_ML+148
	STA	TILE_COLOR_MM+148
	LDA	WATER_TEMP1
	STA	TILE_COLOR_ML+148

	LDA	TILE_COLOR_BR+148
	STA	WATER_TEMP1
	LDA	TILE_COLOR_BM+148
	STA	TILE_COLOR_BR+148
	LDA	TILE_COLOR_BL+148
	STA	TILE_COLOR_BM+148
	LDA	WATER_TEMP1
	STA	TILE_COLOR_BL+148
	JMP	HVAC0


	;Now do HVAC fan
HVAC0:	LDA	HVAC_STATE
	CMP	#0
	BEQ	HVAC1
	LDA	#$CD
	STA	TILE_DATA_MM+196
	STA	TILE_DATA_TL+201
	LDA	#$CE
	STA	TILE_DATA_ML+197
	STA	TILE_DATA_TM+200
	LDA	#$A0
	STA	TILE_DATA_MR+196
	STA	TILE_DATA_BM+196
	STA	TILE_DATA_BL+197
	STA	TILE_DATA_TR+200
	LDA	#0
	STA	HVAC_STATE
	JMP	HVAC2
HVAC1:
	LDA	#$A0
	STA	TILE_DATA_MM+196
	STA	TILE_DATA_TL+201
	STA	TILE_DATA_ML+197
	STA	TILE_DATA_TM+200
	LDA	#$C2
	STA	TILE_DATA_MR+196
	STA	TILE_DATA_TR+200
	LDA	#$C0
	STA	TILE_DATA_BM+196
	STA	TILE_DATA_BL+197
	LDA	#1
	STA	HVAC_STATE
HVAC2:	;now do cinema screen tiles
	;FIRST COPY OLD LETTERS TO THE LEFT.
	LDA	TILE_DATA_MR+20	;#2
	STA	TILE_DATA_MM+20	;#1
	LDA	TILE_DATA_ML+21	;#3
	STA	TILE_DATA_MR+20	;#2
	LDA	TILE_DATA_MM+21	;#4
	STA	TILE_DATA_ML+21	;#3
	LDA	TILE_DATA_MR+21	;#5
	STA	TILE_DATA_MM+21	;#4
	LDA	TILE_DATA_ML+22	;#6
	STA	TILE_DATA_MR+21	;#5
	;now insert new character.
	LDY	CINEMA_STATE
	LDA	CINEMA_MESSAGE,Y
	STA	TILE_DATA_ML+22	;#6

	INC	CINEMA_STATE
	LDA	CINEMA_STATE
	CMP	#197
	BNE	CINE2
	LDA	#0
	STA	CINEMA_STATE
CINE2:	;Now animate light on server computers
	LDA	TILE_DATA_MR+143
	CMP	#$D7
	BNE	CINE3
	LDA	#$D1
	JMP	CINE4
CINE3:	LDA	#$D7
CINE4:	STA	TILE_DATA_MR+143
	LDA	#1
	STA	REDRAW_WINDOW
	RTS

WATER_TIMER	!BYTE 00
WATER_TEMP1	!BYTE 00
HVAC_STATE	!BYTE 00
CINEMA_STATE	!BYTE 00

;This is the routine that allows a person to select
;a level and highlights the selection in the information
;display. It is unique to each computer since it writes
;to the screen directly.
ELEVATOR_SELECT:
	JSR	DRAW_MAP_WINDOW
	LDX	UNIT
	LDA	UNIT_D,X	;get max levels
	STA	ELEVATOR_MAX_FLOOR
	;Now draw available levels on screen
	LDY	#0
	LDA	#29
	STA	VERA_M
	LDA	#14
	STA	VERA_L
	LDA	#%00100000
	STA	VERA_H
ELS1:	TYA
	CLC
	ADC	#$31
	STA	VERA_DATA
	INY
	CPY	ELEVATOR_MAX_FLOOR
	BNE	ELS1
	LDA	UNIT_C,X		;what level are we on now?
	STA	ELEVATOR_CURRENT_FLOOR
	;Now highlight current level
	LDA	#$50
	STA	MENUCOL
	JSR	ELEVATOR_INVERT
	;Now get user input
	LDA	CONTROL
	CMP	#2
	BNE	ELS5
	JMP	SELS5
ELS5:	;KEYBOARD INPUT
	JSR	$FFE4
	CMP	#$00
	BEQ	ELS5
	CMP	KEY_MOVE_LEFT
	BNE	ELS6
	JSR	ELEVATOR_DEC
	JMP	ELS5
ELS6:	CMP	KEY_MOVE_RIGHT
	BNE	ELS7
	JSR	ELEVATOR_INC
	JMP	ELS5
ELS7:	CMP	#$9D	;CURSOR LEFT
	BNE	ELS8
	JSR	ELEVATOR_DEC
	JMP	ELS5
ELS8:	CMP	#$1D	;CURSOR RIGHT
	BNE	ELS9
	JSR	ELEVATOR_INC
	JMP	ELS5
ELS9:	CMP	#$11	;CURSOR DOWN
	BNE	ELS10
ELS9B:	LDA	#$05
	STA	MENUCOL
	JSR	ELEVATOR_INVERT
	JSR	SCROLL_INFO
	JSR	SCROLL_INFO
	JSR	SCROLL_INFO
	JSR	CLEAR_KEY_BUFFER
	RTS
ELS10:	CMP	KEY_MOVE_DOWN
	BEQ	ELS9B
ELS11:	JMP	ELS5
SELS5:	;SNES INPUT
	JSR	SNES_CONTROLER_READ
	LDA	NEW_LEFT
	CMP	#1
	BNE	SELS8
	JSR	ELEVATOR_DEC
	LDA	#0
	STA	NEW_LEFT
	JMP	SELS5
SELS8:	LDA	NEW_RIGHT
	CMP	#1
	BNE	SELS9
	JSR	ELEVATOR_INC
	LDA	#0
	STA	NEW_RIGHT
	JMP	SELS5
SELS9:	LDA	NEW_DOWN
	CMP	#1
	BNE	SELS10
	JSR	SCROLL_INFO
	JSR	SCROLL_INFO
	JSR	SCROLL_INFO
	LDA	#15
	STA	KEYTIMER
	LDA	#0
	STA	NEW_DOWN
	RTS
SELS10:	JMP	SELS5

ELEVATOR_MAX_FLOOR	!BYTE 00
ELEVATOR_CURRENT_FLOOR	!BYTE 00

ELEVATOR_INVERT:
	LDA	#%00100000
	STA	VERA_H
	LDA	#29
	STA	VERA_M
	LDA	ELEVATOR_CURRENT_FLOOR
	ASL
	CLC
	ADC	#13
	STA	VERA_L
	LDA	MENUCOL
	STA	VERA_DATA
	RTS
ELEVATOR_INC:
	LDA	ELEVATOR_CURRENT_FLOOR
	CMP	ELEVATOR_MAX_FLOOR
	BNE	ELVIN1
	RTS
ELVIN1:	LDA	#$05
	STA	MENUCOL
	JSR	ELEVATOR_INVERT
	INC	ELEVATOR_CURRENT_FLOOR
	LDA	#$50
	STA	MENUCOL
	JSR	ELEVATOR_INVERT
	JSR	ELEVATOR_FIND_XY
	RTS
ELEVATOR_DEC:
	LDA	ELEVATOR_CURRENT_FLOOR
	CMP	#1
	BNE	ELVDE1
	RTS
ELVDE1:	LDA	#$05
	STA	MENUCOL
	JSR	ELEVATOR_INVERT
	DEC	ELEVATOR_CURRENT_FLOOR
	LDA	#$50
	STA	MENUCOL
	JSR	ELEVATOR_INVERT
	JSR	ELEVATOR_FIND_XY
	RTS

ELEVATOR_FIND_XY:
	LDX	#32	;start of doors
ELXY1:	LDA	UNIT_TYPE,X
	CMP	#19	;elevator
	BNE	ELXY5
	LDA	UNIT_C,X
	CMP	ELEVATOR_CURRENT_FLOOR
	BNE	ELXY5
	JMP	ELXY10
ELXY5:	INX
	CPX	#48
	BNE	ELXY1
	RTS
ELXY10:	LDA	UNIT_LOC_X,X	;new elevator location
	STA	UNIT_LOC_X	;player location
	SEC
	SBC	#5
	STA	MAP_WINDOW_X
	LDA	UNIT_LOC_Y,X	;new elevator location
	STA	UNIT_LOC_Y	;player location
	DEC	UNIT_LOC_Y
	SEC
	SBC	#4
	STA	MAP_WINDOW_Y
	JSR	DRAW_MAP_WINDOW
	LDA	#SFX_BEEP2		;elevator sound (menu beep)
	JSR	PLAY_DIGI_SOUND	;SOUND PLAY
	RTS

SET_CONTROLS:
	LDA	CONTROL
	CMP	#1	;CUSTOM KEYS
	BNE	SETC1
	JSR	SET_CUSTOM_KEYS
	RTS
SETC1:	;load standard values for key controls
	LDY	#0
SETC2:	LDA	STANDARD_CONTROLS,Y
	STA	KEY_MOVE_UP,Y
	INY
	CPY	#13
	BNE	SETC2
	RTS

STANDARD_CONTROLS:
	!BYTE	73	;MOVE UP
	!BYTE	75	;MOVE DOWN
	!BYTE	74	;MOVE LEFT
	!BYTE	76	;MOVE RIGHT
	!BYTE	87	;FIRE UP
	!BYTE	83	;FIRE DOWN
	!BYTE	65	;FIRE LEFT
	!BYTE	68	;FIRE RIGHT
	!BYTE	133	;CYCLE WEAPONS
	!BYTE	134	;CYCLE ITEMS
	!BYTE	32	;USE ITEM
	!BYTE	90	;SEARCH OBEJCT
	!BYTE	77	;MOVE OBJECT

SET_CUSTOM_KEYS:
	LDA	KEYS_DEFINED
	CMP	#0
	BEQ	SCK00
	RTS
SCK00:	LDA	$9F29
	AND	#%11101111
	STA	$9F29	;disable layer 0
	JSR	GREEN_SCREEN	;set entire screen to monochrome
	LDA	#<SCR_CUSTOM_KEYS
	STA	SOURCE_L
	LDA	#>SCR_CUSTOM_KEYS
	STA	SOURCE_H
	LDA	#00
	STA	EVENODD
	JSR	DECOMPRESS_SCREEN	;Decompress text characters
	;GET KEYS FROM USER
	LDA	#0
	STA	TEMP_A
	LDA	#%00100000
	STA	VERA_H
	LDA	#08
	STA	VERA_M
	LDA	#32
	STA	VERA_L
SCK01:	JSR	$FFE4
	CMP	#00
	BEQ	SCK01
	LDY	TEMP_A
	STA	KEY_MOVE_UP,Y
	STA	DECNUM
	JSR	DECWRITE
	LDA	#%00100000
	STA	VERA_H
	INC	VERA_M
	LDA	#32
	STA	VERA_L
	INC	TEMP_A
	LDA	TEMP_A
	CMP	#13
	BNE	SCK01
	LDA	#01
	STA	KEYS_DEFINED
	RTS

KEYS_DEFINED		!BYTE	00	;DEFAULT =0

;This is technically part of a background routine, but it has to
;be here in the main code because the screen effects are unique
;to each system.
DEMATERIALIZE:
	INC	UNIT_TIMER_B
	LDA	UNIT_TIMER_B
	CMP	#48
	BNE	DEMA
	LDA	#0
	STA	UNIT_TIMER_B
	JMP	DEMA1
DEMA:	;CYCLE PALETTE
	LDX	#%00010001
	STX	VERA_H
	LDX	#$FA
	STX	VERA_M
	LDX	#40
	STX	VERA_L
	AND	#15
	ROL
	ROL
	ROL
	ROL
	CLC
	ADC	UNIT_TIMER_B
	STA	VERA_DATA
	STA	VERA_DATA
	LDA	#1
	STA	UNIT_TIMER_A,X
	JMP	AILP
DEMA1:	;TRANSPORT COMPLETE
	;RESET PALETTE ENTRY
	LDX	#%00010001
	STX	VERA_H
	LDX	#$FA
	STX	VERA_M
	LDX	#40
	STX	VERA_L
	LDA	#0
	STA	VERA_DATA
	STA	VERA_DATA
	;TRANSPORT TO SOMEWHERE
	LDX	UNIT
	LDA	UNIT_B,X
	CMP	#1		;transport somewhere
	BEQ	DEMA2
	LDA	#2		;this means game over condition
	STA	UNIT_TYPE	;player type
	LDA	#7		;Normal transporter pad
	STA	UNIT_TYPE,X
	JMP	AILP
DEMA2:	LDA	#97
	STA	UNIT_TILE
	LDA	UNIT_C,X	;target X coordinates
	STA	UNIT_LOC_X
	LDA	UNIT_D,X	;target Y coordinates
	STA	UNIT_LOC_Y
	LDA	#7		;Normal transporter pad
	STA	UNIT_TYPE,X
	JSR	CACULATE_AND_REDRAW
	JMP	AILP

DISPLAY_PLAYER_SPRITE:
	LDA	#%00010001
	STA	VERA_H
	LDA	#$FC
	STA	VERA_M
	LDA	#24	;sprite 3 addresss high
	STA	VERA_L
	LDA	PLAYER_DIRECTION
	CLC
	ADC	PLAYER_ANIMATE
	TAX
	LDA	PLAYER_SPRITE_TABLE, X
	STA	VERA_DATA
	LDA	#30	;sprite 3 z-depth
	STA	VERA_L
	LDA	#%00001100	;enable sprite
	STA	VERA_DATA
	RTS
PLAYER_SPRITE_TABLE:
	!BYTE	48, 64, 80, 96, 112, 128, 144, 160, 176, 192, 208, 224, 240

ANIMATE_PLAYER:
	INC	PLAYER_ANIMATE
	LDA	PLAYER_ANIMATE
	CMP	#3
	BNE	ANPL1
	LDA	#0
	STA	PLAYER_ANIMATE
ANPL1:	JSR	DISPLAY_PLAYER_SPRITE
	RTS

PLAY_DIGI_SOUND:
	TAX
	LDA ZCM_LO,X
	PHA
	LDA ZCM_HI,X
	TAY
	LDA ZCM_BANK,X
	PLX
	JSR PCM_TRIGGER_DIGI
	; the digi sets the volume by default to max. Change it to the current setting.
PDS1:
	LDA $9F3B ; VERA Audio_CTRL (low nybble = volume)
	AND #$F0  ; Mask off the old volume value (preserve the rest of the bits)
	ORA SFX_VOLUME  ; set volume bits
	STA $9F3B ; write results to VERA.
	RTS

INCREASE_PCM_VOLUME:
	LDA SFX_VOLUME
	INC
	CMP #$10 ; new vol < $10?
	BCC VOL1
	LDA #$0F ; clamp max volume to $0F
	BRA VOL1
DECREASE_PCM_VOLUME:
	LDA SFX_VOLUME
	DEC
	BPL VOL1
	LDA #0  ; clamp min volume to 0
VOL1:
	STA SFX_VOLUME
	JMP PDS1 ; sets the volume to the new value and does the RTS.

PATTERN_L_TEMP:	!BYTE 00
PATTERN_H_TEMP:	!BYTE 00
DATA_LINE_TEMP:	!BYTE 00
TEMPO_TEMP:	!BYTE 00
WAVEFORM_TEMP	!BYTE 00

;This routine displays the on-screen map when the user presses TAB.
;SNES B-RETURN TO GAME A-TOGGLE PLAYER/ROBOTS

DISPLAY_MAP:
	LDA	#0
	STA	SCREEN_SHAKE
	LDA	#SFX_BEEP2		;menu beep
	JSR	PLAY_DIGI_SOUND	;SOUND PLAY
	LDA	#0
	STA	PRBLINK 	;SHOW PLAYER FIRST
	JSR	CLEAR_PLAYFIELD
	;DISABLE SPRITE
	LDA	#%00010001
	STA	VERA_H
	LDA	#$FC
	STA	VERA_M
	LDA	#30	;sprite 3 z-depth
	STA	VERA_L
	LDA	#%00000000	;disable sprite
	STA	VERA_DATA
	;DRAW FULL MAP
	LDA	#17	;BANK 1
	STA	VERA_H
	LDX	#0
	STX	LINE_DOUBLE
	STX	MAP_ROW
	LDA	#<MAP
	STA	$04
	LDA	#>MAP
	STA	$05
DM0:	LDX	MAP_ROW
	LDA	MAP_START_LEFT_H,X
	STA	VERA_M
	LDA	MAP_ROW
	AND	#%00000111
	TAX
	LDA	MAP_START_LEFT_L,X
	STA	VERA_L
	LDY	#0
DM1:	LDA	($04),Y
	TAX
	LDA	MAP_TRANSLATION_TABLE,X
	STA	VERA_DATA
	INY
	CPY	#128
	BNE	DM1
	INC	MAP_ROW
	LDY	#0
	LDA	LINE_DOUBLE
	CMP	#1
	BEQ	DM5
	INC 	LINE_DOUBLE
	JMP	DM0
DM5:	LDY	#0
	STY	LINE_DOUBLE
	JSR	ADD_128
	LDA	MAP_ROW
	CMP	#128
	BNE	DM0
	;LDA	#$00
	;STA	VERA_DATA
	JMP	MAP_WAIT

CLEAR_MAP:
	LDA	#17	;BANK 1
	STA	VERA_H
	LDX	#0
	STX	MAP_ROW
CM0:	LDX	MAP_ROW
	LDA	MAP_START_LEFT_H,X
	STA	VERA_M
	LDA	MAP_ROW
	AND	#%00000111
	TAX
	LDA	MAP_START_LEFT_L,X
	STA	VERA_L
	LDY	#0
CM1:	LDA	#00
	STA	VERA_DATA
	INY
	CPY	#128
	BNE	CM1
	INC	MAP_ROW
	LDA	MAP_ROW
	CMP	#128
	BNE	CM0
	RTS

SHOW_ROBOT_DOTS:
	LDY	#1		;First possible robot
	STY	MAP_UNIT
SRD0:	LDY	MAP_UNIT
	LDA	UNIT_TYPE,Y
	CMP	#0		;Does unit exist?
	BEQ	SRD1
	CMP	#8		;is it a dead robot?
	BEQ	SRD1
	JSR	PLOT_MAP_DOT
SRD1:	INC	MAP_UNIT
	LDA	MAP_UNIT
	CMP	#28		;Robots can be 1-27
	BNE	SRD0
	RTS

SHOW_PLAYER_DOT:
	LDA	#0		;Set as player unit
	STA	MAP_UNIT
	JSR	PLOT_MAP_DOT
	RTS

PLOT_MAP_DOT:
	LDA	#0
	STA	LINE_DOUBLE
SPD01:	LDY	MAP_UNIT
	LDA	UNIT_LOC_Y,Y
	ASL	;MULTIPLY BY TWO
	CLC
	ADC	LINE_DOUBLE
	TAX
	LDA	MAP_START_LEFT_H,X
	STA	$05
	LDA	UNIT_LOC_Y,Y
	ASL	;MULTIPLY BY TWO
	CLC
	ADC	LINE_DOUBLE
	AND	#%00000111
	TAX
	LDA	MAP_START_LEFT_L,X
	CLC
	ADC	UNIT_LOC_X,Y
	STA	VERA_L
	LDA	$05
	ADC	#0	;CARRY THE 1
	STA	VERA_M
	LDA	DOT_COLOR
	STA	VERA_DATA
	LDA	LINE_DOUBLE
	CMP	#1
	BEQ	SPD05
	INC	LINE_DOUBLE
	JMP	SPD01
SPD05:	RTS

BLINK_DOT:
	LDA	PRBLINK
	CMP	#0
	BNE	BDT1
	JSR	SHOW_PLAYER_DOT
	RTS
BDT1:	JSR	SHOW_ROBOT_DOTS
	RTS

TOGGLE_PR:
	LDA	#SFX_BEEP2		;menu beep
	JSR	PLAY_DIGI_SOUND	;SOUND PLAY
	INC	PRBLINK
	LDA	PRBLINK
	CMP	#2
	BNE	TPR5
	LDA	#0
	STA	PRBLINK
TPR5:	RTS

MAP_WAIT:
	LDA	BGTIMER2
	CMP	#0
	BNE	MW5
	LDA	DOT_COLOR
	CMP	#$00
	BNE	MW4
	LDA	#$11
	STA	DOT_COLOR
	JSR	BLINK_DOT
	LDA	#30
	STA	BGTIMER2
	JMP	MW5
MW4:	LDA	#$00
	STA	DOT_COLOR
	JSR	BLINK_DOT
	LDA	#30
	STA	BGTIMER2
MW5:	LDA	CONTROL
	CMP	#2	;SNES CONTROL ENABLED
	BNE	MW09
	JSR	SNES_CONTROLER_READ
	LDA	NEW_A
	CMP	#1
	BNE	MWS1
	JSR	TOGGLE_PR
	LDA	#0
	STA	NEW_A
	JMP	MAP_WAIT
MWS1:	LDA	NEW_B
	CMP	#1
	BNE	MW09
	LDA	#0
	STA	NEW_B
	JMP	MW10
MW09:	JSR	$FFE4	;WAIT FOR KEY
	CMP	#0
	BEQ	MAP_WAIT
	CMP	#9	;TAB KEY
	BNE	MW10
	JSR	TOGGLE_PR
	JMP	MAP_WAIT
MW10:	JSR	CLEAR_MAP
	LDA	#16	;BANK 0
	STA	VERA_H
	JSR	DISPLAY_PLAYER_SPRITE
	LDA	#SFX_BEEP2		;menu beep
	JSR	PLAY_DIGI_SOUND	;SOUND PLAY
	RTS


MAP_ROW		!BYTE 00
LINE_DOUBLE	!BYTE 00
DOT_COLOR	!BYTE 00
DOT_TIMER	!BYTE 30
MAP_UNIT	!BYTE 00
PRBLINK		!BYTE 00	;PLAYER =0, ROBOTS=1

ADD_128:
	LDA	$04
	CLC
	ADC	#128
	STA	$04
	LDA	$05
	ADC	#0
	STA	$05
	RTS

MAP_START_LEFT_L:
	!BYTE	$80,$20,$C0,$60,$00,$A0,$40,$E0	;ROWS 0-7
MAP_START_LEFT_H:
	!BYTE	$16,$17,$17,$18,$19,$19,$1A,$1A	;ROWS 0-7
	!BYTE	$1B,$1C,$1C,$1D,$1E,$1E,$1F,$1F	;ROWS 8-15
	!BYTE	$20,$21,$21,$22,$23,$23,$24,$24	;ROWS 16-23
	!BYTE	$25,$26,$26,$27,$28,$28,$29,$29	;ROWS 24-31
	!BYTE	$2A,$2B,$2B,$2C,$2D,$2D,$2E,$2E	;ROWS 32-39
	!BYTE	$2F,$30,$30,$31,$32,$32,$33,$33	;ROWS 40-47
	!BYTE	$34,$35,$35,$36,$37,$37,$38,$38	;ROWS 48-55
	!BYTE	$39,$3A,$3A,$3B,$3C,$3C,$3D,$3D	;ROWS 56-63
	!BYTE	$3E,$3F,$3F,$40,$41,$41,$42,$42	;ROWS 64-71
	!BYTE	$43,$44,$44,$45,$46,$46,$47,$47	;ROWS 72-79
	!BYTE	$48,$49,$49,$4A,$4B,$4B,$4C,$4C	;ROWS 80-87
	!BYTE	$4D,$4E,$4E,$4F,$50,$50,$51,$51	;ROWS 88-95
	!BYTE	$52,$53,$53,$54,$55,$55,$56,$56	;ROWS 96-103
	!BYTE	$57,$58,$58,$59,$5A,$5A,$5B,$5B	;ROWS 104-111
	!BYTE	$5C,$5D,$5D,$5E,$5F,$5F,$60,$60	;ROWS 112-119
	!BYTE	$61,$62,$62,$63,$64,$64,$65,$65	;ROWS 120-127

;The following table represents each tile with a single color that can be used
;for the on-screen map.  In the interest of efficiency, since each map "pixel"
;will actually be 2 pixels, and it is a 16-color bit map, I have just made
;each entry in the table doubled for the high/low nybble.  So instead of
;seeing $06, you will see $66.

MAP_TRANSLATION_TABLE:
	!BYTE	$00,$00,$11,$11
	!BYTE	$11,$11,$11,$11
	!BYTE	$11,$66,$11,$11
	!BYTE	$11,$11,$00,$11
	!BYTE	$11,$11,$11,$11
	!BYTE	$11,$11,$11,$11
	!BYTE	$55,$11,$11,$11
	!BYTE	$11,$EE,$88,$88
	!BYTE	$EE,$77,$22,$EE
	!BYTE	$EE,$77,$66,$EE
	!BYTE	$FF,$77,$88,$FF
	!BYTE	$FF,$77,$88,$FF
	!BYTE	$11,$11,$11,$FF
	!BYTE	$11,$55,$55,$FF
	!BYTE	$11,$55,$FF,$FF
	!BYTE	$66,$66,$11,$11
	!BYTE	$11,$11,$FF,$77
	!BYTE	$11,$11,$11,$11
	!BYTE	$FF,$FF,$FF,$FF
	!BYTE	$11,$11,$11,$11
	!BYTE	$11,$FF,$11,$FF
	!BYTE	$11,$FF,$11,$FF
	!BYTE	$11,$FF,$11,$11
	!BYTE	$11,$11,$11,$FF
	!BYTE	$88,$88,$00,$00
	!BYTE	$00,$00,$00,$00
	!BYTE	$11,$11,$11,$FF
	!BYTE	$FF,$FF,$66,$22
	!BYTE	$11,$11,$FF,$00
	!BYTE	$FF,$66,$FF,$11
	!BYTE	$11,$11,$88,$88
	!BYTE	$88,$88,$88,$88
	!BYTE	$11,$11,$00,$55
	!BYTE	$11,$FF,$00,$55
	!BYTE	$FF,$FF,$FF,$66
	!BYTE	$00,$00,$00,$FF
	!BYTE	$11,$11,$11,$11
	!BYTE	$88,$66,$88,$88
	!BYTE	$11,$11,$FF,$FF
	!BYTE	$88,$88,$FF,$66
	!BYTE	$88,$88,$88,$66
	!BYTE	$00,$00,$11,$FF
	!BYTE	$66,$BB,$11,$FF
	!BYTE	$11,$11,$11,$00
	!BYTE	$11,$11,$11,$11
	!BYTE	$11,$11,$11,$88
	!BYTE	$11,$11,$11,$11
	!BYTE	$11,$BB,$11,$11
	!BYTE	$11,$11,$11,$11
	!BYTE	$FF,$FF,$55,$DD
	!BYTE	$FF,$FF,$FF,$FF
	!BYTE	$66,$88,$99,$99
	!BYTE	$55,$55,$55,$DD
	!BYTE	$FF,$FF,$BB,$DD
	!BYTE	$11,$11,$11,$DD
	!BYTE	$11,$11,$11,$DD
	!BYTE	$11,$11,$11,$77
	!BYTE	$BB,$BB,$77,$77
	!BYTE	$BB,$BB,$77,$77
	!BYTE	$11,$11,$00,$00
	!BYTE	$00,$00,$CC,$00
	!BYTE	$00,$00,$00,$00
	!BYTE	$00,$00,$00,$00
	!BYTE	$00,$00,$00,$00


;This routine clears the playfield (text mode chars) so that the map can
;be seen clearly.

CLEAR_PLAYFIELD:
	LDA	#16 	;BANK 0
	STA	VERA_H
	LDY	#2
	STY	VERA_M
	LDX	#0
	STX	VERA_L
	LDA	#0
CPF1:	STA	VERA_DATA
	INX
	CPX	#66
	BNE	CPF1
	LDX	#0
	LDA	#0
	STA	VERA_L
	INY
	STY	VERA_M
	CPY	#27
	BNE	CPF1
	RTS

SOUND_LIBRARY_L:
SOUND_LIBRARY_H:
;0 explosion
;1 small explosion
;2 medkit
;3 emp
;4 haywire
;5 evilbot
;6 move
;7 electric shock
;8 plasma gun
;9 fire pistol
;10 item found
;11 error
;12 change weapons
;13 change items
;14 door
;15 menu beep
;16 walk
;17 sfx (short beep)
;18 sfx

MUSIC_ROUTINE:
	RTS

SET_WAVEFORM:
	RTS
WAVEFORM	!BYTE	00

!SOURCE "BACKGROUND_TASKS.ASM"

;These are the included binary files that contain the screen
;image for the main editor.
INTRO_TEXT:
	!BYTE $60, $20, $53, $13, $14, $01, $12, $14, $20, $07, $01, $0D, $05, $60, $20
	!BYTE $1D, $13, $05, $0C, $05, $03, $14, $20, $0D, $01, $10, $60, $20, $1D, $04
	!BYTE $09, $06, $06, $09, $03, $15, $0C, $14, $19, $60, $20, $1D, $03, $0F, $0E
	!BYTE $14, $12, $0F, $0C, $13, $60, $20, $6E, $70, $60, $40, $02, $73, $0D, $01
	!BYTE $10, $6B, $60, $40, $02, $6E, $60, $20, $19, $0B, $09, $0C, $0C, $20, $01
	!BYTE $0C, $0C, $20, $08, $15, $0D, $01, $0E, $13, $60, $20, $FF, $60, $20, $FF
	!BYTE $60, $20, $71
	!BYTE $60,$20,$C8	;extra 5 blank lines

SCR_TEXT:
	!BYTE	$60,$20,$C8;extra 5 blank lines
	!BYTE	$60,$20,$C8;extra 5 blank lines
	!BYTE	$60,$20,$C8;extra 5 blank lines
	!BYTE	$60,$20,$C8;extra 5 blank lines
	!BYTE	$60,$20,$C8;extra 5 blank lines
	!BYTE	$60,$20,$C8;extra 5 blank lines

SCR_ENDGAME:
	!BYTE	$55, $60, $40, $03, $73, $01, $14, $14, $01, $03, $0B, $20, $0F, $06, $20
	!BYTE	$14, $08, $05, $20, $10, $05, $14, $13, $03, $09, $09, $20, $12, $0F, $02
	!BYTE	$0F, $14, $13, $6B, $60, $40, $03, $49, $5D, $60, $20, $25, $5D, $5D, $60
	!BYTE	$20, $25, $5D, $5D, $60, $20, $25, $5D, $5D, $60, $20, $25, $5D, $5D, $60
	!BYTE	$20, $25, $5D, $5D, $60, $20, $25, $5D, $5D, $60, $20, $0A, $13, $03, $05
	!BYTE	$0E, $01, $12, $09, $0F, $3A, $60, $20, $11, $5D, $5D, $60, $20, $25, $5D
	!BYTE	$5D, $60, $20, $06, $05, $0C, $01, $10, $13, $05, $04, $20, $14, $09, $0D
	!BYTE	$05, $3A, $60, $20, $11, $5D, $5D, $60, $20, $25, $5D, $5D, $60, $20, $02
	!BYTE	$12, $0F, $02, $0F, $14, $13, $20, $12, $05, $0D, $01, $09, $0E, $09, $0E
	!BYTE	$07, $3A, $60, $20, $11, $5D, $5D, $60, $20, $25, $5D, $5D, $20, $20, $13
	!BYTE	$05, $03, $12, $05, $14, $13, $20, $12, $05, $0D, $01, $09, $0E, $09, $0E
	!BYTE	$07, $3A, $60, $20, $11, $5D, $5D, $60, $20, $25, $5D, $5D, $60, $20, $08
	!BYTE	$04, $09, $06, $06, $09, $03, $15, $0C, $14, $19, $3A, $60, $20, $11, $5D
	!BYTE	$5D, $60, $20, $25, $5D, $5D, $60, $20, $25, $5D, $5D, $60, $20, $25, $5D
	!BYTE	$5D, $60, $20, $25, $5D, $5D, $60, $20, $25, $5D, $5D, $60, $20, $25, $5D
	!BYTE	$5D, $60, $20, $25, $5D, $5D, $60, $20, $25, $5D
	!BYTE	$5D, $60, $20, $25, $5D		;ROW 24
	!BYTE	$5D, $60, $20, $25, $5D		;ROW 25
	!BYTE	$5D, $60, $20, $25, $5D		;ROW 26
	!BYTE	$5D, $60, $20, $25, $5D		;ROW 27
	!BYTE	$5D, $60, $20, $25, $5D		;ROW 28
	!BYTE	$4A, $60, $40, $25, $4B		;ROW 29

SCR_CUSTOM_KEYS:
	!BYTE	$55, $60, $40, $03, $73, $01, $14, $14, $01, $03, $0B, $20, $0F, $06, $20
	!BYTE	$14, $08, $05, $20, $10, $05, $14, $13, $03, $09, $09, $20, $12, $0F, $02
	!BYTE	$0F, $14, $13, $6B, $60, $40, $03, $49, $5D, $60, $20, $25, $5D, $5D, $60
	!BYTE	$20, $25, $5D, $5D, $60, $20, $03, $10, $12, $05, $13, $13, $20, $14, $08
	!BYTE	$05, $20, $0B, $05, $19, $13, $20, $19, $0F, $15, $20, $17, $09, $13, $08
	!BYTE	$20, $14, $0F, $20, $15, $13, $05, $60, $20, $03, $5D, $5D, $60, $20, $04
	!BYTE	$06, $0F, $12, $20, $14, $08, $05, $20, $06, $0F, $0C, $0C, $0F, $17, $09
	!BYTE	$0E, $07, $20, $06, $15, $0E, $03, $14, $09, $0F, $0E, $13, $60, $20, $05
	!BYTE	$5D, $5D, $60, $20, $25, $5D, $5D, $60, $20, $25, $5D, $5D, $60, $20, $25
	!BYTE	$5D, $5D, $60, $20, $06, $0D, $0F, $16, $05, $20, $15, $10, $3A, $60, $20
	!BYTE	$16, $5D, $5D, $60, $20, $04, $0D, $0F, $16, $05, $20, $04, $0F, $17, $0E
	!BYTE	$3A, $60, $20, $16, $5D, $5D, $60, $20, $04, $0D, $0F, $16, $05, $20, $0C
	!BYTE	$05, $06, $14, $3A, $60, $20, $16, $5D, $5D, $60, $20, $03, $0D, $0F, $16
	!BYTE	$05, $20, $12, $09, $07, $08, $14, $3A, $60, $20, $16, $5D, $5D, $60, $20
	!BYTE	$06, $06, $09, $12, $05, $20, $15, $10, $3A, $60, $20, $16, $5D, $5D, $60
	!BYTE	$20, $04, $06, $09, $12, $05, $20, $04, $0F, $17, $0E, $3A, $60, $20, $16
	!BYTE	$5D, $5D, $60, $20, $04, $06, $09, $12, $05, $20, $0C, $05, $06, $14, $3A
	!BYTE	$60, $20, $16, $5D, $5D, $60, $20, $03, $06, $09, $12, $05, $20, $12, $09
	!BYTE	$07, $08, $14, $3A, $60, $20, $16, $5D, $5D, $20, $03, $19, $03, $0C, $05
	!BYTE	$20, $17, $05, $01, $10, $0F, $0E, $13, $3A, $60, $20, $16, $5D, $5D, $60
	!BYTE	$20, $02, $03, $19, $03, $0C, $05, $20, $09, $14, $05, $0D, $13, $3A, $60
	!BYTE	$20, $16, $5D, $5D, $60, $20, $05, $15, $13, $05, $20, $09, $14, $05, $0D
	!BYTE	$3A, $60, $20, $16, $5D, $5D, $20, $13, $05, $01, $12, $03, $08, $20, $0F
	!BYTE	$02, $0A, $05, $03, $14, $3A, $60, $20, $16, $5D, $5D, $60, $20, $02, $0D
	!BYTE	$0F, $16, $05, $20, $0F, $02, $0A, $05, $03, $14, $3A, $60, $20, $16, $5D
	!BYTE	$5D, $60, $20, $25, $5D, $5D, $60, $20, $25, $5D, $5D, $60, $20, $25, $5D
	!BYTE	$5D, $60, $20, $25, $5D		;ROW 24
	!BYTE	$5D, $60, $20, $25, $5D		;ROW 25
	!BYTE	$5D, $60, $20, $25, $5D		;ROW 26
	!BYTE	$5D, $60, $20, $25, $5D		;ROW 27
	!BYTE	$5D, $60, $20, $25, $5D		;ROW 28
	!BYTE	$4A, $60, $40, $25, $4B		;ROW 29

CINEMA_MESSAGE:
	!SCR"coming soon: space balls 2 - the search for more money, "
	!SCR"attack of the paperclips: clippy's revenge, "
	!SCR"it came from planet earth, "
	!SCR"rocky 5000, all my circuits the movie, "
	!SCR"conan the librarian, and more! "

;This data represents the 3 different faces of the intro robot.
;80 bytes for each face.  the face size is 16x10 pixels (in 2bpp format)

THREE_FACES:
	!BYTE $6C, $CC, $C6, $66, $66, $6C, $CC, $C6, $C0, $00, $0C, $66, $66, $C0, $00
	!BYTE $0C, $06, $66, $60, $66, $66, $06, $66, $60, $33, $3C, $C6, $66, $66, $63
	!BYTE $33, $3C, $00, $00, $0C, $66, $66, $30, $00, $00, $0D, $DD, $00, $C6, $63
	!BYTE $00, $DD, $C0, $55, $00, $D0, $C6, $63, $0C, $50, $0C, $C5, $00, $D0, $66
	!BYTE $63, $05, $50, $0C, $C5, $55, $C0, $66, $63, $05, $55, $5C, $0A, $CC, $00
	!BYTE $66, $63, $00, $C8, $C0, $06, $CC, $60, $00, $00, $06, $CC, $60, $00, $00
	!BYTE $CC, $C6, $0C, $CC, $00, $00, $66, $66, $00, $00, $00, $00, $66, $66, $33
	!BYTE $3C, $C6, $66, $66, $63, $33, $3C, $00, $00, $0C, $66, $66, $30, $00, $00
	!BYTE $07, $77, $00, $C6, $63, $00, $77, $80, $A2, $22, $70, $C6, $63, $08, $22
	!BYTE $28, $22, $22, $70, $66, $63, $02, $22, $2A, $A2, $22, $80, $66, $63, $02
	!BYTE $22, $2A, $0A, $88, $00, $66, $63, $00, $28, $A0, $C0, $66, $66, $66, $66
	!BYTE $66, $66, $0C, $0C, $06, $66, $66, $66, $66, $60, $C0, $66, $C0, $66, $66
	!BYTE $66, $66, $0C, $06, $33, $3C, $06, $66, $66, $60, $C3, $3C, $00, $00, $C0
	!BYTE $66, $66, $0C, $00, $00, $07, $70, $0C, $06, $60, $C0, $07, $80, $A2, $27
	!BYTE $00, $C6, $63, $00, $72, $28, $22, $22, $70, $66, $63, $02, $22, $2A, $A2
	!BYTE $22, $80, $66, $63, $02, $22, $2A, $0A, $88, $00, $66, $63, $00, $28, $A0



;; Symbols from legacy sound engine pending deletion
;NOTE_FREQ_L:
;NOTE_FREQ_H:
;SND_EXPLOSION:
;SND_MEDKIT:
;SND_EMP:
;SND_MAGNET:
;SND_SHOCK:
;SND_MOVE_OBJ:
;SND_PLASMA:
;SND_PISTOL:
;SND_ITEM_FOUND:
;SND_ERROR:
;SND_CYCLE_WEAPON:
;SND_CYCLE_ITEM:
;SND_DOOR:
;SND_MENU_BEEP:
;SND_SHORT_BEEP:
;INTRO_MUSIC:
;WIN_MUSIC:
;LOSE_MUSIC:
;IN_GAME_MUSIC1:
;IN_GAME_MUSIC2:
;IN_GAME_MUSIC3:

!SOURCE "sounds.asm"
