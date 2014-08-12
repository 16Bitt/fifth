SOURCES 	= bootsec.bin next.bin
VOCABS		= native/data native/variable native/compare native/basic native/io native/disk
COMPILED	= port/hi-compare port/hi-io port/string port/util port/reg port/lang port/hi-disk port/main
ASFLAGS		= -fbin
GENERATED	= $(VOCABS:=.asm) $(COMPILED:=.asm)

all: floppy img/hunk.bin
	cat img/hunk.bin > build/FORTH.SYS
	mcopy -i build/disk.img  build/FORTH.SYS ::/

img/bootsec.bin:
	nasm $(ASFLAGS) boot.s -o img/bootsec.bin

img/hunk.bin: forth
	cat header/head.h > hunk.s
	cat $(GENERATED) >> hunk.s
	cat header/foot.h >> hunk.s
	nasm $(ASFLAGS) hunk.s -o img/hunk.bin

forth:
	./bin/comp $(COMPILED)
	./bin/chain $(VOCABS) $(COMPILED)
	-rm native/*.last native/*.names native/*.values port/*.f port/*.last port/*.names port/*.values

floppy: img/bootsec.bin
	dd if=/dev/zero of=build/disk.img count=1440 bs=1k
	dd if=img/bootsec.bin of=build/disk.img bs=512 conv=notrunc

clean:
	-rm img/* build/* $(GENERATED) hunk.s

run: all
	qemu-system-x86_64 -boot a  -fda build/disk.img -monitor stdio
