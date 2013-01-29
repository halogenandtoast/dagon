module Dagon
  module Ast
    class Core
      def initialize
        @function_table = {}
        @object = Dagon::Kernel.new(self) # TODO: replace with ours
        @stack = []
        @stack.push Frame.new '(toplevel)'
      end

      def frame
        @stack.last
      end

      def define_function function_name, node
        @function_table[function_name] = node
      end

      def call_function_or function_name, arguments
        call_dagon_function_or(function_name, arguments) {
          call_ruby_toplevel_or(function_name, arguments) {
            yield
          }
        }
      end

      def call_dagon_function_or function_name, arguments
        if function = @function_table[function_name]
          frame = Frame.new(function_name)
          @stack.push frame
          function.call self, frame, arguments
          @stack.pop
        else
          yield
        end
      end

      def call_ruby_toplevel_or function_name, arguments
        if @object.respond_to? function_name, true
          @object.send function_name, *arguments
        else
          yield
        end
      end
    end
  end
end
