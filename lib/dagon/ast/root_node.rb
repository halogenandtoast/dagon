module Dagon
  module Ast
    class RootNode < Node
      def inititalize tree
        super nil, nil
        @tree = tree
      end

      def evaluate
        execute_list Core.new, @tree
      end
    end
  end
end
