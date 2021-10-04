# C-memory-leak-detector

A simple, bare-bones memory leak detector for C. Written with Ruby.

## example run
<img width="2640" alt="Screen Shot 2021-10-04 at 10 34 47 AM" src="https://user-images.githubusercontent.com/70342060/135870752-8e877062-a58c-47c8-af7b-d880fc389a8b.png">

## Important note

Keep in mind that this is an EXTREMLEY basic memory leak detector intended to be used by people just learning about memory allocations in C. 

***This is not made to traverse your big complicated C project and save you from costly memory leaks***.

If you are learning about making memory allocations in C with calls to `malloc()` or `calloc()` this is a good tool for you to use to make sure you get into the habit of freeing the memory you use with the `free()` function. The use of custom allocation and dealloction functions is still in the works.

## How to Run

The memory leak detector is a command line tool. Simple enter `ruby main.rb [path to C file to scan]` and the program will output the result of the search for leaks. If you have custom allocation and/or deallocation function anmes use the following flags when running the command mentioned before in the terminal. 

- Flag to add custom allocation function name(s): `-caf [name of custom allocation function 1] [name of custom allocation function 2] [name of custom allocation function .....]`

- Flag to add custom deallocation function name(s): `-cdf [name of custom deallocation function 1] [name of custom deallocation function 2] [name of custom deallocation function .....]`

Remember when passing the names there is no need for the square brackets `[]` around them.

***A work in progress by Noel Padavan***
