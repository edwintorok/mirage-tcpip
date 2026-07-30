	.file ""
	.section .rodata.cst16,"aM",@progbits,16
	.align	16
caml_negf_mask:
	.quad	0x8000000000000000
	.quad	0
	.align	16
caml_absf_mask:
	.quad	0x7fffffffffffffff
	.quad	-1
	.data
	.globl	camlFair.data_begin
camlFair.data_begin:
	.text
	.globl	camlFair.code_begin
camlFair.code_begin:
	.data
	.align	8
	.data
	.align	8
	.quad	4087
camlFair.3:
	.quad	caml_curry2
	.quad	0x200000000000007
	.quad	camlFair.get_masked_274
	.data
	.align	8
	.quad	4087
camlFair.2:
	.quad	caml_curry2
	.quad	0x200000000000007
	.quad	camlFair.get_masked_329
	.data
	.align	8
	.quad	3063
camlFair.1:
	.quad	camlFair.hash_ipv4_441
	.quad	0x100000000000005
	.data
	.align	8
	.quad	3840
	.globl	camlFair
camlFair:
	.quad	1
	.quad	1
	.quad	1
	.data
	.align	8
	.globl	camlFair.gc_roots
camlFair.gc_roots:
	.quad	camlFair
	.quad	0
	.text
	.align	16
	.globl	camlFair.get_masked_274
camlFair.get_masked_274:
	.file	1	"fair.ml"
	.loc	1	1	24
	.cfi_startproc
	pushq	%rbp
	.cfi_adjust_cfa_offset 8
	movq	%rsp, %rbp
.L100:
	movq	%rax, %rcx
	.loc	1	2	2
	sarq	$1, %rcx
	.loc	1	2	2
	movslq	8(%rbx), %rax
	.loc	1	2	2
	movl	%eax, %eax
	.loc	1	2	2
	shrq	%cl, %rax
	.loc	1	2	2
	salq	$32, %rax
	.loc	1	2	2
	sarq	$31, %rax
	.loc	1	2	2
	orq	$1, %rax
	popq	%rbp
	ret
	.cfi_endproc
	.type camlFair.get_masked_274,@function
	.size camlFair.get_masked_274,. - camlFair.get_masked_274
	.text
	.align	16
	.globl	camlFair.get_masked_329
camlFair.get_masked_329:
	.loc	1	4	15
	.cfi_startproc
	leaq	-336(%rsp), %r10
	cmpq	40(%r14), %r10
	jb	.L102
.L103:
	pushq	%rbp
	.cfi_adjust_cfa_offset 8
	movq	%rsp, %rbp
	subq	$8, %rsp
	.cfi_adjust_cfa_offset 8
.L101:
	movq	%rbx, (%rsp)
	.file	2	"lib/ipaddr.ml"
	.loc	2	373	36
	call	camlIpaddr.mask_1295@PLT
.L104:
	.loc	2	49	18
	movslq	8(%rax), %rax
	movq	(%rsp), %rbx
	.loc	2	49	18
	movslq	8(%rbx), %rbx
	.loc	2	49	18
	andq	%rax, %rbx
	.loc	1	5	21
	movslq	%ebx, %rax
	.loc	1	5	21
	salq	$1, %rax
	.loc	1	5	21
	incq	%rax
	addq	$8, %rsp
	.cfi_adjust_cfa_offset -8
	popq	%rbp
	ret
	.cfi_adjust_cfa_offset 8
.L102:
	push	$35
	.cfi_adjust_cfa_offset 8
	call	caml_call_realloc_stack@PLT
	popq	%r10
	.cfi_adjust_cfa_offset -8
	jmp	.L103
	.cfi_adjust_cfa_offset -8
	.cfi_endproc
	.type camlFair.get_masked_329,@function
	.size camlFair.get_masked_329,. - camlFair.get_masked_329
	.text
	.align	16
	.globl	camlFair.hash_ipv4_441
camlFair.hash_ipv4_441:
	.loc	1	7	14
	.cfi_startproc
	leaq	-360(%rsp), %r10
	cmpq	40(%r14), %r10
	jb	.L106
.L107:
	pushq	%rbp
	.cfi_adjust_cfa_offset 8
	movq	%rsp, %rbp
	subq	$32, %rsp
	.cfi_adjust_cfa_offset 32
.L105:
	movq	%rax, (%rsp)
	movq	%rax, 8(%rsp)
	movl	$17, %eax
	.loc	2	373	36
	call	camlIpaddr.mask_1295@PLT
.L108:
	.loc	2	49	18
	movslq	8(%rax), %rax
	movq	(%rsp), %rbx
	.loc	2	49	18
	movslq	8(%rbx), %rbx
	.loc	2	49	18
	andq	%rax, %rbx
	.loc	1	5	21
	movslq	%ebx, %rax
	.loc	1	5	21
	salq	$1, %rax
	.loc	1	5	21
	incq	%rax
	movq	%rax, 16(%rsp)
	movl	$33, %eax
	.loc	2	373	36
	call	camlIpaddr.mask_1295@PLT
