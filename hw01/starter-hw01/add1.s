  .global add1
  .text
add1:
  enter $0,$0
  mov 8(%ebp),%eax
  inc %eax
  leave
  ret
