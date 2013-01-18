module Dagon
  class ConditionChain
    def initialize(conditional_statements, scope)
      unless conditional_statements.shift == :conditional_statement
        raise ArgumentError
      end
      statements = conditional_statements[0]
      statements.map! do |type, condition, block|
        [type, condition, DBlock.new(block[1], scope)]
      end
      @if_part = statements.shift
      if statements.count > 0
        if statements.last.first == :else
          @else_part = statements.pop
        end
        @else_if_parts = statements
      end
    end

    def reduce
      [if_part, *else_if_parts].each do |type, condition, dblock|
        if condition
          return dblock.invoke
        end
      end
      if else_part
        else_part.reduce
      end
    end

    private

    attr_accessor :if_part, :else_if_parts, :else_part
  end
end
