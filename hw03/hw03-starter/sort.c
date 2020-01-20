// for open(2)
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

// for close(2) read(2) and write(2)
#include <unistd.h>

// for non-syscall use only
#include <stdio.h> // for perro
#define OUTMODE 0644

// sort.c
// 
// - open a file file name is argv[1]
// - sort it
// - write the sorted array to file file name is argv[2]

void insersion_sort(int arr[],int nn){
    int j,value;
    for(int i = 1; i < nn; i++){
        value = arr[i];
        j = i - 1;
        while(j >= 0 && arr[j] > value){
            arr[j+1]=arr[j];
            j = j -1;
        }
        arr[j+1] = value;
    }
}

int
length(char* text)
{
    char* z;
    for (z = text; *z; ++z);
    return z - text;
}

int
main(int argc, char* argv[])
{
    if (argc != 3){
    char* usage = "Usage: ./sort input-file output-file";
    int rv = write(2, usage, length(usage));
    if (rv < 0) {
        // Checking your syscall return values is a
        // really good idea.
        perror("write in main");
        _exit(1);
    }
    return 1;
    }
    char write_buf[50];
    char* input = argv[1];
    char* output = argv[2];
    struct stat info;
    int rv = stat(input,&info);
    if (rv < 0) {
        // Checking your syscall return values is a
        // really good idea.
        perror("stat in main");
        _exit(1);
    }
    printf("size of the file:%ld\n",info.st_size);

    int len = info.st_size / 4;
    int array[len];

    int fd_i = open(input,O_RDONLY);
    int fd_o = open(output,O_CREAT | O_RDWR,OUTMODE);
    if (fd_o < 0){
        perror("open output file");
        _exit(1);
    }
    for(int i = 0;i <len ; i++){
        read(fd_i,&array[i],4);
        //printf("%d\n",array[i]);
        sprintf(write_buf,"%d\n",array[i]);
        write(1,write_buf,length(write_buf));
    }
    insersion_sort(array,len); 
    for(int i = 0; i< len; i++){
        rv = write(fd_o,&array[i],4);
        if (rv != 4){
            perror("write in  output file");
            _exit(1);
        }
        
    }
    return 0;
}

