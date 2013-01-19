module Dagon
  module Ast
    class Call < Dagon::Ast::Node
      def run
        expect :call

        identifier = Dagon::Ast::Identifier.new(next_node, scope)
        args = next_node[1].map { |node| node.compile }
        method = identifier.lookup
        method.invoke(*args)
      end

    end
  end
end
