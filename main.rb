#gem
require 'rainbow'      

#get my queue data structure
require './DataStructs/queue.rb'

def is_mem_freed(file_data, pointer_name)
    freed = false
    for line in file_data
        if line.include?("free(#{pointer_name})") and line.include?("//") == false and line.include?("/*") == false # two checks with symbols are to check if the free has been commented out or not
            freed = true
            break
        end
    end
    return freed
end


def main

    c_file = File.open(ARGV[0])
    c_file_data = c_file.readlines

    puts Rainbow("\n FILE CONTENTS: \n").bg(:lime).black.bold

    line_num = 1
    for line in c_file_data
    
        if line.include? "calloc" or line.include? "malloc"
            puts Rainbow("#{line_num}:\t").yellow + Rainbow("#{line}").blue 
        elsif line.include? "free" and line.include?("//") == false and line.include?("/*") == false
            puts Rainbow("#{line_num}:\t").yellow + Rainbow("#{line}").green
        else    
            puts Rainbow("#{line_num}:\t").yellow + line
        end

        line_num += 1
    end 
    
    puts Rainbow("\t\t\t\t\t\t\t\t").underline

    pointer_name_queue = Queue.new

    line_count = 1
    for line in c_file_data
        if line.include? "calloc" or line.include? "malloc" and line.include?("//") == false and line.include?("/*") == false
            word_array = line.split(" ")
            pointer_name = word_array[1]

            # for now make a call to is_mem_freed? function here but later replace with a call queue or stack

            freed = is_mem_freed(c_file_data, pointer_name)

            if freed == false  
                # array with 0th element being the line number allocation occurs and the 1st element being the pointer reference name
                pointer_name_queue.add([line_count, pointer_name])
            end  
        end

        line_count += 1
    end

    if pointer_name_queue.size == 0
        puts Rainbow("\nNo memory leaks!\n").bg(:lime).black.bold
    else 
        puts Rainbow("\nMEMORY LEAKS\n").bg(:red).bold.white
        while (pointer_name_queue.isEmpty == false) 
            data_array = pointer_name_queue.remove()
            pointer_name = data_array[1]
            line_number = data_array[0]
            puts "- " + Rainbow("Line: #{line_number}").red.bold + " pointer with reference name: " + Rainbow("#{pointer_name}").underline.bold + " was allocated but never freed" 
        end
    end

    puts "\n\n"
end

main()