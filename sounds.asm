; Pointers indexing the various audio resources loaded into HiRam
; Zsound uses .A = bank ; .XY = address as arguments to the routines
; that start playback.
;

ZCM_LO:
  !BYTE $00, $74, $99, $ec, $ab, $dc, $06, $e0, $00, $d2, $71, $68, $1b, $f9, $8f
  !BYTE $83

ZCM_HI:
  !BYTE $a0, $ab, $b4, $a6, $bf, $b9, $b0, $a1, $a2, $b1, $ae, $ae, $b4, $bc, $aa
  !BYTE $af

ZCM_BANK:
  !BYTE $01, $01, $01, $02, $02, $04, $06, $07, $08, $09, $0c, $0f, $10, $10, $11
  !BYTE $12

ZSM_LO:
  !BYTE $40, $ea, $78, $66, $0b, $d3, $01, $d6, $06

ZSM_HI:
  !BYTE $bd, $a3, $a7, $a5, $bf, $b8, $a7, $b2, $af

ZSM_BANK:
  !BYTE $12, $13, $13, $2a, $37, $43, $4c, $58, $6a

; only use these if included from PAYLOAD6 loader
!ifndef PAYLOAD6_LOADER !eof
AUDIO_LASTBANK: !BYTE $7b
AUDIO_LASTADDR: !WORD $ad1b
