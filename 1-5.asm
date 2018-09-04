.data
msg1: .asciiz "Digite a quantidade de números no array\n"
msg2: .asciiz "Digite o número "
msg3: .asciiz "Números primos encontrados:\n"
msg4: .asciiz "Nenhum número primo\n"
line: .asciiz "\n"
.text
main:
	# --- ALOCA MEMÓRIA PARA OS ARRAYS, TANTO DE ENTRADA, QUANTO PARA OS NÚMEROS PRIMOS
	li $v0, 4		# carrega código de chamada de sistema 4 para impressão de texto
	la $a0, msg1		# carrega endereço de msg1 para impressão
	syscall			# exibe msg1
	li $v0, 5		# carrega código de chamada de sistema 1 para leitura de inteiro
	syscall			# lê número
	move $s0, $v0		# salva número lido em $s0
	li $v0, 9		# carrega código de chamada de sistema 9 (sbrk) para alocação dinâmica de memória (responsável por salvar o array)
	move $a0, $s0		# coloca tamanho do array em $a0 (argumento da alocação de memória)
	sll $a0, $a0, 2		# multiplica por 4, alocando 4 bytes para cada inteiro
	syscall			# aloca memória do array
	move $s1, $v0		# salva endereço base da memória alocada em $s1
	li $v0, 9		# carrega código de chamada de sistema para alocação de memória
	syscall			# aloca novamente memória para um array de mesmo tamanho (considerendo que no melhor caso todos os números são primos, para não fazer duas verificações, uma para contar e alocar memória, outra pra inserir no array)
	move $s2, $v0		# salva endereço base da memória alocada para o array de números primos em $2
	
	# --- FAZ A LEITURA DOS NÚMEROS DE ENTRADA
	li $t1, 0		# i = 0 (controle do laço)
lenumero:
	li $v0, 4		# carrega código de chamada de sistema 4 (impressão de string)
	la $a0, msg2		# carrega endereço de msg2 para impressão
	syscall			# mostra msg2
	add $a0, $t1, 1		# coloca i + 1 no argumento para impressão
	li $v0, 1		# carrega código de chamada de sistema 1 (impressão de inteiro)
	syscall			# imprime i + 1
	li $v0, 4		# carrega código de chamada de sistema 4 (impressão de string)
	la $a0, line		# carrega endereço da quebra de linha para impressão
	syscall			# imprime quebra de linha
	li $v0, 5		# carrega código de chamada de sistema 5 (leitura de inteiro)
	syscall			# faz leitura de inteiro
	move $t2, $t1		# coloca i em $t2 ($t2 será usado para definir o endereço onde o número será armazenado)
	sll $t2, $t2, 2		# multiplica por 4, cada número lido terá 4 bytes
	add $t2, $t2, $s1	# adiciona com endereço alocado para o array
	sw $v0, ($t2)		# salva o número lido na posição correta no array A[i]
	add $t1, $t1, 1		# i++
	blt $t1, $s0 lenumero	# while (i < N)
	
	# --- VERIFICA QUAIS SÃO PRIMOS
	li $s3, 0		# i = 0
	li $s4, 0		# qtd = 0 (quantidade de números primos encontrados)
saoprimos:
	move $t0, $s3		# coloca i em $t0 (será usado para calcular o endereço de leitura do número do array de entradas)
	sll $t0, $t0, 2		# multiplica por 4
	add $t0, $t0, $s1	# soma com base do array de entrada
	lw $a0, ($t0)		# coloca número A[i] no argumento da função que verificará se é primo
	jal ehprimo		# chama função de verificação se é primo
	beqz $v0 naoprimoloop	# se não for primo pula a parte de armazenamento do número
	move $t1, $s4		# coloca qtd em $t1 (será usado para calcular o endereço de armazenamento do número)
	sll $t1, $t1, 2		# multiplica por 4, para que cada inteiro ocupe 4 bytes
	add $t1, $t1, $s2	# soma com base do array para armazenamento dos números primos 
	sw $a0, ($t1)		# salva no array de números primos
	add $s4, $s4, 1		# qtd++
naoprimoloop:
	add $s3, $s3, 1		# i++
	blt $s3, $s0, saoprimos	# while (i < N)
	
	# --- IMPRIME OS PRIMOS
	beqz $s4, nenhum	# se qtd == 0 encerra programa sem imprimir
	li $v0, 4		# carrega código de chamada de sistema 4 para impressão de strings
	la $a0, msg3		# carrega msg3 para impressão
	syscall			# imprime msg3
	li $t1, 0		# i = 0
loopimpressao:
	move $t2, $t1		# armazena i em $t2 (será usado para calcular endereço de leitura no array de números primos)
	sll $t2, $t2, 2		# multiplica por 2 para ler 4 bytes
	add $t2, $t2, $s2	# soma com base de array de números primos
	lw $a0, ($t2)		# carrega número primo para impressão
	li $v0, 1		# carrega código de chamada de sistema 1 (impressão de inteiro)
	syscall			# imprime número primo
	li $v0, 4		# carrega código de chamada de sistema 4 (impressão de string)
	la $a0, line		# carrega quebra de linha para impressão
	syscall			# imprime quebra de linha
	add $t1, $t1, 1				# i++
	blt $t1, $s4, loopimpressao		# while (i < qtd)
	
	#li $a0, 3
	#jal ehprimo
exit:
	# --- FIM DO PROGRAMA
	li $v0, 10		# carrega código de chamada de sistema 10 (exit)
	syscall			# encerra programa
nenhum:
	li $v0, 4		# carrega código de chamada de sistema 4 (impressão de string)
	la $a0, msg4		# carrega msg4 para impressão
	syscall			# imprime msg4
	b exit			# encerra

ehprimo:			# função que recebe o número para checar se é primo no $a0 (argumento 0)
	# --- CHECA CASO BASE (SE FOR 1 OU 2 JÁ RETORNA QUE NÃO É PRIMO)
	li $v0, 0		# limpa registrador de retorno
	beq $a0, 1, naoprimo	# se for 1 não é primo (casos base)
	beq $a0, 2, naoprimo	# se for 2 não é primo

	# --- LOOP DIVIDINDO POR NUMEROS MENORES
	sub $t0, $a0, 1		# i = N - 1
divide:
	rem $t1, $a0, $t0	# $t1 = N % i (resto da divisão)
	beqz $t1, naoprimo	# se o resto da divisão for 0 não é primo

	# --- CHECA SE CONTINUA O LOOP
	sub $t0, $t0, 1		# i--
	bgt $t0, 1 divide	# while (i > 1) 
	li $v0, 1		# se chegou até aqui é primo, seta retorno como 1
	jr $ra			# return
naoprimo:
	li $v0, 0		# se não for primo seta retorno 0
	jr $ra			# return 0