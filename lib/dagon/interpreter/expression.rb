module Dagon
  class Expression < Node
    def reduce
      type = next_node
      value = next_node
      case type
      when :noop
      when :identifier
        id = Identifier.new([type, value], scope).lookup
        id.reduce
      when :integer
        DInteger.new(value)
      when :array
        DArray.new(value)
      when :string
        DString.new(value)
      when :addition
        lhs = Expression.new(value, scope).reduce
        rhs = Expression.new(next_node, scope).reduce
        Operation.new(:+, lhs, rhs).reduce
      when :subtraction
        lhs = Expression.new(value, scope).reduce
        rhs = Expression.new(next_node, scope).reduce
        Operation.new(:-, lhs, rhs).reduce
      when :multiplication
        lhs = Expression.new(value, scope).reduce
        rhs = Expression.new(next_node, scope).reduce
        Operation.new(:*, lhs, rhs).reduce
      when :division
        lhs = Expression.new(value, scope).reduce
        rhs = Expression.new(next_node, scope).reduce
        Operation.new(:/, lhs, rhs).reduce
      when :exponentiation
        lhs = Expression.new(value, scope).reduce
        rhs = Expression.new(next_node, scope).reduce
        Operation.new(:**, lhs, rhs).reduce
      else
        error "Unknown type: #{type}"
      end
    end
  end

end
