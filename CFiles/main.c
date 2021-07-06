#include <stdio.h>
#include <stdlib.h>

// import the linkedList structs and functions from header
#include "linkedList.h"


int main(int argc, char const *argv[])
{
    LinkedList* list = innit_list();

    add(list, 1);
    add(list, 2);
    add(list, 3);
    add(list, 4);
    add(list, 5);

    addFirst(list, 0);
    addFirst(list, -1);
    addFirst(list, -2);
    addFirst(list, -3);

    printAll(list);
    printf("\nLIST SIZE: %d\n", size(list));

    printf("\nData @ head: %d\nData @ tail: %d\n", getFirst(list), getLast(list));


    int num;

    printf("Enter number to search for in list: ");
    scanf("%d", &num);

    printf("\nDoes the list contain the number %d: %d\n", num, contains(list, num));


    return 0;
}
