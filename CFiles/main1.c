#include <stdio.h>
#include <stdlib.h>

int main(int argc, char const *argv[])
{
    
    int size = 10;

    int* arr = (int*)calloc(size, sizeof(int));
    int *arr2 = (int*)malloc(size * sizeof(int));


    for (int i = 0; i < size; i++) {
        arr[i] = i + 1;
    }

    for (int i = 0; i < size; i++) {
        printf("Number @ index [%d] -> %d\n", i, arr[i]);
    }


    free(arr);
    //free(arr2);


    return 0;
}
