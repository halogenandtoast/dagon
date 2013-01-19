module Dagon
  module Ast
    class WhileStatement
      def reduce
        expect :while_statement
        @condition = next_node
        @block = Dagon::Ast::Block.new(next_node, scope).reduce

        while @condition.reduce != Dagon::Core::False
          @block.invoke
        end
      end
    end
  end
end
