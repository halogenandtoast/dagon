module Dagon
  class DCondition < Node
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
