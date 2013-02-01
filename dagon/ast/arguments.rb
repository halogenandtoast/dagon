module Dagon
  module Ast
    class Arguments < Node
      def compile
        expect :args

        @arguments = next_node
        if @arguments.any? && @arguments.first.first == :assignment
          named_argument_list
        else
          argument_list
        end
      end

      private

      def named_argument_list
        pairs = @arguments.map do |argument|
          type, identifier, expression = argument
          if type != :assignment
            argument_type_error
          end
          name = Identifier.new(identifier, scope).to_sym
          value = Expression.new(expression, scope).compile
          [name, value]
        end
        [Hash[pairs]]
      end

      def argument_list
        @arguments.map do |argument|
          type = argument[0]
          if type == :assignment
            argument_type_error
          end
          return_value = Expression.new(argument, scope).compile
          if return_value.is_a? Proc
            return_value.call
          else
            return_value
          end
        end
      end

      def argument_type_error
        raise "Named and regular arguments cannot be mixed."
      end
    end
  end
end
