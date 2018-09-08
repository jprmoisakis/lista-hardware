.data
msg1: .asciiz "Insira o valor de A\n"
msg2: .asciiz "Insira o valor de B\n"
msg3: .asciiz "O valor da soma é: "
err1: .asciiz "O valor de A não pode ser maior que o valor de B\n"
.text
main:
	li $v0, 4 		# carrega código de chamada de sistema 4 (impressão de string)
	la $a0, msg1		# carrega msg1 para impressão em $a0
	syscall			# imprime msg1
	li $v0, 5		# carrega código de chamada de sistema para leitura de inteiro em $v0
	syscall			# lê valor de A
	move $s0, $v0		# move valor de A para $s0
	li $v0, 4		# carrega código de chamada de sistama 4 (impressão de string)
	la $a0, msg2		# carrega msg2 para impressão em $a0
	syscall			# imprime msg2
	li $v0, 5		# carrega código de chamada de sistema para leitura de inteiro em $v0
	syscall			# lê valor de B
	move $s1, $v0		# move valor de B para $s1
	bgt $s0, $s1, err	# se A > B mostra mensagem de erro
	move $a0, $s0		# coloca A no argumento 0
	move $a1, $s1		# coloca B no argumento 1
	jal soma		# chama a função
	move $t1, $v0		# salva o valor de retorno em $t1
	li $v0, 4		# carrega código de chamada de sistema 4 (impressão de string)
	la $a0, msg3		# carrega endereço de msg3 para impressão
	syscall			# imprime msg3
	li $v0, 1		# carrega código de chamada de sistema 1 (impressão de inteiro)
	move $a0, $t1		# carrega o valor de retorno para impressão
	syscall			# imprime valor retornado
	
	# --- FIM DO PROGRAMA
exit:
	li $v0, 10		# carrega código de return (pra encerrar o programa corretamente) em $v0
	syscall			# encerra programa
err:
	li $v0, 4		# carrega código de chamada de sistema 4 (impressão de string)
	la $a0, err1		# carrega err1 para impressão
	syscall			# mostra mensagem de erro A > B
	li $v1, 1		# armazena valor 1 em $v1 conforme foi pedido na questão
	b exit			# encerra programa
	
	# --- FUNÇÃO PARA SOMAR RECURSIVAMENTE
soma:
	# --- SALVA VALOR DOS REGISTRADORES NA STACK
	subu $sp, $sp, 32	# tamanho da stack deve ter no mínimo 32 bytes
	sw $ra, 28($sp)		# salva endereço de retorno na primeira posição da stack
	sw $fp, 24($sp)		# salva endereço do frame pointer na stack
	sw $a0, 20($sp)		# coloca $a0 na stack
	addu $fp, $fp, 32	# coloca framepointer apontando para o primeiro endereço da stack
	
	# --- IF PARA CASOS BASE E RECURSIVOS
	blt $a0, $a1, menor	# if N < B // CASO RECURSIVO
igual:				# else (se N == B na verdade, pois o caso de ser maior já foi checado depois da leitura do número) // CASO BASE
	move $a1, $v0		# coloca B no retorno
	b return
menor:
	add $a0, $a0, 1		# adiciona 1 a N
	jal soma		# chamada recursiva
	lw $a0, 20($sp)		# recupera argumento da chamada anterior
	add $v0, $v0, $a0	# return N + soma(N + 1, B)
	
	# --- RETORNO DA FUNÇÃO
return:
	# --- RESTAURA OS VALORES DA STACK
	lw $ra, 28($sp)		# restaura endereço de retorno
	lw $fp, 24($sp)		# restaura endereço do framepointer
	addu $sp, $sp, 32	# "desaloca" stack
	jr $ra			# retorna
	
	
				