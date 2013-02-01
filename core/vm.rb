require "core/object"
require "core/frame"
require "core/true"
require "core/false"
require "core/void"

Dtrue = Dagon::Core::True.instance
Dfalse = Dagon::Core::False.instance
Dvoid = Dagon::Core::Void.instance

require "pry"

module Dagon
  module Core
    class VM
      attr_reader :globals
      def initialize main = nil
        @object = main || Dagon::Core::DG_Object.new
        @stack = []
        @stack.push Frame.new(@object, '(toplevel)')
        @globals = {
          "$dagon_cwd" => $dagon_cwd
        }
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
        if @object.respond_to? :add_method
          @object.add_method name, block
        else
          @object.klass.add_method name, block
        end
      end

    end
  end
end

