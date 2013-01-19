module Dagon
  module Ast
    class ConditionalStatement < Dagon::Ast::Node
      def reduce
        expect :conditional_statement
        branches = next_node.map do |type, condition, block|
          [type, Dagon::Ast::Condition.new(condition, scope), Dagon::Ast::Block.new(block, scope).reduce]
        end

        branches.each do |type, condition, block|
          if value = condition.reduce
            return value
          end
        end
      end
    end
  end
end
