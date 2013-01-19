module Dagon
  module Ast
    class Block < Dagon::Ast::Node
      def initialize(ast, scope, variables=[])
        super ast, scope
        @variables = variables
      end

      def reduce
        expect :block
        statements = next_node
        variables.shift
        variables.map! { |_, name| name }
        Dagon::Core::Block.new(statements, Dagon::Core::Scope.new({}, scope), variables)
      end

      private
      attr_accessor :variables
    end
  end
end
