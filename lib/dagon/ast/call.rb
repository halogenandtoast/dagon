module Dagon
  module Ast
    class Call < Dagon::Ast::Node
      def run
        expect :call
        identifier = Identifier.new(next_node, scope)
        args = next_node[1]
        method = identifier.lookup
        method.call(*args)
      end

    end
  end
end
