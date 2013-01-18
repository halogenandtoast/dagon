module Dagon
  class Program < Node
    def run
      expect :program

      statements = next_node
      statements.each do |node|
        Statement.new(node, scope).reduce
      end
    end
  end
end
