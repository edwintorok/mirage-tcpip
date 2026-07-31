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
	.globl	camlCounting_bloom.data_begin
camlCounting_bloom.data_begin:
	.text
	.globl	camlCounting_bloom.code_begin
camlCounting_bloom.code_begin:
	.data
	.align	8
	.data
	.align	8
	.quad	4087
camlCounting_bloom.9:
	.quad	caml_curry3
	.quad	0x300000000000007
	.quad	camlCounting_bloom.get_bin_370
	.data
	.align	8
	.quad	4087
camlCounting_bloom.8:
	.quad	caml_curry3
	.quad	0x300000000000007
	.quad	camlCounting_bloom.fold_min_376
	.data
	.align	8
	.quad	4087
camlCounting_bloom.7:
	.quad	caml_curry4
	.quad	0x400000000000007
	.quad	camlCounting_bloom.update_bin_431
	.data
	.align	8
	.quad	4087
camlCounting_bloom.6:
	.quad	caml_curry3
	.quad	0x300000000000007
	.quad	camlCounting_bloom.update_438
	.data
	.align	8
	.quad	4087
camlCounting_bloom.5:
	.quad	caml_curry2
	.quad	0x200000000000007
	.quad	camlCounting_bloom.clear_bin_443
	.data
	.align	8
	.quad	3063
camlCounting_bloom.4:
	.quad	camlCounting_bloom.clear_447
	.quad	0x100000000000005
	.data
	.align	8
	.quad	3063
camlCounting_bloom.17:
	.quad	camlCounting_bloom.foo_279
	.quad	0x100000000000005
	.data
	.align	8
	.quad	3063
camlCounting_bloom.16:
	.quad	camlCounting_bloom.init_286
	.quad	0x100000000000005
	.data
	.align	8
	.quad	4087
camlCounting_bloom.15:
	.quad	caml_curry2
	.quad	0x200000000000007
	.quad	camlCounting_bloom.get_342
	.data
	.align	8
	.quad	4087
camlCounting_bloom.14:
	.quad	caml_curry3
	.quad	0x300000000000007
	.quad	camlCounting_bloom.update_346
	.data
	.align	8
	.quad	3063
camlCounting_bloom.13:
	.quad	camlCounting_bloom.clear_352
	.quad	0x100000000000005
	.data
	.align	8
	.quad	4087
camlCounting_bloom.12:
	.quad	caml_curry2
	.quad	0x200000000000007
	.quad	camlCounting_bloom.of_hash_355
	.data
	.align	8
	.quad	3063
camlCounting_bloom.11:
	.quad	camlCounting_bloom.make_363
	.quad	0x100000000000005
	.data
	.align	8
	.quad	4087
camlCounting_bloom.10:
	.quad	caml_curry2
	.quad	0x200000000000007
	.quad	camlCounting_bloom.get_366
	.data
	.align	8
	.quad	22272
	.globl	camlCounting_bloom
camlCounting_bloom:
	.quad	1
	.quad	1
	.quad	1
	.quad	1
	.quad	1
	.quad	1
	.quad	1
	.quad	1
	.quad	1
	.quad	1
	.quad	1
	.quad	1
	.quad	1
	.quad	1
	.quad	1
	.quad	1
	.quad	1
	.quad	1
	.quad	1
	.quad	1
	.quad	1
	.data
	.align	8
	.globl	camlCounting_bloom.gc_roots
camlCounting_bloom.gc_roots:
	.quad	camlCounting_bloom
	.quad	0
	.text
	.align	16
	.globl	camlCounting_bloom.foo_279
camlCounting_bloom.foo_279:
	.file	1	"counting_bloom.ml"
	.loc	1	46	8
	.cfi_startproc
	pushq	%rbp
	.cfi_adjust_cfa_offset 8
	movq	%rsp, %rbp
.L100:
	movl	$9, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	.loc	1	46	12
	movq	%rsp, %rbx
	.cfi_remember_state
	.cfi_def_cfa_register %rbx
	movq	64(%r14), %rsp
	call	caml_atomic_exchange_field@PLT
	movq	%rbx, %rsp
	.cfi_restore_state
	movl	$1, %eax
	popq	%rbp
	ret
	.cfi_endproc
	.type camlCounting_bloom.foo_279,@function
	.size camlCounting_bloom.foo_279,. - camlCounting_bloom.foo_279
	.text
	.align	16
	.globl	camlCounting_bloom.init_286
camlCounting_bloom.init_286:
	.loc	1	57	11
	.cfi_startproc
	pushq	%rbp
	.cfi_adjust_cfa_offset 8
	movq	%rsp, %rbp
.L101:
	movl	$1, %esi
	movl	$129, %edi
	.loc	1	57	15
	movq	caml_array_make@GOTPCREL(%rip), %rax
	call	caml_c_call@PLT
