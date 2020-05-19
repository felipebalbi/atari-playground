	processor 6502

	include "atari2600/vcs.h"
	include "atari2600/macro.h"

	seg.u variables
	org $80
player0_height:	byte
player0_ypos:	byte

	seg code
	org $f000		; defines origin of ROM

reset:
	CLEAN_START		; macro to clear memory

	ldx #$80		; blue background
	stx COLUBK

	lda #180
	sta player0_ypos

	lda #9
	sta player0_height

;;; Start a new frame by turning on vblank and vsync
next_frame:
	lda #$02
	sta VBLANK		; turn on VBLANK
	sta VSYNC		; turn on VSYNC

;;; Generate 3 VSYNC
	REPEAT 3
	sta WSYNC
	REPEND

	lda #$00
	sta VSYNC		; turn off VSYNC

;;; Generate 37 VBLANKs
	REPEAT 37
	sta WSYNC
	REPEND

	lda #$00
	sta VBLANK		; turn off VBLANK

	ldx #192
scanline:
	txa
	sec
	sbc player0_ypos
	cmp player0_height
	bcc load_bitmap

	lda #0
load_bitmap:	
	tay
	lda player0_bitmap,y
	sta WSYNC
	sta GRP0
	lda player0_color,y
	sta COLUP0
	dex
	bne scanline	

;;; Draw 30 overscan
overscan:	
	lda #$02
	sta VBLANK

	REPEAT 30
	sta WSYNC
	REPEND

	lda #$00
	sta VBLANK

	dec player0_ypos
	jmp next_frame

player0_bitmap:
	.byte #%00000000
	.byte #%00101000
	.byte #%01110100
	.byte #%11111010
	.byte #%11111010
	.byte #%11111010
	.byte #%11111110
	.byte #%01101100
	.byte #%00110000

player0_color:
	byte #$00
	byte #$40
	byte #$40
	byte #$40
	byte #$40
	byte #$42
	byte #$42
	byte #$42
	byte #$d2

;;; Fill ROM size to 4KiB
	org $fffc
	.word reset		; Reset vector
	.word reset		; Interrupt vector
