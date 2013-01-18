module Dagon
  class Statement
    attr_reader :node, :scope
    def initialize node, scope
      @node = node
      @scope = scope
    end

    def reduce
      case node[0]
      when :call
        call = Call.new(node, scope)
        call.run
      when :assignment
        name = Identifier.new(node[1], scope).to_sym
        value = Expression.new(node[2], scope).reduce
        assignment = Assignment.new(name, value, scope)
        assignment.define
      when :method_definition
        name = Identifier.new(node[1], scope).to_sym
        block = Block.new(node[2], scope).reduce
        assignment = Assignment.new(name, block, scope)
        assignment.define
      when :class_definition
        class_name = DConstant.new(node[1], scope).to_sym
        block = Block.new(node[2], scope).reduce
        class_definition = ClassDefinition.new(name, block, scope)
        class_definition.define
      when :conditional_statement
        ConditionChain.new(node, scope).reduce
      when :noop
      else
        Expression.new(node, scope).reduce
      end
    end
  end
end
