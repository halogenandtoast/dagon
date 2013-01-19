module Dagon
  module Ast
    class Statement
      attr_reader :node, :scope
      def initialize node, scope
        @node = node
        @scope = scope
      end

      def compile
        node = @node.dup
        case node[0]
        when :assignment
          name = Dagon::Ast::Identifier.new(node[1], scope).to_sym
          value = Dagon::Ast::Expression.new(node[2], scope).compile
          assignment = Dagon::Ast::Assignment.new(name, value, scope)
          assignment.define
        when :method_definition
          name = Dagon::Ast::Identifier.new(node[1], scope).to_sym
          args = node[2].map { |arg| arg[1] }
          block = Dagon::Ast::Block.new(node[3], scope, args).compile
          assignment = Dagon::Ast::Assignment.new(name, block, scope)
          assignment.define
        when :class_definition
          class_name = Dagon::Ast::Constant.new(node[1], scope).to_sym
          block = Dagon::Ast::Block.new(node[2], scope)
          class_definition = Dagon::Ast::ClassDefinition.new(class_name, block, scope)
          class_definition.define
        when :conditional_statement
          Dagon::Ast::ConditionalStatement.new(node, scope).compile
        when :while_statement
          Dagon::Ast::WhileStatement.new(node, scope).compile
        when :noop
        else
          Dagon::Ast::Expression.new(node, scope).compile
        end
      end
    end
  end
end
