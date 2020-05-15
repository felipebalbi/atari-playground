all: cart.bin

cart.bin: *.s
	dasm *.s -f3 -v0 -ocart.bin -I/usr/include/dasm

run: cart.bin
	stella cart.bin

clean:
	rm cart.bin
