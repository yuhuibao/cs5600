#include <stdio.h>
#include <sys/stat.h>
/*
struct Car {
    char mode[52];
    int doors;
    int gasmilage;
};
*/
int sizeOfStat(struct stat st){
    return sizeof(st);
}
int offset(struct stat st){
    return (char*)&st.st_size - (char*)&st;
}
int test_input(char* name){

    struct stat st;
    stat(name,&st);
    /*
    printf("size of the struct is %d\n",sizeOfStat(st));
    */
    int off = offset(st);
    off_t size = *((char*)&st+off);

    return size;
}
/*
int main(int argc,char* argv[]){
    int size;
    size = test_input(argv[1]);
    printf("the size of the file is %d\n",size);
}
*/
