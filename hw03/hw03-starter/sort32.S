    .global main


    .text
main:
    enter $0, $0
    push %ebx
    push %esi
    push %edi
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
    jmp main_done
corr:
    mov 12(%ebp),%esi
    // argv[1] is 4(%esi)
    // argv[2] is 8(%esi)
    push 4(%esi)
    call test_input
    add $4, %esp
    sub %eax,%esp //allocate read_buf
    cdq
    mov $4,%ebx
    idiv %ebx
    mov %eax,%edi // # of numbers is %edi
    
    // 0(%esp) is read_buf

    mov $5, %eax // syscall 5 = open
    mov 4(%esi), %ebx
    mov $0, %ecx
    mov $0, %edx
    int $0x80
    mov %eax, %ebx // input file fd
    sub $12, %ebp
loop:
    cmp %ebp,%esp
    je loop_done
    mov $3, %eax // syscall 3 = read
    //push %ecx
    lea 0(%esp), %ecx
    mov $4, %edx
    int $0x80
    //pop %ecx
    //inc %ecx
    add $4, %esp
    jmp loop
loop_done:
    mov $4, %eax
    imul %edi, %eax
    sub %eax, %esp
    add $12, %ebp

    mov %esp,%ebx
    push %edi // array length
    push %ebx // address of array
    call insertion_sort
    add $8,%esp

    mov $6, %eax // syscall 6 = close
    int $0x80

    mov 8(%esi), %ebx
    mov $02, %ecx
    or $0100, %ecx
    mov $0644, %edx
    mov $5, %eax // syscall 5 = open
    int $0x80
    mov %eax, %ebx // output file fd
    mov $4, %eax
    imul %edi, %eax
    mov %eax, %edx // buf size
    lea 0(%esp), %ecx // write_buf
    mov $4, %eax // syscall 4 = write
    int $0x80
main_done:
    
    

    //add $4, %esp

    mov $0, %eax
    pop %edi
    pop %esi
    pop %ebx
    leave
    ret
insertion_sort:
    enter $0, $0
    push %ebx
    push %edi
    push %esi
    // address of array is 4(%ebp)-12-4*12(%ebp)
    // array length is 12(%ebp)
    mov 8(%ebp), %ebx
    mov $1, %ecx
    // i is %ecx
iloop:
    cmp 12(%ebp),%ecx
    jge iloop_done
    mov (%ebx,%ecx,4),%edx
    // value is %edx
    mov %ecx,%eax
    dec %eax
while:
    cmp $0, %eax
    jl while_done
    mov (%ebx,%eax,4),%edi
    // arr[j] is %edi
    cmp %edi,%edx
    jge while_done
    mov %eax,%esi
    inc %esi
    mov %edi,(%ebx,%esi,4)
    // arr[j+1]=arr[j]
    dec %eax
    jmp while
while_done:
    inc %eax
    mov %edx,(%ebx,%eax,4)
    dec %eax
    inc %ecx
    jmp iloop
iloop_done:
    pop %esi
    pop %edi
    pop %ebx
    leave
    ret
.globl test_input
    .data
usage_msg:  .string "Usage: ./sort input output\n"
output_fmt: .string "size of input file is %d\n"