.L102:
	popq	%rbp
	ret
	.cfi_endproc
	.type camlCounting_bloom.init_286,@function
	.size camlCounting_bloom.init_286,. - camlCounting_bloom.init_286
	.text
	.align	16
	.globl	camlCounting_bloom.get_342
camlCounting_bloom.get_342:
	.loc	1	59	19
	.cfi_startproc
	.loc	1	62	23
	pushq	%rbp
	.cfi_adjust_cfa_offset 8
	movq	%rsp, %rbp
	.loc	1	62	23
.L103:
	.loc	1	62	23
	andq	$127, %rbx
	.loc	1	62	4
	movq	-4(%rax,%rbx,4), %rax
	popq	%rbp
	ret
	.cfi_endproc
	.type camlCounting_bloom.get_342,@function
	.size camlCounting_bloom.get_342,. - camlCounting_bloom.get_342
	.text
	.align	16
	.globl	camlCounting_bloom.update_346
camlCounting_bloom.update_346:
	.loc	1	64	22
	.cfi_startproc
	.loc	1	65	12
	pushq	%rbp
	.cfi_adjust_cfa_offset 8
	movq	%rsp, %rbp
	.loc	1	65	12
.L104:
	.loc	1	65	12
	andq	$127, %rbx
	.loc	1	66	26
	movq	-4(%rax,%rbx,4), %rsi
	.loc	1	66	25
	leaq	-1(%rsi,%rdi), %rdi
	.loc	1	66	4
	movq	%rdi, -4(%rax,%rbx,4)
	movl	$1, %eax
	popq	%rbp
	ret
	.cfi_endproc
	.type camlCounting_bloom.update_346,@function
	.size camlCounting_bloom.update_346,. - camlCounting_bloom.update_346
	.text
	.align	16
	.globl	camlCounting_bloom.clear_352
camlCounting_bloom.clear_352:
	.loc	1	68	21
	.cfi_startproc
	pushq	%rbp
	.cfi_adjust_cfa_offset 8
	movq	%rsp, %rbp
.L105:
	movl	$1, %esi
	.loc	1	69	20
	movq	-8(%rax), %rdi
	.loc	1	69	20
	shrq	$9, %rdi
	.loc	1	69	20
	orq	$1, %rdi
	.loc	1	69	19
	addq	$-2, %rdi
	movl	$1, %ebx
	.loc	1	69	4
	popq	%rbp
	jmp	camlStdlib__Array.fill_330@PLT
	.cfi_endproc
	.type camlCounting_bloom.clear_352,@function
	.size camlCounting_bloom.clear_352,. - camlCounting_bloom.clear_352
	.text
	.align	16
	.globl	camlCounting_bloom.of_hash_355
camlCounting_bloom.of_hash_355:
	.loc	1	71	23
	.cfi_startproc
	.loc	1	73	13
	pushq	%rbp
	.cfi_adjust_cfa_offset 8
	movq	%rsp, %rbp
	.loc	1	73	13
.L106:
	.loc	1	73	13
	imulq	$6, %rbx
	.loc	1	73	13
	addq	$-5, %rbx
	.loc	1	73	4
	sarq	$1, %rbx
	movq	%rbx, %rcx
	.loc	1	73	4
	shrq	%cl, %rax
	.loc	1	73	4
	orq	$1, %rax
	popq	%rbp
	ret
	.cfi_endproc
	.type camlCounting_bloom.of_hash_355,@function
	.size camlCounting_bloom.of_hash_355,. - camlCounting_bloom.of_hash_355
	.text
	.align	16
	.globl	camlCounting_bloom.make_363
camlCounting_bloom.make_363:
	.loc	1	83	9
	.cfi_startproc
	pushq	%rbp
	.cfi_adjust_cfa_offset 8
	movq	%rsp, %rbp
.L107:
	movq	camlCounting_bloom@GOTPCREL(%rip), %rax
	movq	16(%rax), %rax
	.loc	1	83	32
	movq	24(%rax), %rbx
	movl	$11, %eax
	.loc	1	83	14
	popq	%rbp
	jmp	camlStdlib__Array.init_294@PLT
	.cfi_endproc
	.type camlCounting_bloom.make_363,@function
	.size camlCounting_bloom.make_363,. - camlCounting_bloom.make_363
	.text
	.align	16
	.globl	camlCounting_bloom.get_366
camlCounting_bloom.get_366:
	.loc	1	85	17
	.cfi_startproc
	pushq	%rbp
	.cfi_adjust_cfa_offset 8
	movq	%rsp, %rbp
.L110:
	cmpq	$1, %rbx
	jl	.L109
	cmpq	$11, %rbx
	jl	.L108
.L109:
	.loc	1	86	2
	subq	$24, %r15
	cmpq	(%r14), %r15
	jb	.L111
