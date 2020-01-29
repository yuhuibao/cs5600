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
    enter $0,$0
    mov $mess, %rdi
    call strlen

    mov $1, %rdi
    mov $mess, %rsi
    mov %rax,%rdx
    mov $1, %rax
    syscall
    mov $1, %rax
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
    /* write to stdout
    movl 0(%rsp),%r8d
    lea -10(%rbp),%rdi
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
    */
    inc %rbx
    add $4,%rsp
    jmp loop
loop_done:
    mov $4,%rax
    imul %r12,%rax
    sub %rax,%rsp

    mov $3,%rax //syscall 3 = close
    mov %r13,%rdi
    syscall

    lea 0(%rsp),%rdi
    mov %r12, %rsi
    call insertion_sort

    mov %r15,%rdi
    mov $02,%rsi
    or $0100,%rsi
    mov $0644,%rdx
    mov $2,%rax //syscall 2 = open
    syscall
    mov %rax,%r13 //output file fd
    lea 0(%rsp),%rsi //write_buf
    mov %r13,%rdi //fd
    mov $4,%rax
    imul %r12,%rax
    mov %rax,%rdx
    mov $1,%rax //syscall 1 = write
    syscall
    mov $0, %rax
main_done:
    leave
    pop %r15
    pop %r14
    pop %r13
    pop %r12
    pop %rbx
    ret

insertion_sort:
    enter $0,$0
    // address of array is in %rdi
    // array length is in %rsi
    mov $1, %rcx
    // i is %rcx
iloop:
    cmp %rsi, %rcx
    jge iloop_done
    movl (%rdi,%rcx,4),%edx
    // value is %rdx
    mov %rcx, %rax
    dec %rax
    // j is %rax
while:
    cmp $0, %rax
    jl while_done
    movl (%rdi,%rax,4),%r8d
    // arr[j] is %r8
    cmp %r8d,%edx
    jge while_done
    mov %rax, %r9
    inc %r9
    movl %r8d,(%rdi,%r9,4)
    // arr[j+1]=arr[j]  
    dec %rax
    jmp while
while_done:
    inc %rax
    movl %edx,(%rdi,%rax,4)
    dec %rax
    inc %rcx
    jmp iloop
iloop_done:
    leave
    ret
.globl test_input
    .data
mess:  .string "Usage: ./sort input output\n"
print_fmt: .string "%d\n"
    lea 0(%rsp),%rsi //read_buf

