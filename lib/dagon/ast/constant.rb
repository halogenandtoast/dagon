module Dagon
  module Ast
    class Constant < Dagon::Ast::Identifier
      def parse
        expect :constant
        @name = next_node
      end
    end
  end
end
