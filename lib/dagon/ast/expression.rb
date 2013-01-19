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
        when :true
          Dagon::Core::True.instance
        when :false
          Dagon::Core::False.instance
        when :call
          call = Dagon::Ast::Call.new([type, value, next_node], scope)
          call.run
        when :call_on_object
          call_node = next_node
          object = Expression.new(value, scope).reduce
          if object.binding == nil
            binding.pry
          end
          call = Call.new(call_node, object.binding)
          call.run
        else
          error "Unknown type: #{type}"
        end
      end
    end

  end
end
