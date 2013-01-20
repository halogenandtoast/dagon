module Dagon
  module Ast
    class WhileStatement < Dagon::Ast::Node
      def compile
        expect :while_statement
        @condition = Expression.new(next_node, scope)
        @block = Dagon::Ast::Block.new(next_node, scope).compile

        while @condition.compile != Dagon::Core::False.instance do
          @block.invoke
        end
      end
    end
  end
end
