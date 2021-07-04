require './DataStructs/node.rb'

class Queue
    def initialize
        @size = 0
        @head = nil
    end

    def add(data)

        newNode = Node.new(data)
        if (@head == nil)
            @head = newNode
            @size += 1
        else
            curr = @head
            while (curr.getNext != nil)
                curr = curr.getNext
            end

            curr.setNext(newNode)
            @size += 1
        end
    end

    def remove()
        # get data of old head node
        # set the heads next value as new head
        # return the head

        data = @head.getData
        @head = @head.getNext
        @size -= 1
        return data     
    end

    def isEmpty()
        return @head == nil
    end

    def size()
        return @size
    end

    def toArray()
        retArr = Array.new
        curr = @head

        while (curr != nil)
            retArr.push(curr.getData)
            curr = curr.getNext
        end

        return retArr
    end
end