module Dagon
  module AST

    class BlockNode < Node
      def initialize filename, line_number, statements, frame
        super filename, line_number
        @statements = statements
        @frame = frame
      end

      def evaluate interpreter
        interpreter.push_frame @frame
        result = execute_list interpreter, @statements
        interpreter.pop_frame
        result
      end
    end
  end
end
