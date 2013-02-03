module Dagon
  module AST
    class InstanceInitNode < Node
      def initialize filename, line_number, klass_name, arguments, block
        super filename, line_number
        @klass_name = klass_name
        @arguments = arguments
        @block = block
      end

      def evaluate interpreter
        arguments = @arguments.map { |argument| argument.evaluate interpreter }
        if @block
          arguments << BlockNode.new(@filename, @line_number, @block, interpreter.frame)
        end

        object = interpreter.frame.object
        klass = object.dagon_const_get(@klass_name)
        if klass.respond_to? :dagon_new
          klass.dagon_new(interpreter, *arguments)
        else
          $stderr.puts "Cannot initialize object of type #{@klass_name}"
          exit(1)
        end
      end
    end
  end
end
