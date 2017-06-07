.data
	mensagem:	.asciiz	"Digite o numero para X (Cosh X): "
	numero:		.float	0.0
	zero:		.float	0.0		#zero serve como substituto de $zero para float
	um:		.float	1.0
	resultado:	.float	0.0
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
		
#	Funções		#
		
	cosh:
		subi	$sp, $sp, 4
		sw	$ra, ($sp)
		#Se X = 0 retorna 1
		c.eq.s	$f9, $f0
		bc1t	fimCosh
		#Chamando funcoes auxiliares para calcular exponencial e fatorial
		jal	pot
		move	$a0, $s7			#Coloca $s7 na variavel que deve ser fatorada
		li	$s0, 0				#Reseta o valor de $s0 para realizar o fatorial
		mov.s	$f7, $f1			#Reseta o valor de $f7 para realizar o fatorial
		jal	fact
		div.s	$f10, $f4, $f7			#Divide o valor encontrado na exponencial pelo fatorial
		add.s	$f8, $f8, $f10			#Salva o valor da divisão em uma soma (resultado da serie de taylor)	
		addi	$s7, $s7, 2			#Acrescenta 2 em $s7 
		beq	$s7, $s6, fimCosh
		jal	cosh
	
	fimCosh:
		lw	$ra, ($sp)
		addu	$sp, $sp, 4
		jr	$ra
		
	pot:
		li	$t4, 1				#Reseta valor de $t4 para o loop
		add.s 	$f4, $f0, $f9			#Reseta valor de $f4 para o numero digitado pelo usuario

	loop:	#Multiplica ate que $t4 seja igual ao expoente $s7
		addi	$t4, $t4, 1
		mul.s	$f4, $f4, $f9
		blt	$t4, $s7, loop

 		jr	$ra
 		
 	fact:
		subi	$sp, $sp, 8
		sw	$ra, ($sp)
		sw	$s0, 4($sp)
		#Se o numero for 0, resultado 1
		li	$v0, 1
		beqz	$a0, fimFact
		#Recursao
		move	$s0, $a0
		sub	$a0, $a0, 1
		jal	fact
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