.L113:
	leaq	8(%r15), %rax
	movq	$2048, -8(%rax)
	movq	caml_exn_Assert_failure@GOTPCREL(%rip), %rbx
	movq	%rbx, (%rax)
	movq	camlCounting_bloom.3@GOTPCREL(%rip), %rbx
	movq	%rbx, 8(%rax)
	.loc	1	86	2
	movq	48(%r14), %rsp
	popq	48(%r14)
	popq	%r11
	jmp	*%r11
	.align	4
.L108:
	.loc	1	87	2
	movq	-4(%rax,%rbx,4), %rax
	popq	%rbp
	ret
.L111:
	call	caml_call_gc@PLT
.L112:
	jmp	.L113
	.cfi_endproc
	.type camlCounting_bloom.get_366,@function
	.size camlCounting_bloom.get_366,. - camlCounting_bloom.get_366
	.text
	.align	16
	.globl	camlCounting_bloom.get_bin_370
camlCounting_bloom.get_bin_370:
	.loc	1	89	21
	.cfi_startproc
	pushq	%rbp
	.cfi_adjust_cfa_offset 8
	movq	%rsp, %rbp
.L116:
	movq	%rdi, %rcx
	.loc	1	73	13
	imulq	$6, %rcx
	.loc	1	73	13
	addq	$-5, %rcx
	.loc	1	73	4
	sarq	$1, %rcx
	.loc	1	73	4
	shrq	%cl, %rbx
	.loc	1	73	4
	orq	$1, %rbx
	cmpq	$1, %rdi
	jl	.L115
	cmpq	$11, %rdi
	jl	.L114
.L115:
	.loc	1	86	2
	subq	$24, %r15
	cmpq	(%r14), %r15
	jb	.L117
.L119:
	leaq	8(%r15), %rax
	movq	$2048, -8(%rax)
	movq	caml_exn_Assert_failure@GOTPCREL(%rip), %rbx
	movq	%rbx, (%rax)
	movq	camlCounting_bloom.3@GOTPCREL(%rip), %rbx
	movq	%rbx, 8(%rax)
	.loc	1	86	2
	movq	48(%r14), %rsp
	popq	48(%r14)
	popq	%r11
	jmp	*%r11
	.align	4
.L114:
	.loc	1	87	2
	movq	-4(%rax,%rdi,4), %rax
	.loc	1	62	23
	andq	$127, %rbx
	.loc	1	62	4
	movq	-4(%rax,%rbx,4), %rax
	popq	%rbp
	ret
.L117:
	call	caml_call_gc@PLT
.L118:
	jmp	.L119
	.cfi_endproc
	.type camlCounting_bloom.get_bin_370,@function
	.size camlCounting_bloom.get_bin_370,. - camlCounting_bloom.get_bin_370
	.text
	.align	16
	.globl	camlCounting_bloom.fold_min_376
camlCounting_bloom.fold_min_376:
	.loc	1	93	22
	.cfi_startproc
	pushq	%rbp
	.cfi_adjust_cfa_offset 8
	movq	%rsp, %rbp
.L127:
	movq	%rax, %rsi
	movq	%rdi, %rax
	movq	%rbx, %rdi
	.loc	1	73	4
	orq	$1, %rdi
	.loc	1	87	2
	movq	(%rsi), %rdx
	.loc	1	62	23
	andq	$127, %rdi
	.loc	1	62	4
	movq	-4(%rdx,%rdi,4), %rdi
	movq	%rbx, %rdx
	.loc	1	73	4
	shrq	$6, %rdx
	.loc	1	73	4
	orq	$1, %rdx
	.loc	1	87	2
	movq	8(%rsi), %rcx
	.loc	1	62	23
	andq	$127, %rdx
	.loc	1	62	4
	movq	-4(%rcx,%rdx,4), %r8
	movq	%rbx, %rdx
	.loc	1	73	4
	shrq	$12, %rdx
	.loc	1	73	4
	orq	$1, %rdx
	.loc	1	87	2
	movq	16(%rsi), %rcx
	.loc	1	62	23
	andq	$127, %rdx
	.loc	1	62	4
	movq	-4(%rcx,%rdx,4), %rcx
	movq	%rbx, %rdx
	.loc	1	73	4
	shrq	$18, %rdx
	.loc	1	73	4
	orq	$1, %rdx
	.loc	1	87	2
	movq	24(%rsi), %r9
	.loc	1	62	23
	andq	$127, %rdx
	.loc	1	62	4
	movq	-4(%r9,%rdx,4), %rdx
	.loc	1	73	4
	shrq	$24, %rbx
	.loc	1	73	4
	orq	$1, %rbx
	.loc	1	87	2
	movq	32(%rsi), %rsi
	.loc	1	62	23
	andq	$127, %rbx
	.loc	1	62	4
	movq	-4(%rsi,%rbx,4), %rbx
	cmpq	%rdi, %rax
	jg	.L126
	movq	%rax, %rdi
