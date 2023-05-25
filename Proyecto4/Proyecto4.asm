
;Universidad del Valle de Guatemala
;Francis Aguilar 22243, Gerardo Pineda 22880, Diego Garcia 22484
;Descripcion: Proyecto 4
;Fecha de Entrega: 2/06/2023

.386
.model flat, c
.stack 4096
ExitProcess proto,dwExitCode:dword


.data
    bienvenida byte "Bienvenido al juego de buscaminas",0Ah,"Instrucciones: ",0Ah,"1) Ingrese la columna y fila que quiere seleccionar ",0Ah,0
    tablero BYTE "----------------------", 0Ah, "- | 0 | 1 | 2 | 3 |", 0Ah,"----------------------", 0Ah, "0 | %s | %s | %s | %s |", 0Ah, "----------------------", 0Ah, "1 | %s | %s | %s | %s |", 0Ah, "----------------------", 0Ah, "2 | %s | %s | %s | %s |", 0Ah, "----------------------", 0Ah, "3 | %s | %s | %s | %s |", 0Ah, "----------------------", 0Ah, 0
    top byte "-----------------",0Ah,0
    writeString byte "| %s |",0
    writeDouble byte "| %d |",0
    ;Estos son para probar mostrar el tablero, despues se pueden borrar
    pedirColumna byte "Ingrese la fila: ",0
    pedirFila byte "Ingrese la Columna: ",0
    fmt db "%d",0
    ;
    columna dword 0
    fila dword 0
    ;
    comparador byte "s"
    ;
    arrBombas byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    arrTablero byte "s","s","s","s","s","s","s","s","s","s","s","s","s","s","s","s"
    contTurnos byte 0
    ;
    contFor byte 0
    contArr dword 0
    ;
    ;pos 0: fila y pos 1: columna
    positionMine1 dword 0,0
    positionMine2 dword 0,0
    positionMineX dword 0,0
    contPosition dword 0
    minaVista dword 0
    contMine dword 0
    ;
    randomSeed		DWORD 18
	randomNum		DWORD ?
    maximo		DWORD 4
    ;

    prueba1 BYTE "1",0
    prueba2 BYTE "2",0
    prueba3 BYTE "3",0
    prueba4 BYTE "4",0
    prueba5 BYTE " ",0
    
	
    
    arr dword 1,2,3,4,5,6
    arrb db 1,2,3,4,5,6
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

    push offset bienvenida
    call printf
    add esp, 4

    call randomPositionMine
    call showEmptyBoard
    call userInteraction

    mov ah, [arrBombas]
    mov ah, [arrBombas+1]
    mov ah, [arrBombas+2]

probar:
    mov ebx, contArr
    mov ah, [arrBombas+ebx]
    inc contArr
    cmp contArr, 16
    jne probar

   ; mov ah, prueba
   ;Prueba para comparar Strings
    mov ah, comparador
    cmp ah, [arrTablero+1]
    je lbl1
    jne lbl2

lbl1:
    mov eax, 20
    mov eax, 2
lbl2:
    mov eax, 10

    ;El resto

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

userInteraction proc

    ;Columna
    push offset pedirColumna
    call printf
    add esp, 4
    
    lea  eax, columna  ; Obtener dirección del buffer
    push eax 				; Empujar dirección a la pila
    push offset fmt 		; Empujar formato a la pila
    call scanf 				; Leer cadena desde la entrada estándar
    add esp, 8

    ;Fila
    push offset pedirFila
    call printf
    add esp, 4

    lea  eax, fila  ; Obtener dirección del buffer
    push eax 				; Empujar dirección a la pila
    push offset fmt 		; Empujar formato a la pila
    call scanf 				; Leer cadena desde la entrada estándar
    add esp, 8
    
userInteraction endp

showEmptyBoard proc
    
    #Esto se podria cambiar para que imprima de forma dinamica

    mov contFor, 0
    cmp contTurnos, 0
    je inicio
    jne fin

inicio:
    push offset prueba5    ;Imprime el tablero

    inc contFor

    cmp contFor, 16
    jne inicio
    
    push offset tablero
    call printf
    add esp, 68
jugando:
    
fin:

    ret

showEmptyBoard endp

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
	SUB EDX, EDX ;edx = 0
	div ebx ;residio se va edx

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

    call MinesPosition

    ret

randomPositionMine endp

MinesPosition proc
    

    ;Se busca la posicion de la mina 1
    ;Antes estaba: mov eax, [positionMine1]
    mov eax, [positionMine1+4]
    imul eax, 4
    ;Antes estaba: add eax, [positionMine1+4]
    add eax, [positionMine1]
    ;Se agrega la mina
    mov [arrBombas+eax], "m"
    mov bh, [arrBombas+eax]


    ;Se busca la posicion de la mina 2
    ;Antes estaba: mov eax, [positionMine2]
    mov eax, [positionMine2+4]
    imul eax, 4
    ;Antes estaba: add eax, [positionMine2+4]
    add eax, [positionMine2]
    ;Se agrega la mina
    mov [arrBombas+eax], "m"
    mov bh, [arrBombas+eax]



