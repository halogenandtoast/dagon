module Dagon
  class DCondition
    # Node is dup-ing the @ast, which breaks on DTrue/DFalse since they are singletons.
    # This can't be a Node until that is resolved.
    attr_reader :ast
    def initialize(ast)
      @ast = ast
    end

    def reduce
      if ast == true
        DTrue
      elsif ast == false
        DFalse
      else
        lhs, operation, rhs = *ast
        lhs.send(operation, rhs)
      end
    end
  end
end
