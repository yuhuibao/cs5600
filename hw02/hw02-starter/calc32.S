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
    // argc is 8(%ebp)
    // argv is 12(%ebp)
    mov 8(%ebp),%ecx
    cmp $4,%ecx
    je corr
    mov $mess,%eax
    push %eax
    call printf
    jmp main_done
corr:
    mov 12(%ebp),%ecx
    // argv[1] is 4(%ecx)
    mov 4(%ecx),%edx
    push %ecx
    push %edx
    call atoi
    add $4,%esp
    pop %ecx
    mov %eax,%esi

    // argv[3] is 12(%ecx)
    mov 12(%ecx),%edx
    push %ecx
    push %edx
    call atoi
    add $4,%esp
    pop %ecx
    mov %eax,%edi

    // argv[2] is 8(%ecx)
    // op is %edx
    mov 8(%ecx),%ebx
    mov (%ebx),%edx
   
    cmp $'+,%dl
    jne conti
    push %edi
    push %esi
    call add
    add $8,%esp
    jmp calc_done
conti:
    cmp $'-,%dl
    jne conti1
    push %edi
    push %esi
    call sub
    add $8,%esp
    jmp calc_done
conti1:
    cmp $'*,%dl
    jne conti2
    push %edi
    push %esi
    call mult
    add $8,%esp
    jmp calc_done
conti2:
    cmp $'/,%dl
    jne no_op
    push %edi
    push %esi
    call my_div
    add $4,%esp
calc_done:
    push %eax
    push %edi
    push %edx
    push %esi
    push $print_fmt
    call printf
    add $20,%esp
    jmp main_done
no_op:
    mov $mess,%edx
    push %edx
    call printf
    add $4,%esp
main_done:
    leave
    ret
add:
    enter $0,$0
    // 8(%ebp) is x
    // 12($ebp) is y
    mov 8(%ebp),%eax
    mov 12(%ebp),%ebx
    add %ebx,%eax
    leave
    ret
sub:
    enter $0,$0
    // 8(%ebp) is x
    // 12($ebp) is y
    mov 8(%ebp),%eax
    mov 12(%ebp),%ebx
    sub %ebx,%eax
    leave
    ret
mult:
    enter $0,$0
    // 8(%ebp) is x
    // 12($ebp) is y
    mov 8(%ebp),%eax
    mov 12(%ebp),%ebx
    imul %ebx,%eax
    leave
    ret
my_div:
    enter $0,$0
    push %edx
    // 8(%ebp) is x
    // 12($ebp) is y
    mov 8(%ebp),%eax
    cdq
    mov 12(%ebp),%ebx
    idiv %ebx
    pop %edx
    leave
    ret

    .data
print_fmt: .string "%d %c %d = %d\n"
mess: .string "Usage:\n./calc32 N op N\n"
