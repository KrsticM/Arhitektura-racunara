# program treba da uneti string transformise u kamilju notaciju odnosno svako prvo slovo u svakoj recenici je velika
# sva ostala slova su mala
.section .data

string: .ascii "Unesite string: \0"
string_len = .-string

MAX = 101 # jedan vise karakter zbog \0
string2: .fill MAX, 1, 0 # kada ne brisemo nista kada samo menjamo iz malog u veliko slovo mozemo sve na jednom stringu

rec_pocela: .long 0 # nismo jos naisli na rec

duzina: .long 0 

.section .text
.globl main
main:
	#print
	movl $4, %eax
	movl $1, %ebx
	leal string, %ecx # movl $string, %ecx isto
	movl $string_len, %edx
	int $0x80

	#scanf
	movl $3, %eax
	movl $0, %ebx
	leal string2, %ecx
	movl $MAX, %edx
	int $0x80
	
	movl %eax, duzina		

	leal string2, %esi 

petlja:
	cmpb $10, (%esi)
	je kraj_petlje
	cmpb $' ', (%esi)
	je space			
	cmpb $'A', (%esi)
	jb preskoci
	cmpb $'Z', (%esi)
	jbe veliko_slovo		
	cmpb $'a', (%esi)			
	jb preskoci
	cmpb $'z', (%esi)
	jbe mala_slovo
	jmp preskoci

space: 
	movl $0, rec_pocela
	incl %esi
	jmp petlja	

preskoci:
	incl %esi
	jmp petlja

mala_slovo: # ako je rec pocela preskacemo, u slucaju da rec nije pocela pretvaramo malo slovo u veliko i kazemo da je rec pocela
	cmpl $1, rec_pocela # poredimo rec_pocela i 1	
	je preskoci	
	# u slucaju da rec nije pocela i naisli smo na malo slovo
	subb $32, (%esi) # pretvaranja malog slova u veliko
	movl $1, rec_pocela # 1 je indikator da je rec pocela
	incl %esi
	jmp petlja

veliko_slovo:
	cmpl $0, rec_pocela
	je prepreskok # ako rec nije pocela i naisao sam na veliko slovo ne treba da ga menjam nego samo preskacem	
	# ovde dolazimo u slucaju da je rec pocela odnosno nismo na prvoj poziciji u reci
	addb $32,(%esi) # pravimo malo slovo
	movl $1, rec_pocela # ovo nije potrebno jer je u rec_pocela vec 1
	incl %esi 
	jmp petlja			

prepreskok:
	movl $1, rec_pocela
	jmp preskoci

kraj_petlje:
	movl $4, %eax
	movl $1, %ebx
	leal string2, %ecx
	movl duzina, %edx
	int $0x80
kraj:
	movl $1, %eax
	movl $0, %ebx
	int $0x80




