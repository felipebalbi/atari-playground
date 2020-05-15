	processor 6502

	include "atari2600/vcs.h"
	include "atari2600/macro.h"

	seg code
	org $f000		; defines origin of ROM

start:
	CLEAN_START		; macro to clear memory

	ldx #$80		; blue background
	stx COLUBK

	lda #$1c		; yello playfield
	sta COLUPF

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

;;; Set the CTRLPF register to allow reflection
	ldx #$01
	stx CTRLPF

;;; Draw the playfield
	;; skip 7 scanlines
	ldx #$00
	stx PF0
	stx PF1
	stx PF2
	REPEAT 7
	sta WSYNC
	REPEND

	;; set the PF0 to $0e and PF1/2 to $ff, repeat 7 times
	ldx #$e0
	stx PF0
	ldx #$ff
	stx PF1
	stx PF2
	REPEAT 7
	sta WSYNC
	REPEND

	;; set PF0 to $20 and PF1/2 to $00, repeat 164 times
	ldx #$60
	stx PF0
	ldx #$00
	stx PF1
	ldx #$80
	stx PF2
	REPEAT 164
	sta WSYNC
	REPEND

	;; set the PF0 to $0e and PF1/2 to $ff, repeat 7 times
	ldx #$e0
	stx PF0
	ldx #$ff
	stx PF1
	stx PF2
	REPEAT 7
	sta WSYNC
	REPEND

	;; skip 7 scanlines
	ldx #$00
	stx PF0
	stx PF1
	stx PF2
	REPEAT 7
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

;;; Fill ROM size to 4KiB
	org $fffc
	.word start		; Reset vector
	.word start		; Interrupt vector
