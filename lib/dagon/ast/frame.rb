module Dagon
  module Ast
    class Frame
      attr_reader :frame_name
      def initialize frame_name
        @frame_name = frame_name
        @local_variables = {}
      end

      def local_variable? name
        @local_variables.key? name
      end

      def [](key)
        @local_variables[key]
      end

      def []=(key, value)
        @local_variables[key] = value
      end
    end
  end
end