.L126:
	cmpq	%rcx, %r8
	jg	.L125
	movq	%r8, %rax
	jmp	.L124
	.align	4
.L125:
	movq	%rcx, %rax
.L124:
	cmpq	%rbx, %rdx
	jg	.L123
	movq	%rdx, %rbx
.L123:
	cmpq	%rbx, %rax
	jg	.L122
	jmp	.L121
	.align	4
.L122:
	movq	%rbx, %rax
.L121:
	cmpq	%rax, %rdi
	jg	.L120
	movq	%rdi, %rax
	popq	%rbp
	ret
	.align	4
.L120:
	popq	%rbp
	ret
	.cfi_endproc
	.type camlCounting_bloom.fold_min_376,@function
	.size camlCounting_bloom.fold_min_376,. - camlCounting_bloom.fold_min_376
	.text
	.align	16
	.globl	camlCounting_bloom.update_bin_431
camlCounting_bloom.update_bin_431:
	.loc	1	107	24
	.cfi_startproc
	pushq	%rbp
	.cfi_adjust_cfa_offset 8
	movq	%rsp, %rbp
.L130:
	movq	%rsi, %rcx
	.loc	1	73	13
	imulq	$6, %rcx
	.loc	1	73	13
	addq	$-5, %rcx
	.loc	1	73	4
	sarq	$1, %rcx
	.loc	1	73	4
	shrq	%cl, %rbx
	.loc	1	73	4
	orq	$1, %rbx
	cmpq	$1, %rsi
	jl	.L129
	cmpq	$11, %rsi
	jl	.L128
.L129:
	.loc	1	86	2
	subq	$24, %r15
	cmpq	(%r14), %r15
	jb	.L131
.L133:
	leaq	8(%r15), %rax
	movq	$2048, -8(%rax)
	movq	caml_exn_Assert_failure@GOTPCREL(%rip), %rbx
	movq	%rbx, (%rax)
	movq	camlCounting_bloom.3@GOTPCREL(%rip), %rbx
	movq	%rbx, 8(%rax)
	.loc	1	86	2
	movq	48(%r14), %rsp
	popq	48(%r14)
	popq	%r11
	jmp	*%r11
	.align	4
.L128:
	.loc	1	87	2
	movq	-4(%rax,%rsi,4), %rax
	.loc	1	65	12
	andq	$127, %rbx
	.loc	1	66	26
	movq	-4(%rax,%rbx,4), %rsi
	.loc	1	66	25
	leaq	-1(%rsi,%rdi), %rdi
	.loc	1	66	4
	movq	%rdi, -4(%rax,%rbx,4)
	movl	$1, %eax
	popq	%rbp
	ret
.L131:
	call	caml_call_gc@PLT
.L132:
	jmp	.L133
	.cfi_endproc
	.type camlCounting_bloom.update_bin_431,@function
	.size camlCounting_bloom.update_bin_431,. - camlCounting_bloom.update_bin_431
	.text
	.align	16
	.globl	camlCounting_bloom.update_438
camlCounting_bloom.update_438:
	.loc	1	111	20
	.cfi_startproc
	pushq	%rbp
	.cfi_adjust_cfa_offset 8
	movq	%rsp, %rbp
.L134:
	movq	%rbx, %rsi
	.loc	1	73	4
	orq	$1, %rsi
	.loc	1	87	2
	movq	(%rax), %rdx
	.loc	1	65	12
	andq	$127, %rsi
	.loc	1	66	26
	movq	-4(%rdx,%rsi,4), %rcx
	.loc	1	66	25
	leaq	-1(%rcx,%rdi), %rcx
	.loc	1	66	4
	movq	%rcx, -4(%rdx,%rsi,4)
	movq	%rbx, %rsi
	.loc	1	73	4
	shrq	$6, %rsi
	.loc	1	73	4
	orq	$1, %rsi
	.loc	1	87	2
	movq	8(%rax), %rdx
	.loc	1	65	12
	andq	$127, %rsi
	.loc	1	66	26
	movq	-4(%rdx,%rsi,4), %rcx
	.loc	1	66	25
	leaq	-1(%rcx,%rdi), %rcx
	.loc	1	66	4
	movq	%rcx, -4(%rdx,%rsi,4)
	movq	%rbx, %rsi
	.loc	1	73	4
	shrq	$12, %rsi
	.loc	1	73	4
	orq	$1, %rsi
	.loc	1	87	2
	movq	16(%rax), %rdx
	.loc	1	65	12
	andq	$127, %rsi
	.loc	1	66	26
	movq	-4(%rdx,%rsi,4), %rcx
	.loc	1	66	25
	leaq	-1(%rcx,%rdi), %rcx
	.loc	1	66	4
	movq	%rcx, -4(%rdx,%rsi,4)
	movq	%rbx, %rsi
	.loc	1	73	4
	shrq	$18, %rsi
	.loc	1	73	4
	orq	$1, %rsi
	.loc	1	87	2
	movq	24(%rax), %rdx
	.loc	1	65	12
	andq	$127, %rsi
	.loc	1	66	26
	movq	-4(%rdx,%rsi,4), %rcx
	.loc	1	66	25
	leaq	-1(%rcx,%rdi), %rcx
	.loc	1	66	4
	movq	%rcx, -4(%rdx,%rsi,4)
	.loc	1	73	4
	shrq	$24, %rbx
	.loc	1	73	4
	orq	$1, %rbx
	.loc	1	87	2
	movq	32(%rax), %rax
	.loc	1	65	12
	andq	$127, %rbx
	.loc	1	66	26
	movq	-4(%rax,%rbx,4), %rsi
	.loc	1	66	25
	leaq	-1(%rsi,%rdi), %rdi
	.loc	1	66	4
	movq	%rdi, -4(%rax,%rbx,4)
	movl	$1, %eax
	popq	%rbp
	ret
	.cfi_endproc
	.type camlCounting_bloom.update_438,@function
	.size camlCounting_bloom.update_438,. - camlCounting_bloom.update_438
	.text
	.align	16
	.globl	camlCounting_bloom.clear_bin_443
