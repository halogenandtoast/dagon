module Dagon
  class Call < Node
    def run
      if next_node != :call
        error "Invalid call"
      end

      identifier = Identifier.new(next_node, binding)
      expression = Expression.new(next_node, binding)
      method = identifier.lookup
      method.invoke(expression.reduce)
    end

  end
end
