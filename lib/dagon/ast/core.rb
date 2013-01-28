module Dagon
  module Ast
    class Core
      def initialize
        @function_table = {}
        @object = Object.new # TODO: replace with ours
        @stack = []
        @stack.push Frame.new '(toplevel)'
      end

      def frame
        @stack.last
      end

      def define_function function_name, node
        @function_table[function_name] = node
      end


    end
  end
end
