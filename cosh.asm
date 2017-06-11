.data
	mensagem:	.asciiz	"Digite o numero para X (Cosh X): "
	numero:		.float	0.0		#Salva valor digitado pelo usuario
	zero:		.float	0.0		#zero serve como substituto de $zero para float
	um:		.float	1.0		#Serve para comparar com 1, visto que float nao faz comparacao com imediato
	resultado:	.float	0.0		#Salva o valor do resultado apos a funcao
.text
	main:	
		li	$s6, 20			#Valor maximo para 2n, limitando o numero de interacoes de cosh
		li	$s7, 2			#Valor inicial de 2n, servira como exponencial e divisor na serie de taylor
		#Obtendo input do usuario
		li	$v0, 4
		la	$a0, mensagem
		syscall
		li	$v0, 6
		syscall
		#Salvando input e definindo diversos floats que irao ser utilizados na funcao
		swc1	$f0, numero
		lwc1	$f9, numero
		lwc1	$f0, zero
		lwc1	$f1, um
		lwc1	$f7, um			#Vai receber o valor do fatorial
		lwc1	$f8, um			#Vai receber output da funcao
						#comeca em 1 para representar a primeira interacao que sempre resulta em 1
						#independente do valor escolhido
		#Chamando funcao
		jal	cosh
		#Salvando resultado e mostrando na tela
		swc1	$f8, resultado
		lwc1	$f12, resultado
		li	$v0, 2
		syscall
		#Termina o programa
		li	$v0, 10
		syscall
		
#	Funcoes		#
		
	cosh:
		subi	$sp, $sp, 4			#Aloca espaco no stack point
		sw	$ra, ($sp)			#Salva $ra atual
		#Se X = 0 retorna 1
		c.eq.s	$f9, $f0			#Comparacao com 0
		bc1t	fimCosh				#Condicao para sair da funcao
		#Loop que calcula a potencia
		li	$t4, 1				#Reseta valor de $t4 para o loop
		add.s 	$f4, $f0, $f9			#Reseta valor de $f4 para o numero digitado pelo usuario
	loop:	#Multiplica ate que $t4 seja igual ao expoente $s7
		addi	$t4, $t4, 1			#Controla o numero de iteracoes
		mul.s	$f4, $f4, $f9			#Fazendo a multiplicacao
		blt	$t4, $s7, loop			#Condicao para voltar ou sair do loop
		#Chamando a funcao que faz o fatorial
		move	$a0, $s7			#Coloca $s7 na variavel que deve ser fatorada
		li	$s0, 0				#Reseta o valor de $s0 para realizar o fatorial
		mov.s	$f7, $f1			#Reseta o valor de $f7 para realizar o fatorial
		jal	fact				#Chama a funcao que faz o fatorial
		div.s	$f10, $f4, $f7			#Divide o valor encontrado na exponencial pelo fatorial
		add.s	$f8, $f8, $f10			#Salva o valor da divisão em uma soma (resultado da serie de taylor)	
		addi	$s7, $s7, 2			#Acrescenta 2 em $s7, pois a serie sempre pula de 2 em 2 o valor (2n) 
		beq	$s7, $s6, fimCosh		#Condicao para sair da funcao
		jal	cosh				#Recursao
	
	fimCosh:
		lw	$ra, ($sp)			#Carrega $ra da pilha ate voltar para o main:
		addu	$sp, $sp, 4			#Reseta o stack point
		jr	$ra				#Volta para fimCosh ate o $ra apontar para a continuacao de 'main:'
		 		
 	fact:
		subi	$sp, $sp, 8
		sw	$ra, ($sp)			#Salva $ra atual
		sw	$s0, 4($sp)			#Salva o valor atual
		#Se o numero for 0, resultado 1
		li	$v0, 1
		beqz	$a0, fimFact			#Condicao para sair da funcao
		#Recursao
		move	$s0, $a0			#Salva valor atual em $s0 para ser adicionado a pilha
		sub	$a0, $a0, 1			#Controla o numero de iteracoes
		jal	fact				#recursao
		#Convertendo para float e multiplicando os valores salvos
		sw	$s0, -88($fp)
		l.s	$f6, -88($fp)
		cvt.s.w	$f6, $f6
		mul.s	$f7, $f6, $f7
		
	fimFact:
		lw	$ra, ($sp)
		lw	$s0, 4($sp)
		addu	$sp, $sp, 8
		jr	$ra
