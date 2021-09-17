#include <stdio.h>
#include <stdlib.h>
#include "allocFunc.h"

int main(int argc, char const *argv[])
{
    
    int size = 10;

    char* arr = (char*)calloc(size, sizeof(char));
    int *arr2 = (int*)malloc(size * sizeof(int));

    int* arr3 = new_array();


    for (int i = 0; i < size; i++) {
        arr[i] = i + 1;
    }

    for (int i = 0; i < size; i++) {
        printf("Number @ index [%d] -> %d\n", i, arr[i]);
    }


    //free(arr);
    free(arr2);


    return 0;
}
