module Dagon
  module AST

    class BeginBlockNode < Node
      def initialize filename, line_number, block, rescue_block
        super filename, line_number
        @block = block
        @rescue_block = rescue_block
      end

      def evaluate interpreter
        current_object = interpreter.current_object
        local_variables = interpreter.frame.local_variables
        frame = Dagon::Core::Frame.new(current_object, "begin", local_variables)
        interpreter.frame_eval(frame) do
          if @rescue_block
            @rescue_block.evaluate(interpreter)
          end
          @block.evaluate(interpreter).dagon_send(interpreter, "call")
        end
      end
    end
  end
end
