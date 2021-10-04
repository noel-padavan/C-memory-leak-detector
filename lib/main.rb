# typed: ignore

#gem
require 'rainbow' 
   
#get my queue data structure
require './DataStructs/queue.rb'

module MemoryLeakTool 

    # custom allocation functions name array
    caf = []

    # custom deallocation functions name array
    cdf = []

    # stores amount of memory leaked in bytes, approximate as only primitive types below are counted
    @total_memory_loss_BYTES = 0


    # hash table for bye values (ALL primitive types in C only)
    # this table will be used in future versions, for now I dont need this for MY use.
    type_byte_sizes_COMPLEX = {
        'short int': 2,
        'unsigned short int ': 2,
        'unsigned int ': 4,
        'int': 4,
        'long int': 4,
        'unsigned long int ': 4,
        'long long int ': 8,
        'unsigned long long int ': 8,
        'char': 1,
        'float': 4,
        'double': 8,
        'long double': 16
    }

    # simple hash table that only contains the basic primitive types not the complex ones
    # uses this implementation to be able to get values using a String key!
    @type_byte_sizes_BASIC = Hash.new
    @type_byte_sizes_BASIC["int"] = 4
    @type_byte_sizes_BASIC["char"] = 1
    @type_byte_sizes_BASIC["float"] = 4
    @type_byte_sizes_BASIC["double"] = 8

    def self.is_mem_freed(file_data, pointer_name)
        freed = false

        # WHEN PROBLEMS SOLVED ADD CUSTOM DEALLOC FUNC CALL CHECK HERE

        for line in file_data
            if line.include?("free(#{pointer_name})") and line.include?("//") == false and line.include?("/*") == false # two checks with symbols are to check if the free has been commented out or not
                freed = true
                break
            end
        end
        return freed
    end
    
    
    def self.main
    
        if (ARGV.length == 0) 
            raise "Error: no path to C file provided."
        elsif (File.file?(ARGV[0]) == false) 
            raise "Error: entered file does not exist."
        else # start of checks for flags
            if (ARGV.include?("-caf") and ARGV.include?("-cdf"))
    
                puts "\nHas custom allocation AND deallocation functions ✔️✔️"
                caf = ARGV[ARGV.find_index("-caf") + 1, ARGV.find_index("-cdf") - 2]
                cdf = ARGV[ARGV.find_index("-cdf") + 1, ARGV.length]
                puts "Custom Allocation Functions array: "
                puts caf.to_s
                puts "Custom deallocation Functions array: "
                puts cdf.to_s
                
            
            elsif (ARGV.include?("-cdf"))
                
                puts "\nHas custom deallocation functions ✔️"
                cdf = ARGV[ARGV.find_index("-cdf") + 1, ARGV.length]
                puts "Custom Deallocation functions given: "
                puts cdf.to_s
            
            elsif (ARGV.include?("-caf"))
            
                puts Rainbow("\nHas custom allocation functions ✔️\n").green.bold.italic
                caf = ARGV[ARGV.find_index("-caf") + 1, ARGV.length]
                puts Rainbow("Custom allocation functions given: ").indianred.bold.italic
                puts caf
            
            elsif (ARGV.include?("-cdf") == false and ARGV.include?("-caf") == false)
                puts Rainbow("\nNO custom allocation AND deallocation functions given, using default malloc and calloc...").yellow.bold
            else
                puts "Invalid arg(s)"
            end
        end #end of checks for flags
        

        # BEGN of parsing and line highlighting

        c_file = File.open(ARGV[0])
        c_file_data = c_file.readlines
    
        puts Rainbow("\t\t\t\t\t\t\t\t ").underline.lime
        puts Rainbow("|\t\t\tFILE CONTENTS:").lime.bold.underline + Rainbow("\t\t\t\t|\n").lime.bold.underline 
    
        line_num = 1
        for line in c_file_data
            
            lineArr = line.split(" ")
            foundCAFcall = false
            foundCDFcall = false

            if ((caf != nil and cdf != nil) and (caf.length > 0 and cdf.length > 0))
                for word in lineArr
                    word = word.tr('();', '')
                    if caf.include?(word)
                        foundCAFcall = true
                    elsif cdf.include?(word)
                        foundCDFcall = true
                    end
                end
            elsif ((caf != nil) and (caf.length > 0))
                for word in lineArr
                    word = word.tr('();', '')
                    if caf.include?(word)
                        foundCAFcall = true
                    end
                end
            elsif ((cdf != nil) and (cdf.length > 0))
                for word in lineArr
                    word = word.tr('();', '')
                    if cdf.include?(word)
                        foundCDFcall = true
                    end
                end
            end

            # highlight lines with custom allocation/deallocation funcntion calls
            # kind of buggy, starts highlighting mutli-line comments that contains words such as free
            if line.include? "calloc" or line.include? "malloc" or foundCAFcall
                print Rainbow("#{line_num}:\t").yellow.bold + Rainbow("#{line}").yellow 
            elsif line.include? "free" or foundCDFcall and line.include?("//") == false and line.include?("/*") == false
                print Rainbow("#{line_num}:\t").yellow.bold + Rainbow("#{line}").green
            else    
                puts Rainbow("#{line_num}:\t").yellow + line
            end
    
            line_num += 1
        end 
    
        pointer_name_queue = Queue.new
    
        line_count = 1
        for line in c_file_data

            lineArr = line.split(" ")

            if ((caf != nil) and (caf.length > 0))
                for word in lineArr
                    word = word.tr('();', '')
                    if caf.include?(word)
                        
                        pointer_name = lineArr[1]
                        pointer_type = lineArr[0]

                        # if the pointer name is of form *name, this removes the * infront
                        if pointer_name.include?("*") 
                            pointer_name = pointer_name[1, pointer_name.length - 1]
                        end

                        # if the pointer type is of form int*, this removes the * at the end
                        if pointer_type.include?("*") 
                            pointer_type = pointer_type[0, pointer_type.length - 1]
                        end
                        
                        freed = MemoryLeakTool::is_mem_freed(c_file_data, pointer_name)
    
                        if freed == false  
                            # array with 0th element being the line number allocation occurs and the 1st element being the pointer reference name
                            pointer_name_queue.add([line_count, pointer_name])
                            
                            # START OF BUGS 
                            if @type_byte_sizes_BASIC.key?(pointer_type)
                                @total_memory_loss_BYTES += @type_byte_sizes_BASIC[pointer_type]
                                # puts "GOT CALLED"
                            end
                            # END OF BUGS

                            # puts pointer_type

                        end
                    end
                end
            end

            if line.include? "calloc" or line.include? "malloc" and line.include?("//") == false and line.include?("/*") == false
                word_array = line.split(" ")
                pointer_name = word_array[1]
                pointer_type = lineArr[0]
                
                # if the pointer name is of form *name, this removes the * infront
                if pointer_name.include?("*") 
                    pointer_name = pointer_name[1, pointer_name.length - 1]
                end 

                # if the pointer type is of form int*, this removes the * at the end
                if pointer_type.include?("*") 
                    pointer_type = pointer_type[0, pointer_type.length - 1]
                end
    
                # for now make a call to is_mem_freed? function here but later replace with a call queue or stack
    
                freed = MemoryLeakTool::is_mem_freed(c_file_data, pointer_name)
    
                if freed == false  
                    # array with 0th element being the line number allocation occurs and the 1st element being the pointer reference name
                    pointer_name_queue.add([line_count, pointer_name])

                    # START OF BUGS
                    if @type_byte_sizes_BASIC.key?(pointer_type)
                        @total_memory_loss_BYTES += @type_byte_sizes_BASIC[pointer_type]
                        # puts "GOT CALLED"
                    end
                    # END OF BUGS
                    # puts pointer_type

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
            puts "\n- " + Rainbow("Approximate memory leak size").red.bold + " ≈ " + Rainbow("#{@total_memory_loss_BYTES} bytes").yellow.bold
        end
        puts "\n\n"
    end
    
end

MemoryLeakTool::main