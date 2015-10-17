module Dagon
  module AST
    class CaseAnyNode < Node
      def initialize filename, line_number
        super filename, line_number
      end

      def evaluate(_)
        AnyMatcher.new
      end
    end

    class AnyMatcher
      def ==(other)
        true
      end
    end
  end
end