camlCounting_bloom.clear_bin_443:
	.loc	1	118	23
	.cfi_startproc
	pushq	%rbp
	.cfi_adjust_cfa_offset 8
	movq	%rsp, %rbp
.L137:
	cmpq	$1, %rbx
	jl	.L136
	cmpq	$11, %rbx
	jl	.L135
.L136:
	.loc	1	86	2
	subq	$24, %r15
	cmpq	(%r14), %r15
	jb	.L138
.L140:
	leaq	8(%r15), %rax
	movq	$2048, -8(%rax)
	movq	caml_exn_Assert_failure@GOTPCREL(%rip), %rbx
	movq	%rbx, (%rax)
	movq	camlCounting_bloom.3@GOTPCREL(%rip), %rbx
	movq	%rbx, 8(%rax)
	.loc	1	86	2
	movq	48(%r14), %rsp
	popq	48(%r14)
	popq	%r11
	jmp	*%r11
	.align	4
.L135:
	.loc	1	87	2
	movq	-4(%rax,%rbx,4), %rax
	movl	$1, %esi
	.loc	1	69	20
	movq	-8(%rax), %rdi
	.loc	1	69	20
	shrq	$9, %rdi
	.loc	1	69	20
	orq	$1, %rdi
	.loc	1	69	19
	addq	$-2, %rdi
	movl	$1, %ebx
	.loc	1	69	4
	popq	%rbp
	jmp	camlStdlib__Array.fill_330@PLT
.L138:
	call	caml_call_gc@PLT
.L139:
	jmp	.L140
	.cfi_endproc
	.type camlCounting_bloom.clear_bin_443,@function
	.size camlCounting_bloom.clear_bin_443,. - camlCounting_bloom.clear_bin_443
	.text
	.align	16
	.globl	camlCounting_bloom.clear_447
camlCounting_bloom.clear_447:
	.loc	1	121	10
	.cfi_startproc
	leaq	-336(%rsp), %r10
	cmpq	40(%r14), %r10
	jb	.L142
.L143:
	pushq	%rbp
	.cfi_adjust_cfa_offset 8
	movq	%rsp, %rbp
	subq	$8, %rsp
	.cfi_adjust_cfa_offset 8
.L141:
	movq	%rax, (%rsp)
	.loc	1	87	2
	movq	(%rax), %rax
	movl	$1, %esi
	.loc	1	69	20
	movq	-8(%rax), %rdi
	.loc	1	69	20
	shrq	$9, %rdi
	.loc	1	69	20
	orq	$1, %rdi
	.loc	1	69	19
	addq	$-2, %rdi
	movl	$1, %ebx
	.loc	1	69	4
	call	camlStdlib__Array.fill_330@PLT
.L144:
	movq	(%rsp), %rax
	.loc	1	87	2
	movq	8(%rax), %rax
	movl	$1, %esi
	.loc	1	69	20
	movq	-8(%rax), %rdi
	.loc	1	69	20
	shrq	$9, %rdi
	.loc	1	69	20
	orq	$1, %rdi
	.loc	1	69	19
	addq	$-2, %rdi
	movl	$1, %ebx
	.loc	1	69	4
	call	camlStdlib__Array.fill_330@PLT
