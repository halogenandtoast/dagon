module Dagon
  class Program < Node
    def run
      if next_node != :program
        error "Invalid program"
      end

      statements = next_node

      statements.each do |node|
        Statement.new(node, binding).reduce
      end
    end
  end
end
