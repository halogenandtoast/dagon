module Dagon
  class Expression < Node
    def reduce
      type = next_node
      value = next_node
      case type
      when :noop
      when :identifier
        Identifier.new([type, value], binding).lookup
      when :integer
        DInteger.new(value)
      when :addition
        lhs = Expression.new(value, binding).reduce
        rhs = Expression.new(next_node, binding).reduce
        Operation.new(:+, lhs, rhs).reduce
      when :subtraction
        lhs = Expression.new(value, binding).reduce
        rhs = Expression.new(next_node, binding).reduce
        Operation.new(:-, lhs, rhs).reduce
      when :multiplication
        lhs = Expression.new(value, binding).reduce
        rhs = Expression.new(next_node, binding).reduce
        Operation.new(:*, lhs, rhs).reduce
      when :division
        lhs = Expression.new(value, binding).reduce
        rhs = Expression.new(next_node, binding).reduce
        Operation.new(:/, lhs, rhs).reduce
      when :exponentiation
        lhs = Expression.new(value, binding).reduce
        rhs = Expression.new(next_node, binding).reduce
        Operation.new(:**, lhs, rhs).reduce
      else
        error "Unknown type: #{type}"
      end
    end
  end

end
