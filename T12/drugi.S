.section .data

BROJ_ELEMENATA = 4
niz:	.quad -5000000001, 20, 34, 6000000005

donja:	.quad -5000000000 # i granice se sastoje od nizeg i viseg dela donja donja+4

gornja:	.quad 6000000000 # gornja gornja+4

van_opsega:	.long 0

.section .text
.globl main
main:
	movl $0, %ecx # i = 0
pocetak:
	movl niz(,%ecx,8), %ebx # niz + ecx * (8 * 4) # Nizi deo
	movl niz+4(,%ecx,8), %eax # kada uradimo niz+4 na niz dodamo 4 bajta odnosno prelazimo na visi deo # Visi deo

donja_g:                      #proverava da li je broj manji od donje granice
	cmpl donja+4, %eax # poredimo prvo vise delove
	jl uvecaj # jump if lower ako je eax < donja+4
	jg gornja_g # jump if greater ako je veci od donje granice idemo na poredjenje sa gornjom
	cmpl donja, %ebx # ovde dolazimo u slucaj kada su visi delovi jednaku
	jl  uvecaj
gornja_g:                     #proverava da li je broj veci od gornje granice
	cmpl gornja+4, %eax
	jg uvecaj
	jl sledeci
	cmpl donja, %ebx # ako su gornji delovi jednaki poredimo donje
	jg uvecaj # ako je donji deo veci ipak je van opsega 
	jmp sledeci
	# ovde bi trebali da skocimo na sledeci

uvecaj:                       #povecava van_opsega ukoliko broj nije u opsegu
	incl van_opsega # broj je van opsega
sledeci:                      #prelazak na sledeci element niza
	incl %ecx
	cmpl $BROJ_ELEMENATA, %ecx # broj_elemenata = 4, ecx = 0,1,2,3, ( 4 - izlazak iz petlje )
	jl   pocetak # jump if lower, vrtimo se sve dok je ecx < 4
	
end: 
	movl $1, %eax
	movl van_opsega, %ebx
	int $0x80

