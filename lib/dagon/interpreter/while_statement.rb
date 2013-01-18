module Dagon
  class WhileStatement
    def initialize(node, scope)
      type = node[0]
      @condition = node[1]
      @block = Block.new(node[2], scope).reduce
    end

    def reduce
      while @condition
        @block.reduce
      end
    end
  end
end