inicio:
    ;contPosition
    cmp contPosition, 0
    je Mina1
    jne Mina2

Mina1:
    ;Mueve el valor de la posicion 0 de la mina 1 a la mina x
    mov eax, [positionMine1]
    mov [positionMineX], eax

    ;Mueve el valor de la posicion 1 de la mina 1 a la mina x
    mov eax, [positionMine1+4]
    mov [positionMineX+4], eax

    jmp seguir

Mina2:
    ;Mueve el valor de la posicion 0 de la mina 2 a la mina x
    mov eax, [positionMine2]
    mov [positionMineX], eax

    ;Mueve el valor de la posicion 1 de la mina 2 a la mina x
    mov eax, [positionMine2+4]
    mov [positionMineX+4], eax

    jmp seguir

seguir:
    ;Contador de la posicion de las minas
    ;Como un buscaminas normal
    ;Coloca las bombas que hay al rededor
    mov eax, [positionMineX+4]
    imul eax, 4
    add eax, [positionMineX]
    mov minaVista, eax
    mov eax, minaVista

    .IF eax > 3  ;Si es menor a 4 significa que no existe parte de arriba del busca minas
        ;Calcuar esquinas

        ;Se incrementa el numero de arriba de la bomba
        mov eax, minaVista
        sub eax, 4
        mov bh, [arrBombas+eax]

        .IF bh != "m"
            inc [arrBombas+eax]
        .ENDIF

        ;Fila x columna
        mov eax, [positionMineX] ;Si la fila es 0 significa que no hay nada a la izquierda
        .IF eax != 0
            ;Se incrementa el numero de arriba la izquierda
            mov eax, minaVista
            sub eax, 5
            mov bh, [arrBombas+eax]
            
            .IF bh != "m"
                inc [arrBombas+eax]
            .ENDIF

        .ENDIF

        mov eax, [positionMineX]

        .IF eax != 3 ;Si es 3 significa que no existe nada a la derecha
            ;Se incrementa el numero de arriba la derecho de la bomba
            mov eax, minaVista
            sub eax, 3
            mov bh, [arrBombas+eax]
            
            .IF bh != "m"
                inc [arrBombas+eax]
            .ENDIF

        .ENDIF
        
    .ENDIF

    ;Derecha o izquierda
    mov eax, [positionMineX]
    .IF eax != 0 ;Si es cero significa que no existe parte izquierda
        mov eax, minaVista
        sub eax, 1
        mov bh, [arrBombas+eax]
            ;Se incrementa 1 en la parte de la izquierda
        .IF bh != "m"
            inc [arrBombas+eax]
        .ENDIF
    .ENDIF

    mov eax, [positionMineX]
    .IF eax != 3 ;Si es 3 significa que no existe parte de la derecha
        mov eax, minaVista
        add eax, 1
        mov bh, [arrBombas+eax]
            ;Se incrementa 1 en la parte de la derecha
        .IF bh != "m"
            inc [arrBombas+eax]
        .ENDIF
    .ENDIF

    ;Movimiento para abajo
    mov eax, minaVista
    .IF eax < 12  ;Si es mayor a 12 significa que no existe parte de abajo
        
        ;Se incrementa uno en la parte de abajo
        mov eax, minaVista
        add eax, 4
        mov bh, [arrBombas+eax]

        .IF bh != "m"
            inc [arrBombas+eax]
        .ENDIF

         mov eax, [positionMineX] ;Si la columna es 0 significa que no hay nada a la izquierda
        .IF eax != 0
            ;Se incrementa el numero de abajo a la izquierda
            mov eax, minaVista
            add eax, 3
            mov bh, [arrBombas+eax]
            
            .IF bh != "m"
                inc [arrBombas+eax]
            .ENDIF

        .ENDIF

        mov eax, [positionMineX]
        .IF eax != 3 ;Si es 3 significa que no existe nada a la derecha
            ;Se incrementa el numero de abajo la derecho de la bomba
            mov eax, minaVista
            add eax, 5
            mov bh, [arrBombas+eax]
            
            .IF bh != "m"
                inc [arrBombas+eax]
            .ENDIF

        .ENDIF
   
    .ENDIF
    
    inc contPosition

    cmp contPosition, 1
    je Mina2
    
    ;Arreglo horizontal
    ;posicionMinaX
    ;
    
    ;Se puede incrementar asi
    ;inc [arrBombas]
    
    ;Se puede comparar
    ;cmp [arrBombas], 1

    ret

MinesPosition endp


end