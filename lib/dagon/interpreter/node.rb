module Dagon
  class Node
    attr_reader :binding, :ast
    def initialize ast, binding
      @ast = ast
      @binding = binding
    end

    def next_node
      ast.shift
    end

    def error string
      binding.error string
    end
  end
end
