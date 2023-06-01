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
    tablero BYTE "-------------------", 0Ah, "- | 0 | 1 | 2 | 3 |", 0Ah,"-------------------", 0Ah, "0 |   |   |   |   |", 0Ah, "-------------------", 0Ah, "1 |   |   |   |   |", 0Ah, "-------------------", 0Ah, "2 |   |   |   |   |", 0Ah, "-------------------", 0Ah, "3 |   |   |   |   |", 0Ah, "-------------------", 0Ah, 0
    top byte "-------------------",0Ah,0
    perder byte "F perdiste :(", 0Ah, 0
    ganarM byte "Yeii ganaste :)", 0Ah, 0
    validarM byte "Por favor ingrese una fila / columna valida ", 0Ah, 0
    writeString byte " %s |",0
    writeDouble byte " %d |",0
    entr byte " ", 0Ah, 0
    blank BYTE " ",0
    encFila0 BYTE "0 |",0
    encFila1 BYTE "1 |",0
    encFila2 BYTE "2 |",0
    encFila3 BYTE "3 |",0
    first BYTE "- | 0 | 1 | 2 | 3 |", 0Ah, 0
    bomb dword 2
    perflag byte 0
    ;
    pedirColumna byte "Ingrese la columna: ",0
    pedirFila byte "Ingrese la fila: ",0
    fmt db "%d",0
    ;
    columna dword 0
    fila dword 0
    ;
    comparador byte "d"
    comparador2 byte "s"
    ;
    arrBombas byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    arrTablero byte "s","s","s","s","s","s","s","s","s","s","s","s","s","s","s","s"
    contCasillas dword 0    ; contar cuantas casillas se muestran, si hay 13 gana
    compCasillas dword 13
    ;
    contTurnos byte 0
    contFor byte 0
    contArr dword 0
    showMe dword 0
    ;
    ;pos 0: fila y pos 1: columna
    positionMine1 dword 0,0
    positionMine2 dword 0,0
    positionMineX dword 0,0
    ; tester
    posiM1 dword 0
    posiM2 dword 0
    pruebaPrint byte "%d %d", 0Ah, 0
    ;
    contPosition dword 0
    minaVista dword 0
    contMine dword 0
    ;
    randomSeed		DWORD 18
	randomNum		DWORD ?
    maximo		DWORD 4
    
	
    
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
    
; --------------- aqui inicia el juego -------------- 
main proc ; juego principal 

    call randomPositionMine     ; coloca las minas 
    push offset tablero
    call printf
    add esp,4

inicio:                         ; empieza el juego 
    mov contArr, 0
    mov eax, contCasillas       ; valida si ya muestra 13 casillas
    cmp eax, compCasillas 
    je ganar                    ; si las muestra gana
    jmp seguir                  ; si no, sigue

validar:                    
    push offset validarM        ; mensaje de validacion       
    call printf
    add esp, 4

seguir:
    call datos                  ; obtiene los datos de fila y col ingresados por el usuario

    cmp fila, 4                 ; validar que sea solo valores de 0 - 3 
    jge validar
    cmp columna, 4
    jge validar

    mov eax, [positionMine1]
    cmp eax, fila               ; comparas la fila con la mina 1 
    jne mina2                   ; si no son iguales, de una pasa a verificar mina 2 

    mov eax, [positionMine1+4]
    cmp eax, columna            ; comparas la columna con la mina 1 
    je gameOver                 ; perdio 

mina2:
    mov eax, [positionMine2]
    cmp eax, fila               ; comparas la fila con la mina 2 
    jne jugar

    mov eax, [positionMine2+4]
    cmp eax, columna            ; comparas la columna con la mina 2 
    je gameOver                 ; perdio

jugar: 
    
    mov eax, fila               ; encontrar la posicion en el arr 
    imul eax, 4
    add eax, columna

    mov [arrTablero+eax], "d"   ; se coloca la d en el array del tablero
    mov ah, [arrTablero+eax]

    inc contCasillas            ; contador de cuantas casillas muestra 

