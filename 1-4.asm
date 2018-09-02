.data
A: .word 1,2,3,4,5,6,7,8,9,10
B: .word 11,12,13,14,15,16,17,18,19,20
line: .asciiz "\n"
.text

# $t1 será usado para armazenar valor de I no loop
# $t2 será usado para armazenar deslocamento em bytes de A
# $t3 será usado para armazenar deslocamento em bytes de B

main:
	la $a0, A		# Carrega a base de A em $a0
	la $a1, B		# Carrega a base de B em $b0
	li $t1, 1		# Carrega o I, valor que vai controlar o loop no registrador $t1
loop:
	# --- CALCULA ENDEREÇO DO VALOR EM 'A'
	sub $t2, $t1, 1		# coloca [i - 1] em $t2
	sll $t2, $t2, 2		# multiplica por 4, já que é pra percorrer de 4 em 4 bytes
	add $t2, $t2, $a0	# soma endereço base de A com deslocamento em bytes
	
	# --- CALCULA ENDEREÇO DO VALOR EM 'B'
	move $t3, $t1		# copia o valor de I para o registrador $t3
	sll $t3, $t3, 2
	add $t3, $t3, $a1
	
	# --- CALCULA O VALOR DE A[i-1] + B[i]
	lw $t4, ($t2)		# coloca A[i-1] em $t4
	lw $t5, ($t3)		# coloca B[i] em $t5
	add $t4, $t4, $t5	# soma os dois valores e armazena em $t4
	
	# --- CALCULA O ENDEREÇO DE DESTINO DO RESULTADO EM 'A' E ARMAZENA EM $t0
	move $t0, $t1		# coloca o valor de i em $t0
	sll $t0, $t0, 2		# multiplica por 4
	add $t0, $t0, $a0	# soma com endereço base de 'A'
	sw $t4, ($t0)		# armazena o resultado em A[i]
	
	# --- IMPRIME NOVO VALOR DA POSIÇÃO (para checar corretude)
	move $t5, $a0		# salva temporariamente o valor de $a0 em $t5 para não perder a referência pra base de 'A'
	move $a0, $t4		# manda valor pra impressão
	li $v0, 1		# carrega código da chamada de sistema para saída de inteiro
	syscall			# imprime o inteiro
	li $v0, 4		# carrega código da chamada de sistema para saída de texto
	la $a0, line		# carrega quebra de linha na saída
	syscall			# imprime quebra de linha
	move $a0, $t5		# devolve posição inicial de 'A' para $a0
	
	# --- VERIFICAÇÃO DO LOOP
	add $t1, $t1, 1		# i++
	blt $t1, 10, loop	# se i < 10 continua o loop

	# --- FIM DO PROGRAMA
	li $v0, 10		# Carrega código de chamada de sistema de exit
	syscall			# Finaliza programa