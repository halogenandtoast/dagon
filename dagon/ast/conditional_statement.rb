module Dagon
  module AST
    class ConditionalStatement < Dagon::AST::Node
      def compile
        expect :conditional_statement
        branches = next_node.map do |type, condition, block|
          [type, Dagon::AST::Condition.new(condition, scope), Dagon::AST::Block.new(block, scope).compile]
        end

        branches.each do |type, condition, block|
          if condition.compile == Dagon::Core::True.instance
            return block.invoke
          end
        end

        return Dagon::Core::Void.instance
      end
    end
  end
end
