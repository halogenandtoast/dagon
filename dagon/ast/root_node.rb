module Dagon
  module Ast
    class RootNode < Node
      def initialize tree
        super nil, nil
        @tree = tree
      end

      def evaluate core = Ast::Core.new
        execute_list core, @tree
      end
    end
  end
end
