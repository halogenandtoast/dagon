module Dagon
  module Ast
    class Expression < Node
      def reduce
        type = next_node
        value = next_node
        case type
        when :noop
        when :identifier
          id = Dagon::Ast::Identifier.new([type, value], scope).lookup
          if id.is_a? Dagon::Core::Method
            id.invoke
          else
            id
          end
        when :integer
          Dagon::Core::Integer.new(value)
        when :array
          Dagon::Core::Array.new(value)
        when :string
          Dagon::Core::String.new(value)
        when :addition
          lhs = Dagon::Ast::Expression.new(value, scope).reduce
          rhs = Dagon::Ast::Expression.new(next_node, scope).reduce
          Dagon::Ast::Operation.new(:+, lhs, rhs).reduce
        when :subtraction
          lhs = Dagon::Ast::Expression.new(value, scope).reduce
          rhs = Dagon::Ast::Expression.new(next_node, scope).reduce
          Dagon::Ast::Operation.new(:-, lhs, rhs).reduce
        when :multiplication
          lhs = Dagon::Ast::Expression.new(value, scope).reduce
          rhs = Dagon::Ast::Expression.new(next_node, scope).reduce
          Dagon::Ast::Operation.new(:*, lhs, rhs).reduce
        when :division
          lhs = Dagon::Ast::Expression.new(value, scope).reduce
          rhs = Dagon::Ast::Expression.new(next_node, scope).reduce
          Dagon::Ast::Operation.new(:/, lhs, rhs).reduce
        when :exponentiation
          lhs = Dagon::Ast::Expression.new(value, scope).reduce
          rhs = Dagon::Ast::Expression.new(next_node, scope).reduce
          Dagon::Ast::Operation.new(:**, lhs, rhs).reduce
        when :call
          call = Dagon::Ast::Call.new([type, value, next_node], scope)
          call.run
        else
          error "Unknown type: #{type}"
        end
      end
    end

  end
end
