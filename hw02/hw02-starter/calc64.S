    .global main
    .text
    /*
int main(int argc, char* argv[]){
    if(argc != 4){
        printf("Usage:\n./calc N op N\n");
        return 0;
    }
    int x = atoi(argv[1]);
    int y = atoi(argv[3]);
    int res;
    char op = argv[2][0];
*/
main:
    enter $0,$0
    // argc is %rdi
    // argv is %rsi type char**
    // argv[1] is x 8(%rsi)
    // argv[2] is op 16(%rsi)
    // argv[3] is y 24(%rsi)
    cmp $4,%rdi
    je corr
    mov $mess,%rdi
    call printf
    jmp main_done
corr:
    mov %rsi,%rbx
    mov 8(%rsi),%rdi
    call atoi
    // %r12 is x
    mov %rax,%r12
    mov 24(%rbx),%rdi
    call atoi
    // %r13 is y
    mov %rax,%r13
    mov 16(%rbx),%r8
    // %bl is op
    mov (%r8),%bl
    cmp $'+,%bl
    jne conti
    mov %r12,%rdi
    mov %r13,%rsi
    call add
    jmp calc_done
conti:
    cmp $'-,%bl
    jne conti1
    mov %r12,%rdi
    mov %r13,%rsi
    call sub
    jmp calc_done
conti1:
    cmp $'*,%bl
    jne conti2
    mov %r12,%rdi
    mov %r13,%rsi
    call mult
    jmp calc_done
conti2:
    cmp $'/,%bl
    jne no_op
    mov %r12,%rdi
    mov %r13,%rsi
    call my_div
calc_done:
    mov $print_fmt,%rdi
    mov %r12,%rsi
    mov $0,%rdx
    movb %bl,%dl
    mov %r13,%rcx
    mov %rax,%r8
    call printf
    jmp main_done
no_op:
    mov $mess,%rdi
    call printf
main_done:
    leave
    ret
add:
    enter $0,$0
    mov %rdi,%rax
    add %rsi,%rax
    leave
    ret
sub:
    enter $0,$0
    mov %rdi,%rax
    sub %rsi,%rax
    leave
    ret
mult:
    enter $0,$0
    mov %rdi,%rax
    imul %rsi
    leave
    ret
my_div:
    enter $0,$0
    mov %rdi,%rax
    cqo
    idiv %rsi
    leave
    ret
    .data
print_fmt: .string "%d %c %d = %d\n"
mess: .string "Usage:\n./calc64 N op N\n"
