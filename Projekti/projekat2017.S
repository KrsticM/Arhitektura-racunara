.section .data
unos_poruka:
	.ascii "Unesite izraz: "
unos_poruka_len = .-unos_poruka
zbir_poruka:
	.ascii "Rezultat: "
zbir_poruka_len = .-zbir_poruka
gr_prekoracenje:
	.ascii "Prekoracenje!"
gr_prekoracenje_len = .-gr_prekoracenje
gr_cifra:
	.ascii "Pogresna cifra!"
gr_cifra_len = .-gr_cifra
gr_prazan:
	.ascii "Prazan izraz!"
gr_prazan_len = .-gr_prazan

minus_str: 
	.ascii "-"
minus_str_len = .-minus_str

newline: .ascii "\n"
newline_len = .-newline

max_duzina = 101
radni_string: .fill max_duzina,1,0
bez_razmaka: .fill max_duzina,1,0
operacija: .long 0 # 0 - nema operacije 1 - sabiranje 2 - oduzimanje 3 - mnozenje 4 - deljenje
baza: .long 16
predznak1: .long 1 # pozitivan je
predznak2: .long 1 # pozitivan je
broj1: .long 0
broj2: .long 0
rez_op: .long 0
predznak_rez: .long 0 #pozitivno

max_izlaz = 10
string_izlaz: .fill max_izlaz,1,0

.section .text
.globl main

main:
	movl $4, %eax
	movl $1, %ebx
	leal unos_poruka, %ecx # movl $string, %ecx
	movl $unos_poruka_len, %edx
	int $0x80

	movl $3, %eax
	movl $0, %ebx
	leal radni_string, %ecx
	movl $max_duzina, %edx
	int $0x80

#imamo uneti string
#prvo izbacimo razmake
	leal radni_string, %esi  # adresa prvog znaka stringa u %esi
	cmpb $10, (%esi)
	je prazan_string 
	xorl %ecx, %ecx

	leal bez_razmaka, %edi
	xorl %edx, %edx # nije neophodno
labela1:
	cmpb $10, (%esi)
	je kraj_izbacivanja
	cmpb $' ', (%esi)
	jne prepisi
	#ako je razmak ne prepisuj ga u string bez_razmaka
	incl %esi
	jmp labela1
prepisi:
	movb (%esi), %dl 
	movb %dl, (%edi)
	incl %edi
	incl %esi
	jmp labela1
kraj_izbacivanja:
	movb $0, (%edi) # znak za kraj stringa na kraj stringa bez_razmaka
#pretvaranje svih slova u velika
	leal bez_razmaka, %esi 
labela2:
	cmpb $0, (%esi)
	je kraj_pretvaranja
	cmpb $'a', (%esi)
	jb preskoci
	cmpb $'z', (%esi)
	jbe malo_slovo
	incl %esi
	jmp labela2 		
preskoci:
	incl %esi
	jmp labela2
malo_slovo:
	subb $32, (%esi)
	incl %esi
	jmp labela2
kraj_pretvaranja:

	leal bez_razmaka, %esi
	xorl %eax, %eax # rezultat konverzije
	xorl %ebx, %ebx
labela3:
	movb (%esi), %bl
	andb %bl, %bl
	jz kraj_konverzije	
	cmpb $'*', %bl
	jb pogresna_cifra
	je operacija_mnozenje
	cmpb $'+', %bl
	je operacija_sabiranje
	cmpb $',', %bl
	je pogresna_cifra
	cmpb $'-', %bl
	je operacija_oduzimanje
	cmpb $'.', %bl
	je pogresna_cifra
	cmpb $'/', %bl
	je operacija_deljenje
	cmpb $'9', %bl
	jbe konvertuj_cifru
	cmpb $'A', %bl 
	jb pogresna_cifra
	cmpb $'F', %bl
	jbe konvertuj_znak
	jmp pogresna_cifra
operacija_mnozenje:
	movl $3, operacija 
	movl %eax, broj1
	xorl %eax, %eax
	incl %esi	
	jmp labela3
operacija_sabiranje:
	movl %eax, broj1
	xorl %eax, %eax
	movl $1, operacija
	incl %esi
	jmp labela3
operacija_oduzimanje:
	cmpl $0, operacija # ako je operacija vec nadjena
	ja postavi_predznak2_na_minus
	cmpl $0, %eax
	je postavi_predznak1_na_minus
	movl %eax, broj1
	xorl %eax, %eax
	movl $2, operacija # ako radimo sa .byte operacijom movb (%esi)
	incl %esi
	jmp labela3
postavi_predznak1_na_minus:
	movl $-1, predznak1
	incl %esi
	jmp labela3
postavi_predznak2_na_minus:
	movl $-1, predznak2
	incl %esi
	jmp labela3
operacija_deljenje:
	movl $4, operacija
	movl %eax, broj1
	xorl %eax, %eax
	incl %esi
	jmp labela3
konvertuj_cifru:
	subb $48, %bl
	mull baza
	cmpl $0, %edx
	jne prekoracenje
	addl %ebx, %eax
	jc prekoracenje
	incl %esi
	jmp labela3	
konvertuj_znak:
	subb $55, %bl
	mull baza
	cmpl $0, %edx
	jne prekoracenje
	addl %ebx, %eax
	jc prekoracenje
	incl %esi
	jmp labela3	
