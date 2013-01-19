module Dagon
  module Ast
    class WhileStatement < Dagon::Ast::Node
      def reduce
        expect :while_statement
        @condition = Expression.new(next_node, scope)
        @block = Dagon::Ast::Block.new(next_node, scope).reduce
        puts @condition.inspect

        while @condition.reduce != Dagon::Core::False.instance do
          @block.invoke
        end
      end
    end
  end
end
