# typed: ignore

class Node
    def initialize(data)
        @data = data
        @next = nil
        @prev = nil
    end

    def getNext()
        return @next
    end

    def getPrev()
        return @prev
    end

    def getData()
        return @data
    end

    def setNext(link) 
        @next = link
    end

    def setPrev(link)
        @prev = link
    end
end