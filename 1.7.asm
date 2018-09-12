.data
prompt1: .asciiz "Entre com um valor da sequencia:\n"
prompt2: .asciiz "Fibonacci:\n"

.text
# Printa a primeira
li $v0, 4
la $a0, prompt1
syscall

# Le valor
li $v0, 5
syscall

# Chama método de fibonacci
move $a0, $v0
jal fibonacci
move $a1, $v0 # Salva em a1

# Printa entrada 2
li $v0, 4
la $a0, prompt2
syscall

# Dispara resultado
li $v0, 1
move $a0, $a1
syscall

# Gambiarra de fim kkkk
li $v0, 10
syscall



## Função de Fibonnacci
fibonacci:
addi $sp, $sp, -12
sw $ra, 8($sp)
sw $s0, 4($sp)
sw $s1, 0($sp)
move $s0, $a0
li $v0, 1 # Retorna valor pra terminal
ble $s0, 0x2, fibonacciExit # checa condição do terminal
addi $a0, $s0, -1 # Chama recursivamente
jal fibonacci
move $s1, $v0 # Guarda em s1
addi $a0, $s0, -2 # Outra chamada recursiva
jal fibonacci
add $v0, $s1, $v0 # Soma com o que tá em s1
fibonacciExit:
lw $ra, 8($sp)
lw $s0, 4($sp)
lw $s1, 0($sp)
addi $sp, $sp, 12
jr $ra
