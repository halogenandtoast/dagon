module Dagon
  class Block < Node
    def reduce
      expect :block
      statements = next_node
      DBlock.new(statements, DScope.new({}, scope))
    end
  end

  class DBlock < DObject
    def initialize statements, scope
      @statements = statements
      @scope = scope
    end

    def invoke *args
      statements.each do |statement|
        Statement.new(statement, scope).reduce
      end
    end

    private

    attr_reader :scope, :statements
  end
end
