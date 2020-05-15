	processor 6502

	include "atari2600/vcs.h"
	include "atari2600/macro.h"

	seg code
	org $f000		; defines origin of ROM

start:
	CLEAN_START		; macro to clear memory

;;; Set Background luminosity to yellow
	lda #$1e
	sta COLUBK
	jmp start

;;; Fill ROM size to 4KiB
	org $fffc
	.word start		; Reset vector
	.word start		; Interrupt vector
