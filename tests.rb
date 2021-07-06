# FORMAT to run enter ruby memoryLeakCheck.rb C-FILENAME

=begin
    
Program should then do the following:
    - 1: open the C file (this ruby file needs to be in same folder as it, for now)
    - 2: go through all the lines in the file and note the ones that use calloc or malloc for allocations
    - 3: in those lines find the pointer name and keep track of it to check later if that same name is used in a call to free() function
    - 4: note all the pointer names that were not freed and keep them in a queue to print out to user the errors

COLOR FORMATTING MEANING:
    - dark blue: calloc or malloc is called to allocate memory
    - green: free() has been called to free memory
=end

require 'rainbow'

c_file = File.open(ARGV[0])
c_file_data = c_file.readlines


puts Rainbow("\n FILE CONTENTS: \n").underline.blue


# print the contents of the C file in a nice manner highlighting allocations and freeing
line_num = 1
for line in c_file_data
    
    if line.include? "calloc" or line.include? "malloc"
        puts Rainbow("#{line_num}:\t").yellow + Rainbow("#{line}").bg(:darkblue)
    elsif line.include? "free"
        puts Rainbow("#{line_num}:\t").yellow + Rainbow("#{line}").bg(:green)
    else
        puts Rainbow("#{line_num}:\t").yellow + line
    end

    line_num += 1
end 
puts Rainbow("\t\t\t\t\t\t\t\t").underline


#test to find the name of a pointer that has been allocated using calloc or malloc and checking to see if that pointer name is freed in the file
word_array = c_file_data[8].split(" ")
word_array[word_array.length - 2] += word_array.pop #combines the sizeof with the num of blocks
puts "\n"
for word in word_array
    puts word
end

#get the name of the pointer variable which is the 1st element of the array after the type ALWAYS
pointer_name = word_array[1]

#boolean to check if the pointer name is ever used in a free() call
freed = false

#go through all the lines in the file to check if a call to free is ever made with the pointer name
for line in c_file_data
    if line.include?("free(#{pointer_name})") and line.include?("//") == false and line.include?("/*") == false # two checks with symbols are to check if the free has been commented out or not
        freed = true
        break
    end
end


if freed == true
    puts Rainbow("#{pointer_name}").background(:green) + " has been freed!"
else
    puts Rainbow("#{pointer_name}").background(:red) + " has not been freed."
end
puts "\n"

=begin
for line in c_file_data
    word_array = line.split(" ")
    for word in word_array
        if word.include? "calloc" or word.include? "malloc"
            puts Rainbow(word).bg(:yellow)
        elsif word.include? "free"
            puts Rainbow(word).bg(:green)
        else
            puts word
        end
    end
end

=end

c_file.close
