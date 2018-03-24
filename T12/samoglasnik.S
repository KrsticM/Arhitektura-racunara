.section .data
	string: .ascii "Unesite string \0"
	strlen=.-string
string_max=100
string1: .fill string_max,1,0

a: .long 0
e: .long 0
i: .long 0
o: .long 0
u: .long 0
samoglasnik: .long 0
string2:
	.ascii "Nema samoglasnika \0"
string2len=.-string2
string3:
	.ascii "Ima samoglasnika \0"
string3len=.-string3

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

	leal string1,%esi
petlja:
	cmpb $10,(%esi) # porovera da li smo dosli do kraja stringa
	je kraj_petlje 
	cmpb $'A',(%esi)
	je samoglasnik_a
	cmpb $'a',(%esi)
	je samoglasnik_a
	cmpb $'E',(%esi)
	je samoglasnik_e
	cmpb $'e',(%esi)
	je samoglasnik_e
	cmpb $'I',(%esi)
	je samoglasnik_i
	cmpb $'i',(%esi)
	je samoglasnik_i
	cmpb $'O',(%esi)
	je samoglasnik_o
	cmpb $'o',(%esi)
	je samoglasnik_o
	cmpb $'U',(%esi)
	je samoglasnik_u
	cmpb $'u',(%esi)
	je samoglasnik_u
	incl %esi
	jmp petlja
samoglasnik_a:
	incl a
	incl samoglasnik	
	incl %esi
	jmp petlja
samoglasnik_e:
	incl e
	incl samoglasnik
	incl %esi
	jmp petlja
samoglasnik_i:
	incl i
	incl samoglasnik
	incl %esi
	jmp petlja
samoglasnik_o:
	incl o
	incl samoglasnik
	incl %esi
	jmp petlja
samoglasnik_u:
	incl u
	incl samoglasnik
	incl %esi
	jmp petlja
kraj_petlje: # treba da ispisemo string ima ili nema
	cmpl $0,samoglasnik
	je nema_samoglasnika
	movl $4,%eax
	movl $1,%ebx
	leal string3,%ecx
	movl $string3len,%edx
	int $0x80
	jmp kraj
nema_samoglasnika:
	movl $4,%eax
	movl $1,%ebx
	leal string2,%ecx
	movl $string2len,%edx
	int $0x80
	
	

kraj:
	movl $1,%eax
	movl $0,%ebx
	int $0x80
