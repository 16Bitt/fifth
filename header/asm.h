%macro NEXT 0
	RETF
%endmacro

%macro FPUSH 1
	MOV AX, %1
	MOV [BP], AX
	ADD BP, 2
%endmacro

%macro FPOP 1
	SUB BP, 2
	MOV %1, [BP]
%endmacro

%define STACK 	ENDKERNEL
%define MIRROR	STACK+512
%define STRBUF	MIRROR+128
%define DISK	STRBUF+512
