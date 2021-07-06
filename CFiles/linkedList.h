#pragma once

#include <stdio.h>
#include <stdlib.h>

typedef struct Node
{
    /* data */
    int data;
    struct Node* next;
} Node;

typedef struct LinkedList
{
    /* data */
    Node* head;
    int size;
} LinkedList;


/* functions for Node struct */

Node* innit_node(int data){

    Node* newNode = (Node*)calloc(1, sizeof(Node*));
    newNode->data = data;
    newNode->next = NULL;

    return newNode;


}

/* end */


/* functions for linked list */

LinkedList* innit_list() {
    LinkedList* list = (LinkedList*)calloc(1, sizeof(LinkedList*));
    list->head = NULL;
    list->size = 0;
    return list;
}

void add(LinkedList* list, int data) {

    // make a new node with newNode function call
    // this funciton adds to end of list by default if list is not empty
    // if empty, make new node head
    // if not empty, go to end and make it new tail

    Node* newNode = innit_node(data);

    if (list->head == NULL) {
        list->head = newNode;
        list->size++;
    } else {
        Node* curr = list->head;

        while (curr->next != NULL) {
            curr = curr->next;
        }

        curr->next = newNode;
        list->size++;
    }

}

void addFirst(LinkedList* list, int data) {

    // make new node with data
    // if list is empty make new node the head node of list
    // if not empty make new node's next point to old head
    // update head pointer to new node

    Node* newNode = innit_node(data);
    
    if (list->head == NULL) {
        list->head = newNode;
        list->size++;
    } else {
        newNode->next = list->head;
        list->head = newNode;
        list->size++;
    }

}

void addAt(LinkedList* list, int index, int data) {

    // if list empty print error message
    // iterate through list if not empty while keeping count
    // when counter i == index - 1 stop and get next value of that pointer and store it
    // then make a new node, set prev pointer next to new node and new node pointer to prev's old next value
    
     


}

int getFirst(LinkedList* list) {
    
    // returns the data stored in the head of the given list

    return list->head->data;

}

int getLast(LinkedList* list) {
    
    // returns the data stored in the tail node of the given list

    Node* curr = list->head;

    while (curr->next != NULL) {
        curr = curr->next;
    }

    return curr->data;

}

int contains(LinkedList* list, int data) {

    // returns 1 if found and 0 if not found

    Node* curr = list->head;

    int found = 0;

    while (curr->next != NULL) {
        if (curr->data == data) {
            found = 1;
            break;
        }

        curr = curr->next;

    }

    return found;

}


void printAll(LinkedList* list) {
    Node* curr = list->head;

    while (curr != NULL) {
        printf("Data @ block [%p] -> %d\n", curr, curr->data);
        curr = curr->next;
    }
}

int size(LinkedList* list) {
    return list->size; 
}

/* end */