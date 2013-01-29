module Dagon
  module Ast
    class Function < Node
      def initialize filename, line_number, params, body
        super filename, line_number
        @params = params.map(&:variable_name) # params must be unwrapped
        @body = body
      end

      def call(interpreter, frame, args)
        unless args.size == @params.size
          $stderr.puts "Wrong"
          exit(1)
        end
        args.each_with_index do |arg, index|
          frame[@params[index]] = arg
        end
        execute_list interpreter, @body
      end
    end
  end
end
