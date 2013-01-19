module Dagon
  module Ast
    class Block < Dagon::Ast::Node
      def reduce
        expect :block
        statements = next_node
        Dagon::Core::Block.new(statements, Dagon::Core::Scope.new({}, scope))
      end
    end
  end
end
