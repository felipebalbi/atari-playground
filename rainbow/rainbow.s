	processor 6502

	include "atari2600/vcs.h"
	include "atari2600/macro.h"

	seg code
	org $f000		; defines origin of ROM

start:
	CLEAN_START		; macro to clear memory

;;; Start a new frame by turning on vblank and vsync
next_frame:
	lda #$02
	sta VBLANK		; turn on VBLANK
	sta VSYNC		; turn on VSYNC

;;; Generate 3 VSYNC
	sta WSYNC		; 1st scanline
	sta WSYNC		; 2nd scanline
	sta WSYNC		; 3rd scanline

	lda #$00
	sta VSYNC		; turn off VSYNC

;;; Generate 37 VBLANKs
	ldx #37
loop_vblank:
	sta WSYNC
	dex
	bne loop_vblank

	lda #$00
	sta VBLANK		; turn off VBLANK

;;; Draw 192 visible scanlines
	ldx #192
loop_visible:
	stx COLUBK
	sta WSYNC
	dex
	bne loop_visible

;;; Draw 30 overscan
	lda #$02
	sta VBLANK

	ldx #30
loop_overscan:
	sta WSYNC
	dex
	bne loop_overscan

	jmp next_frame

;;; Fill ROM size to 4KiB
	org $fffc
	.word start		; Reset vector
	.word start		; Interrupt vector
