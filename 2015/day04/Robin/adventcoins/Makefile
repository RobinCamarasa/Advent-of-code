.PHONY := build clean

build:
	@echo "- build : "
	gcc -I/usr/include/openssl -o out *.c -L/usr/lib/x86_64-linux-gnu -lcrypto

clean:
	@echo "- clean : "
	rm out
