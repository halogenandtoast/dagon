module Dagon
  class Statement
    attr_reader :node, :binding
    def initialize node, binding
      @node = node
      @binding = binding
    end

    def reduce
      case node[0]
      when :call
        call = Call.new(node, binding)
        call.run
      when :assignment
        name = Identifier.new(node[1], binding).to_sym
        value = Expression.new(node[2], binding).reduce
        assignment = Assignment.new(name, value, binding)
        assignment.define
      when :method_definition
        name = Identifier.new(node[1], binding).to_sym
        block = Block.new(node[2], binding).reduce
        assignment = Assignment.new(name, block, binding)
        assignment.define
      when :noop
      else
        error "Invalid statement #{node}"
      end
    end
  end
end
