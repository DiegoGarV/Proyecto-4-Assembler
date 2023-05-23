
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

.code
    includelib libucrt.lib
    includelib legacy_stdio_definitions.lib
    includelib libcmt.lib
    includelib libvcruntime.lib

    extrn printf:near
    extrn scanf:near
    extrn exit:near

public main
main proc
    push ebp
    mov ebp, esp

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

end