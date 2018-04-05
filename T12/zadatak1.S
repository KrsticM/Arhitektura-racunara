# Data su dva niza od po 5 clanova, taj broj clanova je zadat u konstanti NELEM
# Proveriti da li imaju zajednicke elemente, nema ponavljanja elemenata u nizu
.section .data

NELEM = 5 # konstanta 5 

niz1: .long 1,2,3,4,5 # niz od 5 elemenata
niz2: .long 1,2,8,9,10

jednakih: .long 0

string_ima: .ascii "Ima jednakih! \0"  
string_ima_duzina = .-string_ima

string_nema: .ascii "Nema jednakih! \0"
string_nema_duzina = .-string_nema

.section .text
.globl main

main:
	# Provera da li su nizovi prazni
	movl $NELEM, %eax
	cmpl $0, %eax
	je kraj 

	movl $0, %ebx # brojac za prvi "for"
spoljasnja_petlja:
	movl niz1(,%ebx,4), %eax

	movl $0, %ecx # brojac za unutrasnji "for"
unutrasnja_petlja:
	movl niz2(,%ecx,4), %edx

	cmpl %eax, %edx
	je povecaj_jednake
	# ako nisu jednaki propadamo ovde
povratak:	
	incl %ecx # %ecx++
	cmpl $NELEM, %ecx
	jl unutrasnja_petlja
	# ako je vece ili jednako
	incl %ebx
	cmpl $NELEM, %ebx
	jl spoljasnja_petlja
	# ako propadnemo ovde prosli smo kroz ceo niz1
	
	cmpl $0, jednakih
	je nema_jednakih
	# ako ima jednakih
	# ispisacemo ima jednakih
ima_jednakih:
	movl $4, %eax
	movl $1, %ebx
	leal string_ima, %ecx # komanda load effective address 
	movl $string_ima_duzina, %edx
	int $0x80
	jmp kraj

povecaj_jednake:
	incl jednakih
	jmp povratak

nema_jednakih:
	#  ispisacu nema jednakih
	movl $4, %eax
	movl $1, %ebx
	leal string_nema, %ecx # movl $string_nema
	movl $string_nema_duzina, %edx
	int $0x80
	jmp kraj

kraj:
	movl $1, %eax
	movl jednakih, %ebx # izlazni kod programa u terminalu se proverava sa echo $? 
	int $0x80 	    # bitno je da se komanda echo $? pozove odma nakon izversavanja programa

