
;Universidad del Valle de Guatemala
;Francis Aguilar 22243, Gerardo Pineda 22880, Diego Garcia 22484
;Descripcion: Proyecto 4
;Fecha de Entrega: 2/06/2023

.386
.model flat, c
.stack 4096
ExitProcess proto,dwExitCode:dword




.data
    tablero BYTE "-----------------", 0Ah, "| %s | %s | %s | %s |", 0Ah, "-----------------", 0Ah, "| %s | %s | %s | %s |", 0Ah, "-----------------", 0Ah, "| %s | %s | %s | %s |", 0Ah, "-----------------", 0Ah, "| %s | %s | %s | %s |", 0Ah, "-----------------", 0Ah, 0
    
    ;Estos son para probar mostrar el tablero, despues se pueden borrar
    prueba1 BYTE "1",0
    prueba2 BYTE "2",0
    prueba3 BYTE "3",0
    prueba4 BYTE "4",0
    prueba5 BYTE " ",0
    randomSeed		DWORD 18
	randomNum		DWORD ?
	maximo		DWORD 4
    contMine dword 0
    arr dword 1,2,3,4,5,6
    arrb db 1,2,3,4,5,6
    positionMine1 dword 0,0
    positionMine2 dword 0,0
    pos dword 0
    pos2 dword 0

.code
    includelib libucrt.lib
    includelib legacy_stdio_definitions.lib
    includelib libcmt.lib
    includelib libvcruntime.lib

    extrn printf:near
    extrn scanf:near
    extrn exit:near
    ;printf proto c : vararg 	; To print to std output.
    ;scanf proto c : vararg 		; To read from std input.
    system proto c : vararg 	; To clear the console screen.
    rand proto c : vararg 		; To getting a random number.
    srand proto c : vararg 	

public main
main proc
    push ebp
    mov ebp, esp

    call randomPositionMine

    mov ebx, 4
    imul ebx, randomNum
    mov eax, [arr+ebx]

    push offset prueba1      ;Imprime el tablero
    push offset prueba2
    push offset prueba3
    push offset prueba5
    push offset prueba4
    push offset prueba2
    push offset prueba5
    push offset prueba1
    push offset prueba5
    push offset prueba4
    push offset prueba4
    push offset prueba5
    push offset prueba1
    push offset prueba3
    push offset prueba2
    push offset prueba1
    push offset tablero
    call printf

    add esp, 68

    mov esp, ebp
    pop ebp
    
	push 0
    call exit ;

main endp

randomPositionMine proc

position1:
    ;Mina 1, posicion 1
    ;en el arr positionMine1 se ingresa la primera posicion
    xor eax,eax  ; vuleve eax = 0
    rol ecx,8 ;Se invierten los bits de un numero x
    xor edx,ecx ;Hace un xor entre los dos registros
    xor randomSeed,edx ;Deoues hace el xor con la seed y la guarda en la seed

	invoke srand, randomSeed ;Le ingresa la seed a srand
    invoke rand ; a eax se le asigna rand
	mov ebx, maximo ;Ingresa el maximo a ebx
	SUB EDX, EDX
	div ebx 

    ;Le agrega la posicion al arreglo
	mov [positionMine1], edx
    
    ;Aqui compara si es 0
    cmp contMine, 0
    je position2
    jne finish

position2:
    ;Mina 1, posicion 2
    xor eax,eax  
    rol ecx,8
    xor edx,ecx
    xor randomSeed,edx 

	invoke srand, randomSeed
    invoke rand
	mov ebx, maximo
	SUB EDX, EDX
	div ebx 
    ;Segunda posicion
	mov [positionMine1+4], edx

    ;Mina 2, posicion 1
    xor eax,eax  
    rol ecx,8
    xor edx,ecx
    xor randomSeed,edx 

	invoke srand, randomSeed
    invoke rand
	mov ebx, maximo
	SUB EDX, EDX
	div ebx 

	mov [positionMine2], edx

    ;Mina 2, posicion 2
    xor eax,eax  
    rol ecx,8
    xor edx,ecx
    xor randomSeed,edx 

	invoke srand, randomSeed
    invoke rand
	mov ebx, maximo
	SUB EDX, EDX
	div ebx 

	mov [positionMine2+4], edx
    
    inc contMine

finish:
    
    mov eax, [positionMine1]
    mov ebx, [positionMine2]
    cmp eax, ebx
    je position1

    ret

randomPositionMine endp

end