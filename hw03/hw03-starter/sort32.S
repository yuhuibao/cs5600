    .global main


    .text
main:
    enter $0, $0
    push %ebx
    // argc is 8(%ebp)
    // argv is 12(%ebp)
    mov 8(%ebp),%ecx
    cmp $3,%ecx
    je corr
    push $usage_msg
    call strlen
    add $4,%esp

    mov %eax, %edx
    mov $1, %ebx
    mov $usage_msg, %ecx
    mov $4, %eax
    int $0x80
corr:
    mov 12(%ebp),%esi
    // argv[1] is 4(%esi)
    // argv[2] is 8(%esi)
    
    //enter $0, $0


    //add $4, %esp

    //mov $2, %eax
    pop %ebx
    leave
    ret
    .data
usage_msg:  .string "Usage: ./sort input output\n"
    
