module Dagon
  class Program < Node
    def run
      if next_node != :program
        error "Invalid program"
      end

      statements = next_node

      statements.each do |node|
        case node[0]
        when :call
          call = Call.new(node, binding)
          call.run
        when :assignment
          name = Identifier.new(node[1], binding).to_sym
          value = Expression.new(node[2], binding).reduce
          assignment = Assignment.new(name, value, binding)
          assignment.define
        else
          error "Invalid statement #{node}"
        end
      end
    end
  end
end
