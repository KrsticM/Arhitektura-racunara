# Za zadati string odrediti broj ponavljanja u unetom stringu
# Izlazni kod je broj ponavljavnja
# Ako ima ponavljanja ispisati "Ima ponavljanja" ako nema "Nema ponavljanja"
.section .data

max_duzina = 100
string_uneti: .fill max_duzina,1,0 # zauzima 100 elemenata velicine 1 bajt i popunjava nulama na pocetku 


string2: .ascii "Unesite string: \0"
string2_duzina = .-string2

ima_ponavljanja: .long 0


string_ima: .ascii "Ima ponavljanja! \0"
string_ima_duzina = .-string_ima

string_nema: .ascii "Nema ponavljanja! \0"
string_nema_duzina = .-string_nema


.section .text
.globl main

main:
	# printf("Unesite string");	
	movl $4, %eax
	movl $1, %ebx
	leal string2, %ecx
	movl $string2_duzina, %edx
	int $0x80

	#scanf("%s");
	movl $3, %eax
	movl $0, %ebx
	leal string_uneti, %ecx
	movl $max_duzina, %edx
	int $0x80

	#prolazak kroz string 
	leal string_uneti, %esi # adresa prvog karaktera ide u esi

petlja:
	# "testtest"
	cmpb $10, (%esi) # ono sto se nalazi na adresi esi
	je kraj_petlje
	# ako nismo dosli do kraja stringa
	cmpb $'t',(%esi)
	je proveri_sledeci 
	
	incl %esi
	jmp petlja

proveri_sledeci:
	incl %esi
	cmpb $'e', (%esi)
	je proveri_sledeci2	
	cmpb $'t', (%esi)
	je proveri_sledeci
	incl %esi
	jmp petlja

proveri_sledeci2:
	incl %esi
	cmpb $'s', (%esi)
	je proveri_sledeci3	
	cmpb $'t', (%esi)
	je proveri_sledeci
	incl %esi
	jmp petlja

proveri_sledeci3:
	incl %esi
	cmpb $'t', (%esi)
	je povecaj_brojac
	incl %esi
	jmp petlja

povecaj_brojac:
	incl ima_ponavljanja
	incl %esi
	jmp petlja

kraj_petlje:
	cmpl $0, ima_ponavljanja
	je nema_ponavljanja
	# ima ponavljanja		
	movl $4, %eax
	movl $1, %ebx
	leal string_ima, %ecx
	movl $string_ima_duzina, %edx
	int $0x80
	jmp kraj

nema_ponavljanja:
	movl $4, %eax
	movl $1, %ebx
	leal string_nema, %ecx
	movl $string_nema_duzina, %edx
	int $0x80

kraj:
	movl $1, %eax
	movl ima_ponavljanja, %ebx
	int $0x80
