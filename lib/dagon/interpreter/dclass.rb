module Dagon
  class DConstant < Identifier
    def parse
      if (node = next_node) != :constant
        error "Invalid identifier #{node}"
      end
      @name = next_node
    end
  end

  class ClassDefinition
    def initialize name, block, scope
      @name = name
      @block = block
      @scope = scope
    end

    def define
      dclass = DClass.new(@name, @block, @scope)
      @scope.define @name, dclass
    end
  end

  class DClass
    def initialize name, block, scope
      @name = name
      @block = block
      @scope = scope
    end
  end
end
