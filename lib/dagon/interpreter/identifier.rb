module Dagon
  class Identifier < Node
    def initialize ast, scope
      super
      parse
    end
    def lookup
      scope.lookup(to_sym)
    end
    def parse
      if (node = next_node) != :identifier
        error "Invalid identifier #{node}"
      end
      @name = next_node
    end
    def to_sym
      @name.to_sym
    end
  end
end
