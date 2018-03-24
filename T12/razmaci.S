# Uklanjanje razmaka sa početka i kraja stringa
# Imenko Prezimić ra1234

# da bi smo u DDD prikazali string idemo na Data -> Memory -> unese se koliklo zelimo karaktera 
# zatim char pa byte i na kraju se stavi &naziv stringa
.section .data
string: .ascii "    Neki tekst   \0"
string_len = .-string

razmaka_izbaceno: .long 0
prava_duzina: .long 0
.section .text
.globl main
main:
    movl $string, %eax # ekvivalent ovome je leal string, %eax
kraj_s:
    cmpb $0, (%eax) # kraj stringa kada je string u programu zadat
    # da je string unosen sa tastature bilo bi $10 
    je razmacik
    incl %eax # pomeramo se na sledeci karakter
    jmp kraj_s

# trenutno %eax pokazuje na \0
razmacik:
    cmpb $' ', -1(%eax)  # -1 znaci da poredimo jedan element pre %eax 
    je izbacik # ako nije space 
	# ako nije razmak pre trenutnog
	movb $0, (%eax)
	incl razmaka_izbaceno
   	jmp razmacip
izbacik: # izbacujemo razmak sa kraja
	incl razmaka_izbaceno # jedan vise izbacen razmak znaci da ce string biti jedan karakter manji
    movb $0, (%eax) # upisujemo 0 na mesto gde je bio space odnosno brisemo ga 
    decl %eax 
	jmp razmacik

razmacip: # radimo sve dok je na prvoj poziciji space
    movl $string, %eax  #spoljašnja petlja
    cmpb $' ', (%eax)
    jne kraj # ako nije space, kraj programa
	# u slucaju da jeste space ide se na izbacip
	incl razmaka_izbaceno
izbacip:
    cmpb $0, (%eax)     #unutrašnja petlja
    je razmacip
    movb 1(%eax), %bl # pomocu 1(%eax) dobijamo naredni karakter u odnosu na (%eax) 
    movb %bl, (%eax) # na mesto trenutnog karaktera stavljamo naredni
    incl %eax # pomeramo se na sledeci karakter kako bi njega prebacili jedno mesto u levo
    jmp izbacip
kraj:
	# prepracunavanje prave duzine
	movl $string_len, %eax
	subl razmaka_izbaceno, %eax # eax - raz = eax
	movl %eax, prava_duzina

	# istampamo rezultat radi provere
    movl $4, %eax
    movl $1, %ebx
    leal string, %ecx
    movl prava_duzina, %edx
    int $0x80

    movl $1, %eax
    movl $0, %ebx
    int $0x80

