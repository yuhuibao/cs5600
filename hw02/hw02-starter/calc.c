#include <stdio.h>
#include <stdlib.h>

long add(long x, long y){
    return x + y;
}

long sub(long x, long y){
    return x - y;
}

long mult(long x, long y){
    return x * y;
}

long my_div(long x, long y){
    return x / y;
}

int main(int argc, char* argv[]){
    if(argc != 4){
        printf("Usage:\n./calc N op N\n");
        return 1;
    }
    long x = atoi(argv[1]);
    long y = atoi(argv[3]);
    long res;
    char op = argv[2][0];
    switch(op){
        case '+':
            res = add(x,y);
            break;
        case '-':
            res = sub(x,y);
            break;
        case '*':
            res = mult(x,y);
            break;
        case '/':
            res = my_div(x,y);
            break;
        default:
            printf("Usage:\n./calc N op N\n");
            return 1;
    }
    printf("%d %c %d = %d\n",x,op,y,res);
    return 0;
} 
