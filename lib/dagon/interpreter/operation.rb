module Dagon
  class Operation
    def initialize operator, lhs, rhs
      @operator = operator
      @lhs, @rhs = lhs, rhs
    end

    def reduce
      @lhs.send(@operator, @rhs)
    end
  end
end
