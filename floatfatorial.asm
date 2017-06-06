.data
	mensagem:	.asciiz	"Numero para fazer o fatorial: "
	numero:		.word	0
	resultado:	.float	0.0
	fone:		.float	1.0
.text
	
	main:
		lwc1	$f1, fone
		li	$v0, 4
		la	$a0, mensagem
		syscall
		li	$v0, 5
		syscall
		sw	$v0, numero
		lw	$a0, numero
		jal	fact
		swc1	$f1, resultado
		li	$v0, 2
		lwc1	$f12, resultado
		syscall
		li	$v0, 10
		syscall
					
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
		#Multiplicando os valores salvos
		sw	$s0, -88($fp)
		l.s	$f2, -88($fp)
		cvt.s.w	$f2, $f2
		mul.s	$f1, $f2, $f1
		
	fimFact:
		lw	$ra, ($sp)
		lw	$s0, 4($sp)
		addu	$sp, $sp, 8
		jr	$ra
