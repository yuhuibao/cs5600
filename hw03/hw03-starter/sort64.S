    .global main

    .text
main:
    push %rbx
    push %r12
    push %r13
    push %r14
    push %r15

/*
int main(int argc, char* argv[])
{
    //argc is %rdi
    //argv is %rsi
    if(argc !=3){
        puts("Usage:");
        return 1;
    }
*/
    cmp $3,%rdi
    je corr
    mov $mess, %rdi
    call printf
    jmp main_done
corr:
    mov 8(%rsi),%r14 //input file
    mov 16(%rsi),%r15 //output file
    mov %r14,%rdi
    call test_input //input size is %rax
    enter $10,$0
    sub %rax,%rsp //allocate read_buf
    mov $4,%r10
    cqo
    idiv %r10
    mov %rax,%r12 //# of numbers is %r12


    // 0(%rsp) is read_buf
    
    mov %r14,%rdi
    mov $0,%rsi
    mov $0,%rdx
    mov $2,%rax //syscall 2 = open
    syscall
    mov %rax,%r13 //input file fd

    mov $0,%rbx
loop:
    cmp %r12,%rbx
    jge loop_done
    mov %r13,%rdi //fd
    mov $4,%rdx // buffer size
    mov $0,%rax //syscall 0 = read
    lea 0(%rsp),%rsi //read_buf
    syscall
    movl 0(%rsp),%r8d
    lea 16(%rsp),%rdi
    mov $print_fmt,%rsi
    mov $0,%rdx
    movl %r8d,%edx
    mov $0,%al
    call sprintf
    lea -10(%rbp),%rdi
    call strlen
    lea -10(%rbp),%rsi //write_buf
    mov $1,%rdi //stout
    mov %rax,%rdx
    mov $1,%rax //syscall 1 = write
    syscall
    inc %rbx
    add $4,%rsp
    jmp loop
loop_done:
    mov $4,%rax
    imul %r12,%rax
    add %rax,%rsp
    /*
    mov $4,%rdx // buffer size
    mov $0,%rax //syscall 0 = read
    */

    mov $3,%rax //syscall 3 = close
    mov %r13,%rdi
    syscall
main_done:
    leave
    pop %r15
    pop %r14
    pop %r13
    pop %r12
    pop %rbx
    ret
.globl test_input
    .data
mess:  .string "Usage: ./sort input output"
print_fmt: .string "%d\n"
    lea 0(%rsp),%rsi //read_buf

