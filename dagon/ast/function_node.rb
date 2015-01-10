module Dagon
  module AST
    class Function < Node
      def initialize filename, line_number, function_name, params, body
        super filename, line_number
        @params = params.map(&:variable_name) # params must be unwrapped
        @body = body
        @function_name = function_name
      end

      def to_proc
        method(:call)
      end

      def call(interpreter, object, *args)
        if args.size < @params.size
          interpreter.curry(object, @function_name, self, *args)
        elsif args.size > @params.size
          interpreter.error("ArgumentError", "wrong number of arguments (#{args.size} for #{@params.size})")
        else
          frame = interpreter.frame
          args.each_with_index do |arg, index|
            frame[@params[index]] = arg
          end
          execute_list interpreter, @body
        end
      end
    end
  end
end