.L145:
	movq	(%rsp), %rax
	.loc	1	87	2
	movq	16(%rax), %rax
	movl	$1, %esi
	.loc	1	69	20
	movq	-8(%rax), %rdi
	.loc	1	69	20
	shrq	$9, %rdi
	.loc	1	69	20
	orq	$1, %rdi
	.loc	1	69	19
	addq	$-2, %rdi
	movl	$1, %ebx
	.loc	1	69	4
	call	camlStdlib__Array.fill_330@PLT
.L146:
	movq	(%rsp), %rax
	.loc	1	87	2
	movq	24(%rax), %rax
	movl	$1, %esi
	.loc	1	69	20
	movq	-8(%rax), %rdi
	.loc	1	69	20
	shrq	$9, %rdi
	.loc	1	69	20
	orq	$1, %rdi
	.loc	1	69	19
	addq	$-2, %rdi
	movl	$1, %ebx
	.loc	1	69	4
	call	camlStdlib__Array.fill_330@PLT
.L147:
	movq	(%rsp), %rax
	.loc	1	87	2
	movq	32(%rax), %rax
	movl	$1, %esi
	.loc	1	69	20
	movq	-8(%rax), %rdi
	.loc	1	69	20
	shrq	$9, %rdi
	.loc	1	69	20
	orq	$1, %rdi
	.loc	1	69	19
	addq	$-2, %rdi
	movl	$1, %ebx
	.loc	1	69	4
	addq	$8, %rsp
	.cfi_adjust_cfa_offset -8
	popq	%rbp
	jmp	camlStdlib__Array.fill_330@PLT
	.cfi_adjust_cfa_offset 8
.L142:
	push	$35
	.cfi_adjust_cfa_offset 8
	call	caml_call_realloc_stack@PLT
	popq	%r10
	.cfi_adjust_cfa_offset -8
	jmp	.L143
	.cfi_adjust_cfa_offset -8
	.cfi_endproc
	.type camlCounting_bloom.clear_447,@function
	.size camlCounting_bloom.clear_447,. - camlCounting_bloom.clear_447
	.data
	.align	8
	.quad	3840
	.globl	camlCounting_bloom.3
camlCounting_bloom.3:
	.quad	camlCounting_bloom.2
	.quad	173
	.quad	5
	.data
	.align	8
	.quad	4092
	.globl	camlCounting_bloom.2
camlCounting_bloom.2:
	.ascii	"counting_bloom.ml"
	.space	6
	.byte	6
	.data
	.align	8
	.quad	768
	.globl	camlCounting_bloom.1
camlCounting_bloom.1:
	.text
	.align	16
	.globl	camlCounting_bloom.entry
camlCounting_bloom.entry:
	.cfi_startproc
	pushq	%rbp
	.cfi_adjust_cfa_offset 8
	movq	%rsp, %rbp
.L148:
	movq	camlCounting_bloom.1@GOTPCREL(%rip), %rsi
	movq	camlCounting_bloom@GOTPCREL(%rip), %rdi
	.loc	1	40	0
	movq	%rsp, %rbx
	.cfi_remember_state
	.cfi_def_cfa_register %rbx
	movq	64(%r14), %rsp
	call	caml_initialize@PLT
	movq	%rbx, %rsp
	.cfi_restore_state
	movq	camlCounting_bloom.17@GOTPCREL(%rip), %rsi
	movq	camlCounting_bloom@GOTPCREL(%rip), %rdi
	addq	$8, %rdi
	movq	%rsp, %rbx
	.cfi_remember_state
	.cfi_def_cfa_register %rbx
	movq	64(%r14), %rsp
	call	caml_initialize@PLT
	movq	%rbx, %rsp
	.cfi_restore_state
	movl	$13, %esi
	movq	camlCounting_bloom@GOTPCREL(%rip), %rdi
	addq	$104, %rdi
	movq	%rsp, %rbx
	.cfi_remember_state
	.cfi_def_cfa_register %rbx
	movq	64(%r14), %rsp
	call	caml_initialize@PLT
	movq	%rbx, %rsp
	.cfi_restore_state
	movl	$129, %esi
	movq	camlCounting_bloom@GOTPCREL(%rip), %rdi
	addq	$112, %rdi
	movq	%rsp, %rbx
	.cfi_remember_state
	.cfi_def_cfa_register %rbx
	movq	64(%r14), %rsp
	call	caml_initialize@PLT
	movq	%rbx, %rsp
	.cfi_restore_state
	movl	$127, %esi
	movq	camlCounting_bloom@GOTPCREL(%rip), %rdi
	addq	$120, %rdi
	movq	%rsp, %rbx
	.cfi_remember_state
	.cfi_def_cfa_register %rbx
	movq	64(%r14), %rsp
	call	caml_initialize@PLT
	movq	%rbx, %rsp
	.cfi_restore_state
	movq	camlCounting_bloom.16@GOTPCREL(%rip), %rsi
	movq	camlCounting_bloom@GOTPCREL(%rip), %rdi
	addq	$128, %rdi
	movq	%rsp, %rbx
	.cfi_remember_state
	.cfi_def_cfa_register %rbx
	movq	64(%r14), %rsp
	call	caml_initialize@PLT
	movq	%rbx, %rsp
	.cfi_restore_state
	movq	camlCounting_bloom.15@GOTPCREL(%rip), %rsi
	movq	camlCounting_bloom@GOTPCREL(%rip), %rdi
	addq	$136, %rdi
	movq	%rsp, %rbx
	.cfi_remember_state
	.cfi_def_cfa_register %rbx
	movq	64(%r14), %rsp
	call	caml_initialize@PLT
	movq	%rbx, %rsp
	.cfi_restore_state
	movq	camlCounting_bloom.14@GOTPCREL(%rip), %rsi
	movq	camlCounting_bloom@GOTPCREL(%rip), %rdi
	addq	$144, %rdi
	movq	%rsp, %rbx
	.cfi_remember_state
	.cfi_def_cfa_register %rbx
	movq	64(%r14), %rsp
	call	caml_initialize@PLT
	movq	%rbx, %rsp
	.cfi_restore_state
	movq	camlCounting_bloom.13@GOTPCREL(%rip), %rsi
	movq	camlCounting_bloom@GOTPCREL(%rip), %rdi
	addq	$152, %rdi
	movq	%rsp, %rbx
	.cfi_remember_state
	.cfi_def_cfa_register %rbx
	movq	64(%r14), %rsp
	call	caml_initialize@PLT
	movq	%rbx, %rsp
	.cfi_restore_state
	movq	camlCounting_bloom.12@GOTPCREL(%rip), %rsi
	movq	camlCounting_bloom@GOTPCREL(%rip), %rdi
	addq	$160, %rdi
	movq	%rsp, %rbx
	.cfi_remember_state
	.cfi_def_cfa_register %rbx
	movq	64(%r14), %rsp
	call	caml_initialize@PLT
	movq	%rbx, %rsp
	.cfi_restore_state
	.loc	1	48	0
	subq	$72, %r15
	call	caml_allocN@PLT
