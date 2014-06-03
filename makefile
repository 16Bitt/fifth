SOURCES 	= bootsec.bin next.bin
VOCABS		= native/data native/variable native/compare native/basic native/io
COMPILED	= port/none port/hi-io port/util port/main
ASFLAGS		= -fbin

all: img/space.bin img/hunk.bin img/bootsec.bin
	cat img/bootsec.bin img/hunk.bin img/space.bin > build/disk.img

img/bootsec.bin:
	nasm $(ASFLAGS) boot.s -o img/bootsec.bin

img/hunk.bin: forth
	cat header/head.h > hunk.s
	cat *.asm >> hunk.s
	cat header/foot.h >> hunk.s
	nasm $(ASFLAGS) hunk.s -o img/hunk.bin

img/space.bin:
	dd if=/dev/zero of=img/space.bin conv=sync count=4

forth:
	./bin/comp $(COMPILED)
	./bin/chain $(VOCABS) $(COMPILED)
	mv native/*.asm ./
	mv port/*.asm ./
	-rm native/*.last native/*.names native/*.values port/*.f port/*.last port/*.names port/*.values

clean:
	-rm img/* build/* *.asm hunk.s

run: all
	qemu-system-x86_64 -boot a  -fda build/disk.img -monitor stdio
