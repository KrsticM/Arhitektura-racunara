# Prepisati prvih NELEM karaktera a sve ostale zameniti sa razmacima
.section .data

NELEM = 5

max_duzina = 100
string1: .fill max_duzina,1,0
string3: .fill max_duzina,1,0


string2: .ascii "Unesite string: \0"
string2_duzina = .-string2

duzina: .long 0

.section .text
.globl main
main:
	movl $4, %eax
	movl $1, %ebx
	leal string2, %ecx
	movl $string2_duzina, %edx
	int $0x80
	
	movl $3, %eax
	movl $0, %ebx
	leal string1, %ecx
	movl $max_duzina, %edx
	int $0x80

	movl %eax, duzina

	
	leal string1, %esi
	leal string3, %edi
	movl $1, %ecx 
petlja:
	cmpb $10, (%esi)
	je kraj_petlje
	
	cmpl $NELEM, %ecx # uvek se gleda desni u odnosu na levi
	jle prepisi 
	
	# upisujemo space u edi
	movb $' ', (%edi)
	incl %edi
	incl %esi
	jmp petlja

prepisi:
	movb (%esi), %bl
	movb %bl, (%edi)
	incl %ecx
	incl %esi
	incl %edi
	jmp petlja
kraj_petlje:
	movb $0, (%edi) # upisujemo kraj stringa u string3

	movl $4, %eax
	movl $1, %ebx
	leal string3, %ecx
	movl duzina, %edx
	int $0x80

kraj:
	movl $1, %eax
	movl $0, %ebx
	int $0x80

	
