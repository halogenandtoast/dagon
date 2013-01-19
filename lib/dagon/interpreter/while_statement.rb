module Dagon
  class WhileStatement < Node
    def reduce
      expect :while_statement
      @condition = next_node
      @block = Block.new(next_node, scope).reduce
      DCondition.new(@condition, scope)._while(@block)
    end
  end
end
