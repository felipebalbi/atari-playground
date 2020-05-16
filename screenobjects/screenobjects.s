	processor 6502

	include "atari2600/vcs.h"
	include "atari2600/macro.h"

	seg code
	org $f000		; defines origin of ROM

start:
	CLEAN_START		; macro to clear memory

	ldx #$80		; blue background
	stx COLUBK

	lda #$0f		; white playfield
	sta COLUPF

	lda #$48		; player 0 light red
	sta COLUP0

	lda #$c6		; player 1 light gree
	sta COLUP1

	ldy #$02
	sty CTRLPF

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

visible_scanlines:
	;; 10 empty scanlines
	REPEAT 10
	sta WSYNC
	REPEND

	ldy #0
scoreboard_loop:
	lda number_bitmap,y
	sta PF1
	sta WSYNC
	iny
	cpy #10
	bne scoreboard_loop

	lda #0
	sta PF1

	REPEAT 50
	sta WSYNC
	REPEND

	ldy #0
player0_loop:
	lda player_bitmap,y
	sta GRP0
	sta WSYNC
	iny
	cpy #10
	bne player0_loop

	lda #0
	sta GRP0
	
	ldy #0
player1_loop:
	lda player_bitmap,y
	sta GRP1
	sta WSYNC
	iny
	cpy #10
	bne player1_loop

	lda #0
	sta GRP1
	
	REPEAT 102
	sta WSYNC
	REPEND

;;; Draw 30 overscan
	lda #$02
	sta VBLANK

	REPEAT 30
	sta WSYNC
	REPEND

	lda #$00
	sta VBLANK

	jmp next_frame

	org $ffe8
player_bitmap:
	.byte #%01111110
	.byte #%11111111
	.byte #%10011001
	.byte #%11111111
	.byte #%11111111
	.byte #%11111111
	.byte #%10111101
	.byte #%11000011
	.byte #%11111111
	.byte #%01111110

	org $fff2
number_bitmap:
	.byte #%00001110
	.byte #%00001110
	.byte #%00000010
	.byte #%00000010
	.byte #%00001110
	.byte #%00001110
	.byte #%00001000
	.byte #%00001000
	.byte #%00001110
	.byte #%00001110

;;; Fill ROM size to 4KiB
	org $fffc
	.word start		; Reset vector
	.word start		; Interrupt vector
