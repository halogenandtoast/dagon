module Dagon
  class NodeError < StandardError; end
  class Node
    attr_reader :scope, :ast
    def initialize ast, scope
      @ast = ast.dup
      @scope = scope
    end

    def next_node
      ast.shift
    end

    def error string
      scope.error string
    end

    def expect *types
      type = next_node
      unless types.include? type
        error "#{type} is not of type #{types.join(",")}"
        raise Dagon::NodeError.new("")
      end
    end
  end
end
