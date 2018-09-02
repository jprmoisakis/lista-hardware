.data
	msg1: .asciiz "Digite o valor de M\n"
	msg2: .asciiz "Digite o valor de N\n"
	msg3: .asciiz "Resposta: "
	err1: .asciiz "ERR - O valor de N não pode ser maior que o valor de M, nem igual a 1 \n" # se for igual a 1 dá loop infinito
.text
main:
	# --- LEITURA DE M
	la $a0, msg1 	# Carrega o endereço de msg1 no registrador de argumento para impressão
	li $v0, 4 	# Carrega o código de chamada de sistema 4 (impressão de texto cujo endereço de memória está em a0)
	syscall 	# Imprime msg1
	li $v0, 5 	# Carrega o código de chamada de sistema 5 (leitura de inteiro do teclado)
	syscall		# Lê o valor de M
	move $t1, $v0	# Coloca o valor de M em $t1
	
	# --- LEITURA DE N (Segue a mesma lógica da leitura de M)
	la $a0, msg2
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	move $t2, $v0	# Coloca o valor de N em $t2
	
	# --- VERIFICA SE N > M ou N == 1, se for encerra o programa
	bgt $t2, $t1, endErr
	beq $t2, 1, endErr
	
	# --- CONTA QUANTAS DIVISÕES SUCESSIVAS É POSSÍVEL FAZER, ARMAZENA EM $t3 E IMPRIME
incrementa:
	addi $t3, $t3, 1		# se incrementa o valor de $t3 (númeo de divisões)
	div $t1, $t1, $t2		# divide M por N e atualiza valor de M com o quociente
	bge $t1, $t2, incrementa	# se M ainda é maior que M (ou igual) continua incrementando
	la $a0, msg3			# Carrega msg3 para impressão
	li $v0, 4			# Carrega código de chamada de sistema 4 (impressão de texto)
	syscall				# Imprime mensagem "Resposta: "
	move $a0, $t3			# Move valor resultante para impressão
	li $v0, 1			# Carrega código de chamada de sistema 1 (impressão de inteiro)
	syscall				# Imprime o númeor de divisões
	
	# --- FIM DO PROGRAMA
end:
	li $v0, 10 	# Carrega o código de chamada de sistema 10 (exit, equivalente ao return no main nas linguagens para saída correta do programa)
	syscall 	# Encerra programa
endErr:
	la $a0, err1	# Carrega mensagem de erro N > M
	li $v0, 4	# Carrega cód de impressão de texto
	syscall		# Imprime mensagem de erro
	b end		# Finaliza programa