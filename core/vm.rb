require "core/object"
require "core/frame"

module Dagon
  module Core
    class VM
      def initialize main = nil
        @object = main || Dagon::Core::DG_Object.new
        @stack = []
        @stack.push Frame.new(@object, '(toplevel)')
      end

      def frame
        @stack.last
      end

      def push_frame frame
        @stack.push frame
        @object = frame.object
      end

      def pop_frame
        @stack.pop
        @object = frame.object
      end

      def dagon_define_class name, parent
        @object.dagon_define_class name, parent
      end

      def define_function name, block
        @object.add_method name, block
      end

    end
  end
end

