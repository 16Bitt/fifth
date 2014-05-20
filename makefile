SOURCES 	= bootsec.bin next.bin
VOCABS		= native/io native/basic
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
	./bin/chain $(VOCABS)
	mv native/*.asm ./
	-rm native/*.last native/*.names native/*.values

clean:
	-rm img/* build/* *.asm hunk.s

run:
	qemu-system-i386 -fda build/disk.img -monitor stdio