showTime:
    mov eax, contArr
    cmp eax, 16
    je flagcomp
    cmp eax, 0
    je eFila0
    cmp eax, 4
    je eFila1
    cmp eax, 8
    je eFila2
    cmp eax, 12
    je eFila3
    jne continua

    flagcomp:
        cmp perflag, 1
        je eLastL
        jne eLastW

    eFila0:
        push offset top
        call printf
        add esp,4
        push offset first
        call printf
        add esp,4
        push offset top
        call printf
        add esp,4
        push offset encFila0
        call printf
        add esp,4
        jmp continua

    eFila1:
        push offset entr
        call printf
        add esp,4
        push offset top
        call printf
        add esp,4
        push offset encFila1
        call printf
        add esp,4
        jmp continua

    eFila2:
        push offset entr
        call printf
        add esp,4
        push offset top
        call printf
        add esp,4
        push offset encFila2
        call printf
        add esp,4
        jmp continua

    eFila3:
        push offset entr
        call printf
        add esp,4
        push offset top
        call printf
        add esp,4
        push offset encFila3
        call printf
        add esp,4
        jmp continua

    eLastW:
        push offset entr
        call printf
        add esp,4
        push offset top
        call printf
        add esp,4
        jmp inicio                          ; se repite el proceso para que el jugador ingrese otra vez 

    eLastL:
        push offset entr
        call printf
        add esp,4
        push offset top
        call printf
        add esp,4
        jmp gameOver                          ; pierde

    continua:
        mov eax, contArr
        mov bl, [arrTablero+eax]
        cmp perflag, 1
        jne compNorm 
        cmp bl, comparador
        je esD
        cmp bl, comparador2
        je esS
        jne esM

        compNorm:
            cmp bl, comparador
            je esD
            jne esS

        esD:
            mov eax, contArr
            movzx ebx, [arrBombas+eax]
            mov showMe, ebx
            push showMe
            push offset writeDouble
            call printf
            add esp,8
            inc contArr
            jmp showTime
        
        esS:
            push offset blank
            push offset writeString
            call printf
            add esp,8
            inc contArr
            jmp showTime

        esM:
            push offset bomb
            push offset writeString
            call printf
            add esp,8
            inc contArr
            jmp showTime
    

ganar: 
    push offset ganarM          ; mensaje ganador (se puede cambiar el mensaje)
    call printf
    add esp, 4
    jmp fin

gameOver: 
    inc perflag
    cmp perflag, 1
    je showTime
    push offset perder          ; mensaje de perder
    call printf
    add esp, 4

fin:
    ret 

main endp

datos proc ; aqui pediran los datos 

    ;Fila
    push offset pedirFila
    call printf
    add esp, 4

    lea  eax, fila  ; Obtener dirección del buffer
    push eax 				; Empujar dirección a la pila
    push offset fmt 		; Empujar formato a la pila
    call scanf 				; Leer cadena desde la entrada estándar
    add esp, 8

    ;Columna
    push offset pedirColumna
    call printf
    add esp, 4
    
    lea  eax, columna  ; Obtener dirección del buffer
    push eax 				; Empujar dirección a la pila
    push offset fmt 		; Empujar formato a la pila
    call scanf 				; Leer cadena desde la entrada estándar
    add esp, 8

    ret 
datos endp

showEmptyBoard proc ; impresion del tablero ig 
    
    ;Esto se podria cambiar para que imprima de forma dinamica
    mov contFor, 0
    cmp contTurnos, 0
    je inicio
    jne fin

inicio:
    push offset blank    ;Imprime el tablero

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
    mov eax, [positionMine1]
    imul eax, 4
    ;Antes estaba: add eax, [positionMine1+4]
    add eax, [positionMine1+4]
    ;Se agrega la mina
    mov posiM1, eax
    mov [arrBombas+eax], "m"
    mov [arrTablero+eax], "m"
    mov bh, [arrBombas+eax]


    ;Se busca la posicion de la mina 2
    ;Antes estaba: mov eax, [positionMine2]
    mov eax, [positionMine2]
    imul eax, 4
    ;Antes estaba: add eax, [positionMine2+4]
    add eax, [positionMine2+4]
    ;Se agrega la mina
    mov posiM2, eax
    mov [arrBombas+eax], "m"
    mov [arrTablero+eax], "m"
    mov bh, [arrBombas+eax]

    ; ------------ esto se puede comentariar (mostrar las posiciones de las minas)----------
    push posiM2
    push posiM1
    push offset pruebaPrint
    call printf
    add esp, 12

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
    mov eax, [positionMineX]
    imul eax, 4
    add eax, [positionMineX+4]
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