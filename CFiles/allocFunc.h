#pragma once

#include <stdlib.h>

int* new_array() {
    int* arr = (int*)calloc(10, sizeof(int));
    return arr;
}