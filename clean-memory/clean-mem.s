	processor 6502

	seg code
	org $f000		; assemble to $f000

main:
	sei			; cet Interrupt Disable flag
	cld			; clear decimal mode
	ldx #$ff		; load X with #$ff
	txs			; transfer X to SP, zeroing the stack

clear_mem:	
	lda #$00		; A = 0
	ldx #$00		; X = 255
memloop:
	dex			; X--
	sta $00,x		; Store to $00[x]
	bne memloop

	org $fffc		; assemble to $fffc
	.word main		; reset vector at $fffc
	.word main		; interrupt vector at $fffe
