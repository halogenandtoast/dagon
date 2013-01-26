module Dagon
  module Ast
    class Identifier < Dagon::Ast::Node
      def initialize ast, scope
        super
        compile
      end
      def lookup
        scope.lookup(to_sym)
      end
      def compile
        expect :identifier
        @name = next_node
      end
      def to_sym
        @name.to_sym
      end
    end
  end
end
