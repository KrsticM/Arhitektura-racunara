#program za uneti string broji koliko ima nealfanumerika i zamenjuje ih nulom
#kao izlazni kod programa se vraca broj nealfanumerika
.section .data

MAX = 100

str1: .fill MAX,1,0  
str1_len: .long 0 

str2: .ascii "Unesite string: \0"
str2_len =.-str2 

str3: .ascii "Ispravljeni string: \0"

not_alphanum: .byte 0 # char not_alphanum = 0
# .long -> 32 bita ( int )
# .word -> 16 bita ( short int ) 
# .quad -> 64 bita ( long int )


.section .text
.globl main
main:

	# printf("Unesite string");
	movl $4, %eax # uvek
	movl $1, %ebx # uvek
	leal str2, %ecx # ucitava efektivnu adresu stringa u ecx - (L)oad (E)ffective (A)dress (L)ong
	movl $str2_len, %edx
	int $0x80

	# scanf("%s", string);
	movl $3, %eax # uvek
 	movl $0, %ebx #uvek
	leal str1, %ecx # ucitavanje adrese radi upisa
	movl $MAX, %edx # ocekivana maksimalna duzina
	int $0x80
	# kada se izvrsi upis, tada se duzina procitanih karaketra sa tastature upise u %eax
	movl %eax, str1_len

	# treba da prodjemo kroz nas uneti string i da zamenimo sve koji nisu slova ni brojevi sa '0'	

	leal str1, %esi # ucitavamo adresu stringa str1 u esi
			
 	# "dsadsadabhdba  dasdhhasda \10"

petlja:
	cmpb $10, (%esi) # poredim da li je ono sto se nalazi na esi = enter
	je kraj_stringa
	cmpb $48, (%esi) # '0' mogli smo $'0'
	jb nije_alfanum# jump if bellow 
	# ako je veci ili jedak propadamo dole
	cmpb $57, (%esi) # poredimo sa devetkom '9'
	jbe jeste_alfanum # jump if bellow or equal 
	cmpb $65, (%esi) # 'A'
	jb nije_alfanum
	cmpb $90, (%esi) # 'Z'
	jbe jeste_alfanum
	cmpb $97, (%esi) # 'a'
	jb nije_alfanum
	cmpb $122, (%esi) # 'z'
	jbe jeste_alfanum
	jmp nije_alfanum # bezuslovni skok, kada god dodjemo do ove linije skocicemo na nije_alfanum

jeste_alfanum:
	incl %esi # idemo na sledeci znak esi++
	jmp petlja		

nije_alfanum:
	incb not_alphanum # povecavamo not_alphanum za 1 odnosno brojimo koliko ima ne alfanumerika
	movb $'0', (%esi) # ubacice 48 na trenutno meesto u stringu na koje esi pokazuje
	incl %esi # prelazimo na sledei
	jmp petlja

kraj_stringa:
	movl $4, %eax
	movl $1, %ebx
	leal str1, %ecx
	movl str1_len, %edx
	int $0x80

end:
   movl $1, %eax
   movl $0, %ebx
   movb not_alphanum, %bl# izlazni kod programa # da bi videli u terminalu koji je ovo broj odma posle pokretanja programa pozovemo "echo $?"
   int $0x80

