require "core/vm"

module Dagon
  module AST
    class RootNode < Node
      attr_accessor :vm
      def initialize tree
        super nil, nil
        @tree = tree
        @vm = Dagon::Core::VM.new
      end

      def evaluate vm = nil
        actual_vm = vm || @vm
        execute_list actual_vm, @tree
      end
    end
  end
end
