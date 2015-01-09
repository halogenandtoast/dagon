module Dagon
  module AST
    class Function < Node
      def initialize filename, line_number, params, body
        super filename, line_number
        @params = params.map(&:variable_name) # params must be unwrapped
        @body = body
      end

      def to_proc
        method(:call)
      end

      def call(interpreter, object, *args)
        unless args.size == @params.size
          interpreter.error("ArgumentError", "wrong number of arguments (#{args.size} for #{@params.size})")
        end
        frame = interpreter.frame
        args.each_with_index do |arg, index|
          frame[@params[index]] = arg
        end
        execute_list interpreter, @body
      end
    end
  end
end
