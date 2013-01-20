module Dagon
  module Ast
    class Condition < Dagon::Ast::Node
      # Node is dup-ing the @ast, which breaks on DTrue/DFalse since they are singletons.
      # This can't be a Node until that is resolved.

      def compile
        Expression.new(ast, scope).compile
      end
    end
  end
end