kraj_konverzije:
#mnozenje brojeva sa njihovim predznacima
	cmpl $1, predznak2 # ako je drugi broj pozitivan
	jne preskoci_2
	#da li je veci od 7fffffff
	cmpl $0x7fffffff, %eax # u eax je broj 2 jer se on tamo smesta na kraju konverzije
	ja prekoracenje
preskoci_2:
	mull predznak2
	movl %eax, broj2
	movl broj1, %eax
	cmpl $1, predznak1
	jne preskoci_3
	cmpl $0x7fffffff, %eax
	ja prekoracenje
preskoci_3:
	mull predznak1
	movl %eax, broj1
##
	cmpl $1, operacija # ukoliko bi radili sa .byte operacijom onda cmpb
	je saberi_ih
	cmpl $2, operacija
	je oduzmi_ih
	cmpl $3, operacija
	je pomnozi_ih
	cmpl $4, operacija
	je podeli_ih
saberi_ih:
	movl broj1, %eax
	movl broj2, %ebx
	addl %ebx, %eax
	jo prekoracenje # jo jer su eax i ebx oznaceni
	movl %eax, rez_op
	jmp konverzija_interni_znakovni
oduzmi_ih:
	movl broj1, %eax
	movl broj2, %ebx
	subl %ebx, %eax # eax = eax - ebx
	movl %eax, rez_op
	jmp konverzija_interni_znakovni
pomnozi_ih:
	movl broj1, %eax
	movl broj2, %ebx
	imull %ebx # imull zbog oznacenih
	#cmpl $0, %edx
	#jne prekoracenje
	movl %eax, rez_op
	jmp konverzija_interni_znakovni
podeli_ih:
	xorl %edx, %edx
	movl broj1, %eax
	movl broj2, %ebx
	cmpl $0, %ebx
	je prekoracenje
	idivl %ebx # idivl zbog oznacenih
	movl %eax, rez_op
	jmp konverzija_interni_znakovni
negiraj_ga:
	negl %eax
	jmp labela4
konverzija_interni_znakovni:
	leal string_izlaz, %edi
	movl rez_op, %eax # broj za konvertovanje
	testl $0x80000000, %eax
	jnz negiraj_ga
labela4:
	xorl %edx, %edx
	divl baza
	# ostatak u %dl
	cmpb $9, %dl
	jbe cifra
	cmpb $15, %dl
	jbe znak

cifra:
	addb $48, %dl
	movb %dl, (%edi)
	incl %edi
	andl %eax, %eax
	jz obrtanje
	jmp labela4
znak:		
	addb $55, %dl
	movb %dl, (%edi)
	incl %edi
	andl %eax, %eax
	jz obrtanje
	jmp labela4
obrtanje:
	movb $0, (%edi)
	decl %edi 
	leal string_izlaz, %esi
obrni:
	cmpl %edi, %esi
	jae kraj_obrtanja	
	movb (%esi), %ah
	movb (%edi), %al
	movb %al, (%esi)
	movb %ah, (%edi)
	decl %edi
	incl %esi
	jmp obrni
kraj_obrtanja:

	movl $4, %eax
	movl $1, %ebx
	leal zbir_poruka, %ecx
	movl $zbir_poruka_len, %edx
	int $0x80

	movl rez_op, %eax 
	testl $0x80000000, %eax #andl
	jnz negativan_rezultat
	
	#ako je rezultat pozitivan
	movl $4, %eax
	movl $1, %ebx
	leal string_izlaz, %ecx
	movl $max_izlaz, %edx
	int $0x80

	movl $4, %eax		#newline
	movl $1, %ebx
	leal newline, %ecx
	movl $newline_len, %edx
	int $0x80

	movl $0, %ebx

	jmp kraj


negativan_rezultat:
	movl $4, %eax
	movl $1, %ebx
	leal minus_str, %ecx
	movl $minus_str_len, %edx
	int $0x80	
	
	movl $4, %eax
	movl $1, %ebx
	leal string_izlaz, %ecx
	movl $max_izlaz, %edx
	int $0x80

	movl $4, %eax		#newline
	movl $1, %ebx
	leal newline, %ecx
	movl $newline_len, %edx
	int $0x80

	movl $0, %ebx

	jmp kraj


prekoracenje:	
	movl $4, %eax
	movl $1, %ebx
	leal gr_prekoracenje, %ecx
	movl $gr_prekoracenje_len, %edx
	int $0x80

	movl $4, %eax		#newline
	movl $1, %ebx
	leal newline, %ecx
	movl $newline_len, %edx
	int $0x80
	
	movl $1, %ebx
	
	jmp kraj			
pogresna_cifra:
	movl $4, %eax
	movl $1, %ebx
	leal gr_cifra, %ecx
	movl $gr_cifra_len, %edx
	int $0x80

	movl $4, %eax		#newline
	movl $1, %ebx
	leal newline, %ecx
	movl $newline_len, %edx
	int $0x80
	
	movl $1, %ebx
	
	jmp kraj
prazan_string:
	movl $4, %eax
	movl $1, %ebx
	leal gr_prazan, %ecx
	movl $gr_prazan_len, %edx
	int $0x80

	movl $4, %eax		#newline
	movl $1, %ebx
	leal newline, %ecx
	movl $newline_len, %edx
	int $0x80	

	movl $1, %ebx
	
	jmp kraj	
kraj:
	movl $1, %eax
	int $0x80

