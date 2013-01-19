module Dagon
  class DCondition < Node
    # Node is dup-ing the @ast, which breaks on DTrue/DFalse since they are singletons.
    # This can't be a Node until that is resolved.

    def reduce
      if ast == true
        DTrue
      elsif ast == false
        DFalse
      else
        operation, lhs, rhs = *ast
        lhs = Objectifier.objectify(lhs, scope)
        rhs = Objectifier.objectify(rhs, scope)
        lhs.send(operation, rhs)
      end
    end

    def _while(dblock)
      while reduce != DFalse
        dblock.invoke
      end
    end
  end

  class Objectifier
    def self.objectify(ast, scope)
      case ast[0]
      when :integer
        DInteger.new(ast[1])
      when :string
        DString.new(ast[1])
      when :array
        DArray.new(ast[1])
      when :identifier
        scope.lookup(ast[1])
      end
    end
  end
end
