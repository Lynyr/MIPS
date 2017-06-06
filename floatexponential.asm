 .data
 	mensagem1:	.asciiz	"digite a base: "
 	mensagem2:	.asciiz	"digite o expoente: "
 	fzero:		.float	0.0
 	fone:		.float	1.0
 	numero1:	.float	0.0
 	numero2:	.word	0
 	resultado:	.float	0.0
 .text
	lwc1	$f1, fone
	li	$v0, 4
	la	$a0, mensagem1
	syscall
	li	$v0, 6
	syscall
	swc1	$f0, numero1
	lwc1	$f0, fzero
	li	$v0, 4
	la	$a0, mensagem2
	syscall
	li	$v0, 5
	syscall
	sw	$v0, numero2
	lwc1	$f2, numero1
	lw	$t0, numero2
	jal	pot
	sw	$v0, resultado
	li	$v0, 1
	lw	$a0, resultado
	syscall
	li	$v0, 10
	syscall
	

pot:
	add.s	$f3, $f0, $f2
	add	$s7, $zero, $t0

	beq	$s7, $zero, L1
	
	add.s 	$f4, $f0, $f3
	addi 	$t0, $zero, 1

	beq	$s7, $t0, L2

loop:
	addi	$t0, $t0, 1
	mul.s	$f4, $f4, $f3
	blt	$t0, $s7, loop

 	j L3

 	L1: 
 	add.s	$f4, $f0, $f1

 	j L3

 	L2:
 	add.s	$f4, $f0, $f3

 	L3:

 	addi	$v0, $zero, 2
 	add.s	$f12, $f0, $f4
 	syscall
