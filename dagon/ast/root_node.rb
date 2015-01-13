require "core/vm"

module Dagon
  module AST
    class RootNode < Node
      def initialize tree
        super nil, nil
        @tree = tree
      end

      def evaluate vm
        execute_list vm, @tree
      end
    end
  end
end
