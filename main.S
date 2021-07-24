// SPDX-License-Identifier: GPL-2.0
/*
 * @author Ammar Faizi <ammarfaizi2@gmail.com> https://www.facebook.com/ammarfaizi2
 * @license GNU GPL-2.0
 *
 * Copyright (C) 2021  Ammar Faizi
 */


/*
 *
 * struct member {
 * 	char	name[64];		// Name
 * 	char	tg_username[32];	// Telegram username
 * 	char	gender;			// m (male), f (female), h (hidden)
 * };
 *
 */

#define STACK_ALIGNMENT_TRAP	movdqa	(%rsp), %xmm0

/*
 * Offset info.
 */
#define ST_OFF_NAME		(0)
#define ST_OFF_TG_USERNAME	(64)
#define ST_OFF_GENDER		(64 + 32)

/*
 * Size info.
 */
#define ST_SIZEOF_NAME		(64)
#define ST_SIZEOF_TG_USERNAME	(32)
#define ST_SIZEOF_GENDER	(1)
#define SIZEOF_STRUCT_MEMBER	(64 + 32 + 1)

.section .rodata
menu_str:
	.ascii "========================================================\n"
	.ascii "====     Welcome to GNU/Weeb Member DB Software     ====\n"
	.ascii "========================================================\n"
	.ascii "\t1. [C] Add a new member\n"
	.ascii "\t2. [R] Show members\n"
	.ascii "\t3. [U] Update a member\n"
	.ascii "\t4. [D] Delete a member\n"
	.ascii "\t5. Exit\n"
	.ascii "========================================================\n"
	.ascii "Enter menu: "
	.byte 0x0
invalid_menu_str:
	.ascii "Invalid menu number selected!\n"
	.ascii "Please re-enter the menu number based on available options!\n"
	.byte 0x0
hang_until_enter_str:
	.ascii "\n\nPress enter to continue! "
	.byte 0x0
clear_screen_bytes:
	.byte 0x1b, 0x63, 0x00

reg_start_str:
	.ascii "======== Add a new member ========\n"
	.byte 0x0
reg_name_str:
	.ascii "Enter name: "
	.byte 0x0
reg_tg_username_str:
	.ascii "Enter Telegram username: "
	.byte 0x0
reg_gender_str:
	.ascii "Enter gender (m (male), f (female), h (hidden)): "
	.byte 0x0

.section .text
.global _start

_start:
	movq	(%rsp), %rdi
	leaq	8(%rsp), %rsi
	leaq	16(%rsp, %rdi, 8), %rdx
	xorl	%ebp, %ebp
	andq	$-16, %rsp
	STACK_ALIGNMENT_TRAP
	callq	main
	movl	%eax, %edi
	movl	$60, %eax
	syscall


// int main(int argc, char *argv[], char *envp[]);
main:
	pushq	%rbp
	movq	%rsp, %rbp
	STACK_ALIGNMENT_TRAP
.Lmain__show_menu:
	callq	clear_screen
	callq	show_menu
	testl	%eax, %eax
	js	.Lmain__invalid_menu
	cmpl	$1, %eax
	je	.Lmain__do_add_member
	cmpl	$2, %eax
	cmpl	$3, %eax
	cmpl	$4, %eax
	cmpl	$5, %eax
	je	.Lmain__out
	jmp	.Lmain__show_menu

.Lmain__do_add_member:
	callq	do_add_member
	jmp	.Lmain__hang

.Lmain__invalid_menu:
	callq	show_invalid_menu_alert
.Lmain__hang:
	callq	hang_until_enter
	jmp	.Lmain__show_menu
.Lmain__out:
	xorl	%eax, %eax
	movq	%rbp, %rsp
	popq	%rbp
	retq


// ssize_t print(const char *text);
print:
	pushq	%rbp
	movq	%rsp, %rbp
	STACK_ALIGNMENT_TRAP
	xorl	%edx, %edx
	xorl	%eax, %eax
	movq	%rdi, %rcx
	cmpb	$0, (%rcx)
	jz	.Lprint__out
/*
 * Calculate the string length.
 * String ends with a NUL char.
 */
.Lprint__do_loop:
	addq	$1, %rdx
	addq	$1, %rcx
	cmpb	$0, (%rcx)
	jnz	.Lprint__do_loop
	movq	%rdi, %rsi
	movl	$1, %edi
	movl	$1, %eax
	syscall
