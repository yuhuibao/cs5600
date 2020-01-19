    .global main

    .text
main:
    enter $0, $0
    mov 8(%ebp),%ecx
    cmp $2,%ecx
    je corr
    push $mess
    call printf
    jmp main_done
    // 12(%ebp) is argv[]
    // argv[1] is x
corr:
    mov 12(%ebp), %ecx
    mov 4(%ecx), %eax
    push %eax
    call atoi
    add $4, %esp
    mov %eax,%edx
    cmp $0,%edx
    jge not_neg
    push $mess
    call printf
    jmp main_done
not_neg:
    push %eax
    call fib
    add $4,%esp

    push %eax
    push %edx
    push $output_fmt
    call printf
    add $12, %esp
main_done:
    leave
    ret
fib:
    enter $0, $0
    // x is %ebx
    push %ebx
    mov 8(%ebp),%ebx

    mov %ebx, %eax
    cmp $1, %ebx
    jle fib_done
    dec %ebx
    push %ebx
    call fib
    add $4, %esp

    push %eax

    dec %ebx
    push %ebx
    call fib
    add $4, %esp
    mov %eax,%ecx
    pop %eax
    add %ecx,%eax
fib_done:
    pop %ebx
    leave
    ret
    .data
output_fmt:  .string "fib(%ld) = %ld\n"
mess: .string "Usage:./fib N, where N>= 0\n"
