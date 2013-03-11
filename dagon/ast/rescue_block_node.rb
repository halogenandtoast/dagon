module Dagon
  module AST
    class RescueBlockNode < Node
      def initialize filename, line_number, block, errors_to_catch
        @block = block
        @errors_to_catch = errors_to_catch
      end

      def evaluate interpreter
        compiled_block = @block.evaluate(interpreter)
        if @errors_to_catch != nil
          @errors_to_catch.each do |error_to_catch|
            dagon_error = error_to_catch.evaluate(interpreter)
            interpreter.add_error_to_catch(dagon_error, compiled_block)
          end
        else
          interpreter.rescue_from_all_errors(compiled_block)
        end
      end
    end
  end
end
