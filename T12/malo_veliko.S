# program treba da iz unetog stringa sva mala slova zameni velikim velika malim i sve brojeve zameni zvezdicom
.section .data
	string: .ascii "Unesite string \0"
	strlen=.-string
string_max=40
string1: .fill string_max,1,0

duzina: .long 0
.section .text
.globl main
main:
	movl $4,%eax
	movl $1,%ebx
	leal string,%ecx
	movl $strlen,%edx
	int $0x80

	movl $3,%eax
	movl $0,%ebx
	leal string1,%ecx
	movl $string_max,%edx
	int $0x80

	movl %eax, duzina

	leal string1,%esi
petlja:
	cmpb $10,(%esi) # porovera da li smo dosli do kraja stringa
	je kraj_petlje 
	cmpb $'0',(%esi)
	jb preskoci
	cmpb $'9',(%esi)
	jbe broj
	cmpb $'A',(%esi)
	jb preskoci
	cmpb $'Z',(%esi)
	jbe veliko_slovo
	cmpb $'a',(%esi)
	jb preskoci
	cmpb $'z',(%esi)
	jbe malo_slovo
	jmp preskoci

preskoci:
	incl %esi
	jmp petlja
broj:
	movb $'*',(%esi)
	incl %esi
	jmp petlja
veliko_slovo:
	addb $32,(%esi)
	incl %esi
	jmp petlja
malo_slovo:
	subb $32,(%esi)
	incl %esi
	jmp petlja
kraj_petlje:
	movl $4,%eax
	movl $1,%ebx
	leal string1,%ecx
	movl duzina, %edx
	int $0x80
kraj:
	movl $1,%eax
	movl $0,%ebx
	int $0x80
