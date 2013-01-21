module Dagon
  module Ast
    class ArgumentList < Node
      def compile
        expect :args
        list = next_node
        list.map do |identifier|
          Identifier.new(identifier, scope)
        end
      end
    end
  end
end