.Lprint__out:
	movq	%rbp, %rsp
	popq	%rbp
	retq


// ssize_t read_stdin(char *buffer, size_t length);
read_stdin:
	pushq	%rbp
	movq	%rsp, %rbp
	STACK_ALIGNMENT_TRAP
	movq	%rsi, %rdx
	movq	%rdi, %rsi
	xorl	%eax, %eax
	xorl	%edi, %edi
	syscall
	movq	%rbp, %rsp
	popq	%rbp
	retq


// int show_menu(void);
show_menu:
	pushq	%rbp
	movq	%rsp, %rbp

	/*
	 * Allocate 128-bytes buffer on the stack.
	 */
	subq	$128, %rsp
	STACK_ALIGNMENT_TRAP
	leaq	menu_str(%rip), %rdi
	callq	print
	leaq	-128(%rbp), %rdi
	movl	$128, %esi
	callq	read_stdin
	cmpl	$2, %eax
	jg	.Lshow_menu__invalid
	/*
	 * Valid input is only '1' to '5'
	 */
	movzbl	-128(%rbp), %eax
	cmpl	$'1', %eax
	jb	.Lshow_menu__invalid
	cmpl	$'5', %eax
	ja	.Lshow_menu__invalid
	subl	$'0', %eax
	jmp	.Lshow_menu__out
.Lshow_menu__invalid:
	movl	$-1, %eax
.Lshow_menu__out:
	movq	%rbp, %rsp
	popq	%rbp
	retq


// void show_invalid_menu_alert(void);
show_invalid_menu_alert:
	pushq	%rbp
	movq	%rsp, %rbp
	STACK_ALIGNMENT_TRAP
	leaq	invalid_menu_str(%rip), %rdi
	callq	print
	movq	%rbp, %rsp
	popq	%rbp
	retq


// void clear_screen(void);
clear_screen:
	pushq	%rbp
	movq	%rsp, %rbp
	STACK_ALIGNMENT_TRAP
	leaq	clear_screen_bytes(%rip), %rdi
	callq	print
	movq	%rbp, %rsp
	popq	%rbp
	retq


// void hang_until_enter(void);
hang_until_enter:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$128, %rsp
	STACK_ALIGNMENT_TRAP
	leaq	hang_until_enter_str(%rip), %rdi
	callq	print
	leaq	-128(%rbp), %rdi
	movl	$128, %esi
	callq	read_stdin
	movq	%rbp, %rsp
	popq	%rbp
	retq


// void do_add_member(void);
do_add_member:
	pushq	%rbp
	pushq	%rbx
	pushq	%r12
	movq	%rsp, %rbp
	subq	$((SIZEOF_STRUCT_MEMBER + 15ul) & -16ul), %rsp
	STACK_ALIGNMENT_TRAP

	// Start struct address.
	leaq	-((SIZEOF_STRUCT_MEMBER + 64ul) & -16ul)(%rbp), %rbx

	callq	clear_screen

	leaq	reg_start_str(%rip), %rdi
	callq	print

	/*
	 * What is your name?
	 */
	leaq	reg_name_str(%rip), %rdi
	callq	print
	leaq	ST_OFF_NAME(%rbx), %rdi
	movl	$ST_SIZEOF_NAME, %esi
	callq	read_stdin


	/*
	 * What is your Telegram username?
	 */
	leaq	reg_tg_username_str(%rip), %rdi
	callq	print
	leaq	ST_OFF_TG_USERNAME(%rbx), %rdi
	movl	$ST_SIZEOF_NAME, %esi
	callq	read_stdin


	/*
	 * What is your gender?
	 */
	leaq	reg_gender_str(%rip), %rdi
	callq	print
	leaq	ST_OFF_GENDER(%rbx), %rdi
	/*
	 * Prone input!
	 *
	 * We need to at least read 2 chars.
	 * Make sure we have allocated enough space
	 * after the struct area.
	 */
	movl	$(ST_SIZEOF_GENDER + 3), %esi
	callq	read_stdin

	/* TODO: Add validation and save the struct into a file. */

	movq	%rbp, %rsp
	popq	%r12
	popq	%rbx
	popq	%rbp
	retq
