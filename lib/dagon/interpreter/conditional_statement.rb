module Dagon
  class ConditionalStatement < Node
    def initialize(ast, scope)
      super
      expect :conditional_statement
      @branches = next_node.map do |type, condition, block|
        [type, DCondition.new(condition), Block.new(block, scope).reduce]
      end
    end

    def reduce
      branches.each do |type, condition, dblock|
        return if condition.reduce._if(dblock)
      end
    end

    private

    attr_accessor :branches
  end
end
