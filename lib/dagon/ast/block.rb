module Dagon
  module Ast
    class Block < Dagon::Ast::Node
      def initialize ast, scope, args = []
        super(ast, scope)
        @args = args
      end

      def compile object_scope = nil
        expect :block
        statements = next_node
        object_scope ||= scope.dup
        Dagon::Core::Block.new(statements, object_scope, @args)
      end
    end
  end
end
