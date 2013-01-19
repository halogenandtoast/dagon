module Dagon
  module Ast
    class Condition < Dagon::Ast::Node
      # Node is dup-ing the @ast, which breaks on DTrue/DFalse since they are singletons.
      # This can't be a Node until that is resolved.

      def reduce
        if ast == true
          Dagon::Core::True
        elsif ast == false
          Dagon::Core::False
        else
          operation, lhs, rhs = *ast
          lhs = Objectifier.objectify(lhs, scope)
          rhs = Objectifier.objectify(rhs, scope)
          lhs.send(operation, rhs)
        end
      end

    end

    class Objectifier
      def self.objectify(ast, scope)
        case ast[0]
        when :integer
          Dagon::Core::Integer.new(ast[1])
        when :string
          Dagon::Core::String.new(ast[1])
        when :array
          Dagon::Core::Array.new(ast[1])
        when :identifier
          scope.lookup(ast[1])
        end
      end
    end
  end
end
