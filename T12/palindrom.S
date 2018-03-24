.section .data

string: .ascii "Unesite string: \0"
string_len = .-string

MAX = 101 # jedan vise karakter zbog \0
string2: .fill MAX, 1, 0

string3: .fill MAX, 1, 0 # filtrirani string

string4: .ascii "Nije palindrom! \0"
string4_len = .-string4

string5: .ascii "Jeste palindrom!\0"
string5_len = .-string5


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

	#idemo na filtriranje stringa odnosno izbacujemo sve sto nisu slova
	#plus sva sloba pretvaram u mala
	leal string2, %esi 
	leal string3, %edi # string u koji prebacujemo samo ono sto zelimo - filtriran string

filtar:
	cmpb $10, (%esi)
	je kraj_filtra	
	cmpb $'A', (%esi)
	jb preskoci
	cmpb $'Z', (%esi)
	jbe veliko_slovo		
	cmpb $'a', (%esi)			
	jb preskoci
	cmpb $'z', (%esi)
	jbe mala_slovo
	jmp preskoci

preskoci:
	incl %esi
	jmp filtar

mala_slovo:
	# movb (%esi), (%edi)
	movb (%esi), %bl
	movb %bl, (%edi)
	incl %esi
	incl %edi
	jmp filtar

veliko_slovo:
	addb $32, (%esi)
	jmp mala_slovo			

kraj_filtra:
	movl $10, (%edi) # samo jos kraj stringa da stavim u edi

	# provera
	movl $4, %eax
	movl $1, %ebx
	leal string3, %ecx
	movl $MAX, %edx
	int $0x80

leal string3, %esi # pokazivac na pocetak
leal string3, %edi # od ovog cemo napraviti pokazivac na kraj

# idemo da od edi napravimo pokazivac na kraj
iter:
	cmpb $10, (%edi)
	je kraj_iter
	incl %edi
	jmp iter

kraj_iter:
	# trenutno edi pokazuje na 10
	# zelim da mi pokazuje na jedan karakter pre desetke
    decl %edi # sada edi pokazuje na jedan karakter pre desetke
	
provera_palindroma:
	cmpl %esi, %edi 
	jle kraj_provere # u slucaju da je edi <= esi	
	# cmpb (%esi), (%edi)	
	movb (%esi), %bl
	cmpb %bl, (%edi)
	je inkrement_pa_provera 
	jmp nije_palindrom

inkrement_pa_provera:
	incl %esi
	decl %edi
	jmp provera_palindroma

nije_palindrom:
	movl $4, %eax
	movl $1, %ebx
	leal string4, %ecx
	movl $string4_len, %edx
	int $0x80
	jmp kraj

kraj_provere: # kada smo dosli da su se esi i edi ili poklopili ili preskocili onda je nas string sigurno palindrom
	movl $4, %eax
	movl $1, %ebx
	leal string5, %ecx
	movl $string5_len, %edx
	int $0x80		
	jmp kraj

kraj:
	movl $1, %eax
	movl $0, %ebx
	int $0x80
