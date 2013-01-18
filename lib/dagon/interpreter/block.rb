module Dagon
  class Block < Node
    def reduce
      type = next_node
      statements = next_node
      DBlock.new(statements, DScope.new({}, scope))
    end
  end

  class DBlock < DObject
    def initialize code, scope
      @code = code
      @scope = scope
    end

    def invoke *args
      @code.each do |statement|
        Statement.new(statement, scope).reduce
      end
    end
  end
end
