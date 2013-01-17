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
    def initialize name, block, binding
      @name = name
      @block = block
      @binding = binding
    end

    def define
      dclass = DClass.new(@name, @block, @binding)
      @binding.define @name, dclass
    end
  end

  class DClass
    def initialize name, block, binding
      @name = name
      @block = block
      @binding = binding
    end
  end
end
