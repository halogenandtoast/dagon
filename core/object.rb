require "core/class"

module Dagon
  module Core
    class DG_Object
      attr_reader :klass
      def initialize klass = nil
        @ivars = {}
        @klass = klass || DG_Class.new
      end

      def dagon_define_class name, parent
        name = name.to_sym
        klass = DG_Class.new(name, parent)
        @klass.dagon_const_set(name, klass)
        klass
      end

      def dagon_const_set constant, value
        @klass.dagon_const_set(constant, value)
      end

      def dagon_const_get constant
        @klass.dagon_const_get(constant)
      end

      def dagon_send interpreter, name, *args
        method = @klass.get_method(name)
        if method
          frame = Frame.new(self, self)
          interpreter.frame_eval frame do
            method.call(interpreter, self, *args) || Dvoid
          end
        else
          if self == interpreter.top_object
            error_message = "undefined method '#{name}' for main:Object"
          else
            error_message = "undefined method '#{name}' for #{self.inspect}:#{self.klass.name}"
          end
          interpreter.error("NoMethodError", error_message)
        end
      end

      def set_instance_variable name, value
        @ivars[name.to_sym] = value
      end

      def get_instance_variable name
        @ivars[name.to_sym]
      end
    end
  end
end
