module Dagon
  module Ast
    class Constant < Dagon::Ast::Identifier
      def compile
        expect :constant
        @name = next_node
      end
    end
  end
end