.L149:
	leaq	8(%r15), %rsi
	movq	$8192, -8(%rsi)
	movq	$13, (%rsi)
	movq	$129, 8(%rsi)
	movq	$127, 16(%rsi)
	movq	camlCounting_bloom@GOTPCREL(%rip), %rdi
	movq	128(%rdi), %rax
	movq	%rax, 24(%rsi)
	movq	136(%rdi), %rax
	movq	%rax, 32(%rsi)
	movq	144(%rdi), %rax
	movq	%rax, 40(%rsi)
	movq	152(%rdi), %rax
	movq	%rax, 48(%rsi)
	movq	160(%rdi), %rax
	movq	%rax, 56(%rsi)
	.loc	1	48	0
	addq	$16, %rdi
	.loc	1	48	0
	movq	%rsp, %rbx
	.cfi_remember_state
	.cfi_def_cfa_register %rbx
	movq	64(%r14), %rsp
	call	caml_initialize@PLT
	movq	%rbx, %rsp
	.cfi_restore_state
	movl	$11, %esi
	movq	camlCounting_bloom@GOTPCREL(%rip), %rdi
	addq	$24, %rdi
	movq	%rsp, %rbx
	.cfi_remember_state
	.cfi_def_cfa_register %rbx
	movq	64(%r14), %rsp
	call	caml_initialize@PLT
	movq	%rbx, %rsp
	.cfi_restore_state
	movl	$61, %esi
	movq	camlCounting_bloom@GOTPCREL(%rip), %rdi
	addq	$32, %rdi
	movq	%rsp, %rbx
	.cfi_remember_state
	.cfi_def_cfa_register %rbx
	movq	64(%r14), %rsp
	call	caml_initialize@PLT
	movq	%rbx, %rsp
	.cfi_restore_state
	movq	camlCounting_bloom.11@GOTPCREL(%rip), %rsi
	movq	camlCounting_bloom@GOTPCREL(%rip), %rdi
	addq	$40, %rdi
	movq	%rsp, %rbx
	.cfi_remember_state
	.cfi_def_cfa_register %rbx
	movq	64(%r14), %rsp
	call	caml_initialize@PLT
	movq	%rbx, %rsp
	.cfi_restore_state
	movq	camlCounting_bloom.10@GOTPCREL(%rip), %rsi
	movq	camlCounting_bloom@GOTPCREL(%rip), %rdi
	addq	$48, %rdi
	movq	%rsp, %rbx
	.cfi_remember_state
	.cfi_def_cfa_register %rbx
	movq	64(%r14), %rsp
	call	caml_initialize@PLT
	movq	%rbx, %rsp
	.cfi_restore_state
	movq	camlCounting_bloom.9@GOTPCREL(%rip), %rsi
	movq	camlCounting_bloom@GOTPCREL(%rip), %rdi
	addq	$56, %rdi
	movq	%rsp, %rbx
	.cfi_remember_state
	.cfi_def_cfa_register %rbx
	movq	64(%r14), %rsp
	call	caml_initialize@PLT
	movq	%rbx, %rsp
	.cfi_restore_state
	movq	camlCounting_bloom.8@GOTPCREL(%rip), %rsi
	movq	camlCounting_bloom@GOTPCREL(%rip), %rdi
	addq	$64, %rdi
	movq	%rsp, %rbx
	.cfi_remember_state
	.cfi_def_cfa_register %rbx
	movq	64(%r14), %rsp
	call	caml_initialize@PLT
	movq	%rbx, %rsp
	.cfi_restore_state
	movq	camlCounting_bloom.7@GOTPCREL(%rip), %rsi
	movq	camlCounting_bloom@GOTPCREL(%rip), %rdi
	addq	$72, %rdi
	movq	%rsp, %rbx
	.cfi_remember_state
	.cfi_def_cfa_register %rbx
	movq	64(%r14), %rsp
	call	caml_initialize@PLT
	movq	%rbx, %rsp
	.cfi_restore_state
	movq	camlCounting_bloom.6@GOTPCREL(%rip), %rsi
	movq	camlCounting_bloom@GOTPCREL(%rip), %rdi
	addq	$80, %rdi
	movq	%rsp, %rbx
	.cfi_remember_state
	.cfi_def_cfa_register %rbx
	movq	64(%r14), %rsp
	call	caml_initialize@PLT
	movq	%rbx, %rsp
	.cfi_restore_state
	movq	camlCounting_bloom.5@GOTPCREL(%rip), %rsi
	movq	camlCounting_bloom@GOTPCREL(%rip), %rdi
	addq	$88, %rdi
	movq	%rsp, %rbx
	.cfi_remember_state
	.cfi_def_cfa_register %rbx
	movq	64(%r14), %rsp
	call	caml_initialize@PLT
	movq	%rbx, %rsp
	.cfi_restore_state
	movq	camlCounting_bloom.4@GOTPCREL(%rip), %rsi
	movq	camlCounting_bloom@GOTPCREL(%rip), %rdi
	addq	$96, %rdi
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
	.type camlCounting_bloom.entry,@function
	.size camlCounting_bloom.entry,. - camlCounting_bloom.entry
	.data
	.align	8
	.text
	.globl	camlCounting_bloom.code_end
