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

    if (ARGV.length == 0) 
        raise "Error: no path to C file provided."
    elsif (File.file?(ARGV[0]) == false) 
        raise "Error: entered file does not exist."
    end

    c_file = File.open(ARGV[0])
    c_file_data = c_file.readlines

    puts Rainbow("\t\t\t\t\t\t\t\t ").underline.lime
    puts Rainbow("|\t\t\tFILE CONTENTS:").lime.bold.underline + Rainbow("\t\t\t\t|\n").lime.bold.underline 

    line_num = 1
    for line in c_file_data
    
        if line.include? "calloc" or line.include? "malloc"
            puts Rainbow("#{line_num}:\t").yellow + Rainbow("#{line}").purple 
        elsif line.include? "free" and line.include?("//") == false and line.include?("/*") == false
            puts Rainbow("#{line_num}:\t").yellow + Rainbow("#{line}").green
        else    
            puts Rainbow("#{line_num}:\t").yellow + line
        end

        line_num += 1
    end 

    pointer_name_queue = Queue.new

    line_count = 1
    for line in c_file_data
        if line.include? "calloc" or line.include? "malloc" and line.include?("//") == false and line.include?("/*") == false
            word_array = line.split(" ")
            pointer_name = word_array[1]

            if pointer_name.include?("*") 
                pointer_name = pointer_name[1, pointer_name.length - 1]
            end 

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
        puts Rainbow("\n\t\t\t\t\t\t\t\t ").underline.lime
        puts Rainbow("|\t\t\tNO MEMORY LEAKS").lime.bold.underline + Rainbow("\t\t\t\t|\n").lime.bold.underline 
    else 
        puts Rainbow("\n\t\t\t\t\t\t\t\t ").underline.red
        puts Rainbow("|\t\t\tMEMORY LEAKS:").red.bold.underline + Rainbow("\t\t\t\t|\n").red.bold.underline 
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