module Dagon
  module Core
    class Frame
      attr_reader :object, :frame_name
      def initialize object, frame_name
        @object = object
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
