module Dagon
  module Ast
    class Statement
      attr_reader :node, :scope
      def initialize node, scope
        @node = node
        @scope = scope
      end

      def reduce
        node = @node.dup
        case node[0]
        when :call
          call = Dagon::Ast::Call.new(node, scope)
          call.run
        when :assignment
          name = Dagon::Ast::Identifier.new(node[1], scope).to_sym
          value = Dagon::Ast::Expression.new(node[2], scope).reduce
          assignment = Dagon::Ast::Assignment.new(name, value, scope)
          assignment.define
        when :method_definition
          name = Dagon::Ast::Identifier.new(node[1], scope).to_sym
          block = Dagon::Ast::Block.new(node[3], scope, node[2]).reduce
          assignment = Dagon::Ast::Assignment.new(name, block, scope)
          assignment.define
        when :class_definition
          class_name = Dagon::Ast::Constant.new(node[1], scope).to_sym
          block = Dagon::Ast::Block.new(node[2], scope).reduce
          class_definition = Dagon::Ast::ClassDefinition.new(class_name, block, scope)
          class_definition.define
        when :conditional_statement
          Dagon::Ast::ConditionalStatement.new(node, scope).reduce
        when :while_statement
          Dagon::Ast::WhileStatement.new(node, scope).reduce
        when :noop
        else
          Dagon::Ast::Expression.new(node, scope).reduce
        end
      end
    end
  end
end
