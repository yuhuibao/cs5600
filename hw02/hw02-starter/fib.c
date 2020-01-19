
#include <stdio.h>
#include <stdlib.h>

long fib(long x){
    if(x <= 1){
        return x;
    } else{
        return fib(x-1) + fib(x-2);
    }
}

int
main(int argc, char* argv[])
{
    if(argc != 2){
        printf("Usage: ./fib N, where N >= 0\n");
        return 1;
    }
    long x = atol(argv[1]);
    if(x < 0){
        printf("Usage: ./fib N, where N >= 0\n");
        return 1;
    }
    long result = fib(x);
    printf("fib(%ld) = %ld\n", x,result);
    return 0;
}


