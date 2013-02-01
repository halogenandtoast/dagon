require "core/vm"

module Dagon
  module Ast
    class RootNode < Node
      def initialize tree
        super nil, nil
        @tree = tree
        @vm = Dagon::Core::VM.new
      end

      def evaluate
        execute_list @vm, @tree
      end
    end
  end
end
