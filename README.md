﻿# CS226-semester-project
---
# Number Guessing Game

This project implements a **Number Guessing Game** using **x86 Assembly Language**. Designed as part of the Computer Organization and Assembly Language (COAL) course, it demonstrates low-level programming concepts such as loops, conditionals, modular arithmetic, and memory management.

## Overview

- **Objective**: Players guess a random number between 1 and 100 within five attempts.  
- **Feedback**: The game provides feedback on each guess (e.g., "Too high," "Too low").  
- **Random Number Generation**: Ensures varied outcomes using system time.  
- **Platform**: Developed for Linux, leveraging NASM (Netwide Assembler).  

## Features

1. **Random Number Generation**: Pseudo-random number using system time.  
2. **Interactive Gameplay**: Feedback for incorrect guesses and clear win/lose conditions.  
3. **Error Handling**: Input validation to manage invalid or unexpected entries.  
4. **Efficient Use of Assembly Constructs**: Modular design for readability and maintainability.  

---

## System Requirements

- **Operating System**: Linux (x86, 32-bit architecture)  
- **Assembler**: NASM (Netwide Assembler)  

---

## File Structure

- **`number_guessing_game.asm`**: The main source code containing all game logic, functions, and system calls.  

---

## How to Run

1. **Install NASM**:  
   If not already installed, use:  
   ```bash
   sudo apt-get install nasm
   ```

2. **Assemble the Code**:  
   Assemble the `number_guessing_game.asm` file into an executable:  
   ```bash
   nasm -f elf32 number_guessing_game.asm -o number_guessing_game.o
   ```

3. **Link the Object File**:  
   Link the object file to create the final executable:  
   ```bash
   ld -m elf_i386 number_guessing_game.o -o number_guessing_game
   ```

4. **Run the Program**:  
   Execute the game:  
   ```bash
   ./number_guessing_game
   ```

---

## Results and Analysis

- **User Interaction**: Clear prompts and feedback enhanced user engagement.  
- **Efficiency**: Successfully implemented core programming concepts like modular design and system calls.  
- **Limitations**:  
  - Platform-dependent (Linux).  
  - Limited randomness due to reliance on system time.  

---

## Contributors

- **Alishba Malik**  
- **Hamza Jawad**  
- **Laiba Nadeem**  
- **Kiran Bibi**  

---
