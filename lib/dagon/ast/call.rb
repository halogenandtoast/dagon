module Dagon
  module Ast
    class Call < Dagon::Ast::Node
      def run
        expect :call

        identifier = Dagon::Ast::Identifier.new(next_node, scope)
        args = next_node[1].map { |node| node.compile }
        block = next_node
        method = identifier.lookup
        if block
          compiled_block = block.compile
          callable = ->(*args) { compiled_block.invoke(*args) }
          method.call(*args, &callable)
        else
          method.call(*args)
        end
      end

    end
  end
end