.L109:
	.loc	2	49	18
	movslq	8(%rax), %rax
	movq	(%rsp), %rbx
	.loc	2	49	18
	movslq	8(%rbx), %rbx
	.loc	2	49	18
	andq	%rax, %rbx
	.loc	1	5	21
	movslq	%ebx, %rax
	.loc	1	5	21
	salq	$1, %rax
	.loc	1	5	21
	incq	%rax
	movq	%rax, 24(%rsp)
	movl	$49, %eax
	.loc	2	373	36
	call	camlIpaddr.mask_1295@PLT
.L110:
	.loc	2	49	18
	movslq	8(%rax), %rax
	movq	(%rsp), %rbx
	.loc	2	49	18
	movslq	8(%rbx), %rbx
	.loc	2	49	18
	andq	%rax, %rbx
	.loc	1	5	21
	movslq	%ebx, %rax
	.loc	1	5	21
	salq	$1, %rax
	.loc	1	5	21
	incq	%rax
	movq	8(%rsp), %rbx
	.loc	1	12	11
	movslq	8(%rbx), %rbx
	.loc	1	12	11
	leaq	1(%rbx,%rbx), %rbx
	movq	16(%rsp), %rdi
	movq	24(%rsp), %rsi
	.loc	1	13	2
	addq	%rsi, %rdi
	.loc	1	13	2
	addq	%rax, %rdi
	.loc	1	13	2
	leaq	-3(%rdi,%rbx), %rax
	addq	$32, %rsp
	.cfi_adjust_cfa_offset -32
	popq	%rbp
	ret
	.cfi_adjust_cfa_offset 32
.L106:
	push	$38
	.cfi_adjust_cfa_offset 8
	call	caml_call_realloc_stack@PLT
	popq	%r10
	.cfi_adjust_cfa_offset -8
	jmp	.L107
	.cfi_adjust_cfa_offset -32
	.cfi_endproc
	.type camlFair.hash_ipv4_441,@function
	.size camlFair.hash_ipv4_441,. - camlFair.hash_ipv4_441
	.text
	.align	16
	.globl	camlFair.entry
camlFair.entry:
	.cfi_startproc
	pushq	%rbp
	.cfi_adjust_cfa_offset 8
	movq	%rsp, %rbp
.L111:
	movq	camlFair.3@GOTPCREL(%rip), %rsi
	movq	camlFair@GOTPCREL(%rip), %rdi
	addq	$16, %rdi
	movq	%rsp, %rbx
	.cfi_remember_state
	.cfi_def_cfa_register %rbx
	movq	64(%r14), %rsp
	call	caml_initialize@PLT
	movq	%rbx, %rsp
	.cfi_restore_state
	movq	camlFair.2@GOTPCREL(%rip), %rsi
	movq	camlFair@GOTPCREL(%rip), %rdi
	movq	%rsp, %rbx
	.cfi_remember_state
	.cfi_def_cfa_register %rbx
	movq	64(%r14), %rsp
	call	caml_initialize@PLT
	movq	%rbx, %rsp
	.cfi_restore_state
	movq	camlFair.1@GOTPCREL(%rip), %rsi
	movq	camlFair@GOTPCREL(%rip), %rdi
	addq	$8, %rdi
	movq	%rsp, %rbx
	.cfi_remember_state
	.cfi_def_cfa_register %rbx
	movq	64(%r14), %rsp
	call	caml_initialize@PLT
	movq	%rbx, %rsp
	.cfi_restore_state
	movl	$1, %eax
	popq	%rbp
	ret
	.cfi_endproc
	.type camlFair.entry,@function
	.size camlFair.entry,. - camlFair.entry
	.data
	.align	8
	.text
	.globl	camlFair.code_end
camlFair.code_end:
	.data
				/* relocation table start */
	.align	8
				/* relocation table end */
	.data
	.quad	0
	.globl	camlFair.data_end
camlFair.data_end:
	.quad	0
	.align	8
	.globl	camlFair.frametable
camlFair.frametable:
	.quad	4
	.quad	.L110
	.word	49
	.word	2
	.word	0
	.word	8
	.align	4
	.long	(.L112 - .) + 0
	.align	8
	.quad	.L109
	.word	49
	.word	2
	.word	0
	.word	8
	.align	4
	.long	(.L112 - .) + 0
	.align	8
	.quad	.L108
	.word	49
	.word	2
	.word	0
	.word	8
	.align	4
	.long	(.L112 - .) + 0
	.align	8
	.quad	.L104
	.word	25
	.word	1
	.word	0
	.align	4
	.long	(.L112 - .) + 0
	.align	8
	.align	4
.L112:
	.long	(.L114 - .) + 0
	.long	195596632
.L113:
	.ascii	"lib/ipaddr.ml\0"
	.align	4
.L114:
	.long	(.L113 - .) + 0
	.ascii	"Ipaddr.V4.Prefix.network\0"
	.align	8
	.type camlFair.frametable,@object
	.size camlFair.frametable,. - camlFair.frametable
	.section .note.GNU-stack,"",%progbits
