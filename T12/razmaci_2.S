.section .data
	string: .ascii "Unesite string \0"
	strlen=.-string
string_max=20
string1: .fill string_max,1,0

max2 = 50
string2: .fill max2,1,0

string3: .fill max2,1,0

razmak: .long 0
brojac: .long 0 # kada je nula samo prepisemo a kada je 1 prepisemo na space pa opet
duzina: .long 0

duzina_sa_razmacima: .long 0
duzina_bez_razmaka: .long 0

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
	leal string2,%edi
petlja:
	movb (%esi), %bl # samo radi DDD
	cmpb $10,(%esi) # porovera da li smo dosli do kraja stringa
	je kraj_petlje 
	
	cmpl $0, brojac
	je samo_prepisi # prvo je slovo
	
	#svaki naredni karakter treba da dupliramo i ubacimo razmak osim ako nije poslednji
	cmpb $10, 1(%esi)
	je poslednji_karakter
	
	# ako nije ni prvi a ni poslednji
	# prepisi
	movb (%esi), %bl
	movb %bl, (%edi)
	incl %edi
	incl duzina_sa_razmacima	

	#upisujem space u edi
	movb $' ', (%edi)
	incl %edi
	incl duzina_sa_razmacima

	#opet prepisem
	movb (%esi), %bl
	movb %bl, (%edi)
	incl %edi
	incl duzina_sa_razmacima	

	incl %esi
	jmp petlja
samo_prepisi:
	movb $1, brojac # rec je pocela
	movb (%esi), %bl
	movb %bl, (%edi)
	incl %esi
	incl %edi
	incl duzina_sa_razmacima
	jmp petlja	
poslednji_karakter:
	movb (%esi), %bl
	movb %bl, (%edi)
	incl %esi
	incl %edi
	incl duzina_sa_razmacima
	jmp petlja	
kraj_petlje:
	movl $0, (%edi)
	
	cmpl $0, razmak
	je izbaci_razmake

	movl $4, %eax
	movl $1, %ebx
	leal string2, %ecx
	movl duzina_sa_razmacima, %edx
	int $0x80
	jmp kraj

izbaci_razmake:
	leal string2, %esi
	leal string3, %edi
petlja2:
	cmpb $0, (%esi)
	je kraj_petlja2
	cmpb $' ', (%esi)
	jne prepisi
	incl %esi
	jmp petlja2
prepisi:
	movb (%esi), %bl
	movb %bl, (%edi)
	incl %esi
	incl %edi
	incl duzina_bez_razmaka
	jmp petlja2
kraj_petlja2:
	movl $4, %eax
	movl $1, %ebx
	leal string3, %ecx
	movl duzina_bez_razmaka, %edx
	int $0x80	
	
kraj:
	movl $1,%eax
	movl $0,%ebx
	int $0x80
