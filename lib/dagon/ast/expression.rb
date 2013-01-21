module Dagon
  module Ast
    class Expression < Node
      def compile
        type = next_node
        value = next_node
        result = case type
        when :identifier
          id = Dagon::Ast::Identifier.new([type, value], scope).lookup
          if id.is_a? ::Method
            id.call
          else
            id
          end
        when :integer
          Dagon::Core::Integer.new(value)
        when :array
          Dagon::Core::Array.new(value)
        when :string
          Dagon::Core::String.new(value)
        when :true
          Dagon::Core::True.instance
        when :false
          Dagon::Core::False.instance
        when :call
          args = next_node[1].map { |arg| Expression.new(arg, scope) }
          call = Dagon::Ast::Call.new([type, value, [:args, args]], scope)
          call.run
        when :object_call
          id = Identifier.new(value, scope)
          id.lookup
        when :call_on_object
          method_id = next_node
          args = next_node[1].map { |arg| Expression.new(arg, scope) }
          object = Expression.new(value, scope).compile
          call = Call.new([:call, method_id, [:args, args]], object.binding)
          call.run
        else
          error "Unknown type: #{type}"
        end
        reset
        result
      end
    end

  end
end
