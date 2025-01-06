section .data
    prompt db "Guess the number (1 to 100): ", 0
    attemptsInfo db "You have 5 attempts to guess the number!", 0xA, 0
    tooHigh db "Too high, try again.", 0xA, 0
    tooLow db "Too low, try again.", 0xA, 0
    correctGuess db "Congratulations! You guessed correctly.", 0xA, 0
    readError db "Failed to read input.", 0xA, 0
    welcomeMessage db "Welcome to the Guessing Game!", 0xA, 0
    instructions db "Try to guess a number between 1 and 100", 0xA, 0
    attemptsMessage db "Attempts: ", 0
    loseMessage db "You've used all 5 attempts. You lose.", 0xA, 0
    newline db 0xA, 0       ; Newline character

section .bss
    guess resb 5              ; Buffer for user input
    randomNumber resb 4       ; Random number storage
    attempts resb 1           ; Store number of attempts
    numBuffer resb 1          ; Buffer to print a single digit

section .text
global _start

_start:
    ; Display the welcome message
    mov eax, 4
    mov ebx, 1
    mov ecx, welcomeMessage
    mov edx, 31              ; Length of the welcome message
    int 0x80

    ; Display instructions
    mov eax, 4
    mov ebx, 1
    mov ecx, instructions
    mov edx, 40              ; Length of instructions message
    int 0x80

    ; Display the attempts information
    mov eax, 4
    mov ebx, 1
    mov ecx, attemptsInfo
    mov edx, 42              ; Length of the attempts info message
    int 0x80

    ; Initialize the attempt counter
    mov byte [attempts], 0

    call randomize           ; Generate the random number

game_loop:
    ; Check if attempts have reached the limit
    movzx eax, byte [attempts]  ; Load attempts count
    cmp eax, 5                  ; Compare with max attempts
    je lose                     ; If 5 attempts, go to lose label

    ; Display the attempts message
    mov eax, 4
    mov ebx, 1
    mov ecx, attemptsMessage
    mov edx, 10              ; Length of the attempts message
    int 0x80

    ; Display number of attempts (show as ASCII)
    movzx eax, byte [attempts]  ; Load attempts count
    call print_number
    ; Newline after displaying attempts
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    ; Display prompt to the user
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt
    mov edx, 29              ; Length of the prompt
    int 0x80

    ; Read user input
    mov eax, 3
    mov ebx, 0               ; File descriptor (stdin)
    mov ecx, guess           ; Buffer to store the input
    mov edx, 5               ; Maximum number of bytes to read
    int 0x80
    test eax, eax            ; Check if the read was successful
    jz read_failure          ; If eax is 0, there was an error

    ; Convert the ASCII input to an integer
    call atoi

    ; Increment the attempts counter
    inc byte [attempts]

    ; Compare the user's guess with the random number
    mov ebx, eax             ; Store the guess in ebx
    mov eax, [randomNumber]  ; Load the random number
    cmp ebx, eax
    je correct               ; If they match, jump to the correct label
    jl low                   ; If the guess is too low, jump to low
    jg high                  ; If the guess is too high, jump to high

low:
    ; User's guess is too low
    mov eax, 4
    mov ebx, 1
    mov ecx, tooLow
    mov edx, 21
    int 0x80
    jmp game_loop

high:
    ; User's guess is too high
    mov eax, 4
    mov ebx, 1
    mov ecx, tooHigh
    mov edx, 22
    int 0x80
    jmp game_loop

correct:
    ; User guessed correctly
    mov eax, 4
    mov ebx, 1
    mov ecx, correctGuess
    mov edx, 41
    int 0x80
    jmp exit

lose:
    ; User has lost the game
    mov eax, 4
    mov ebx, 1
    mov ecx, loseMessage
    mov edx, 41
    int 0x80
    jmp exit

read_failure:
    ; If reading input failed
    mov eax, 4
    mov ebx, 1
    mov ecx, readError
    mov edx, 23
    int 0x80
    jmp exit

exit:
    ; Exit the program
    mov eax, 1
    xor ebx, ebx
    int 0x80

randomize:
    ; Generate a random number using the system time
    mov eax, 13            ; sys_time syscall
    xor ebx, ebx           ; NULL pointer (unused for sys_time)
    int 0x80               ; Get system time in eax
    mov ebx, 100           ; We want a number from 1 to 100
    xor edx, edx           ; Clear edx before division
    div ebx                ; Divide eax by 100, remainder in edx
    inc edx                ; Make it 1 to 100 instead of 0 to 99
    mov [randomNumber], edx ; Store the result as the random number
    ret

atoi:
    ; Convert ASCII input to an integer
    xor eax, eax          ; Clear eax to store the result
    mov ecx, guess        ; Pointer to the input buffer
atoi_loop:
    movzx edx, byte [ecx] ; Load next byte (character)
    cmp edx, 0xA          ; Check for newline character (end of input)
    je atoi_done          ; If newline, we are done
    cmp edx, 0            ; Check for null terminator
    je atoi_done          ; If null terminator, we are done
    sub edx, '0'          ; Convert ASCII to integer (0-9)
    imul eax, eax, 10     ; Multiply current result by 10
    add eax, edx          ; Add the new digit
    inc ecx               ; Move to the next character
    jmp atoi_loop

atoi_done:
    ret

print_number:
    ; Print number in eax (simple method to print digits)
    add eax, '0'
    mov [numBuffer], al
    mov eax, 4
    mov ebx, 1
    mov ecx, numBuffer
    mov edx, 1
    int 0x80
    ret