camlCounting_bloom.code_end:
	.data
				/* relocation table start */
	.align	8
				/* relocation table end */
	.data
	.quad	0
	.globl	camlCounting_bloom.data_end
camlCounting_bloom.data_end:
	.quad	0
	.align	8
	.globl	camlCounting_bloom.frametable
camlCounting_bloom.frametable:
	.quad	10
	.quad	.L149
	.word	18
	.word	0
	.byte	1
	.byte	7
	.align	8
	.quad	.L147
	.word	25
	.word	1
	.word	0
	.align	4
	.long	(.L150 - .) + 0
	.align	8
	.quad	.L146
	.word	25
	.word	1
	.word	0
	.align	4
	.long	(.L150 - .) + 0
	.align	8
	.quad	.L145
	.word	25
	.word	1
	.word	0
	.align	4
	.long	(.L150 - .) + 0
	.align	8
	.quad	.L144
	.word	25
	.word	1
	.word	0
	.align	4
	.long	(.L150 - .) + 0
	.align	8
	.quad	.L139
	.word	18
	.word	0
	.byte	1
	.byte	1
	.align	8
	.quad	.L132
	.word	18
	.word	0
	.byte	1
	.byte	1
	.align	8
	.quad	.L118
	.word	18
	.word	0
	.byte	1
	.byte	1
	.align	8
	.quad	.L112
	.word	18
	.word	0
	.byte	1
	.byte	1
	.align	8
	.quad	.L102
	.word	17
	.word	0
	.align	4
	.long	(.L151 - .) + 0
	.align	8
	.align	4
.L150:
	.long	(.L153 - .) + 0
	.long	36180296
	.align	4
.L151:
	.long	(.L154 - .) + 0
	.long	29900008
.L152:
	.ascii	"counting_bloom.ml\0"
	.align	4
.L154:
	.long	(.L152 - .) + 0
	.ascii	"Counting_bloom.Level.init\0"
	.align	4
.L153:
	.long	(.L152 - .) + 0
	.ascii	"Counting_bloom.Level.clear\0"
	.align	8
	.type camlCounting_bloom.frametable,@object
	.size camlCounting_bloom.frametable,. - camlCounting_bloom.frametable
	.section .note.GNU-stack,"",%progbits
