module Dagon
  class Block < Node
    def reduce
      type = next_node
      statements = next_node
      DBlock.new(statements, DBinding.new({}, binding))
    end
  end

  class DBlock
    def initialize code, binding
      @code = code
      @binding = binding
    end

    def invoke *args
      @code.each do |statement|
        Statement.new(statement, @binding).reduce
      end
    end
  end
end
