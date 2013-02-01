module Dagon
  module Ast
    class Program < Dagon::Ast::Node
      def run
        expect :program

        statements = next_node
        statements.each do |node|
          Dagon::Ast::Statement.new(node, scope).compile
        end
      end
    end
  end
end
