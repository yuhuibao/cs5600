  .global main

  .text
main:
  enter $0, $0

  cmp $2, %rdi
  je corr
  mov $mess, %rdi
  call printf
  jmp main_done
corr:
  mov 8(%rsi), %rdi
  call atol

  cmp $0, %rax
  jge conti
  mov $mess, %rdi
  call printf
  jmp main_done
conti:
  mov %rax, %r9
  mov %rax, %rdi
  call fib

  mov %r9, %rsi
  mov %rax, %rdx
  mov $output_fmt, %rdi
  mov $0, %al
  call printf
main_done:
  leave
  ret
/*long fib(long x){
    if(x <= 1){
        return x;
    } else{
        return fib(x-1)
        + fib(x-2);
    }
}*/
fib:
  //x is %rdi
  enter $0, $0
  push %rbx
  mov %rdi,%rbx
  mov %rdi,%rax
  cmp $1, %rbx
  jle bc_done
  dec %rbx
  mov %rbx,%rdi
  call fib
  push %rax
  dec %rbx
  mov %rbx,%rdi
  call fib
  mov %rax,%r8
  pop %rax
  add %r8,%rax
bc_done:
  pop %rbx
  leave
  ret

  .data
output_fmt:  .string "fib(%ld) = %ld\n"
mess: .string "Usage:./fib N, where N>= 0\n"
