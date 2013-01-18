module Dagon
  class Method
    def initialize name, &block
      @name = name
      @block = block
    end

    def invoke *args
      @block.call(*args)
    end

    def reduce
      invoke
    end
  end
end
