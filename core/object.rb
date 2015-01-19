require "core/class"

module Dagon
  module Core
    class DG_Object
      attr_reader :klass
      attr_accessor :value
      def initialize klass = nil
        @ivars = {}
        @value ||= self
        @klass = klass || DG_Class.new
      end

      def dagon_object?
        true
      end

      def to_s
        @klass.to_s
      end

      def eql? object
        self == object
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
          if method.arity > 0 && (args.length + 2) > method.arity
            interpreter.error("ArgumentError", "Wrong number of arguments for #{name} (#{args.length} for #{method.arity - 2})")
            return
          else
            frame = Frame.new(self, self)
            interpreter.frame_eval frame do
              method.call(interpreter, self, *args)
            end
          end
        else
          old_frame = interpreter.pop_frame
          if variable = interpreter.frame[name]
            if variable.respond_to?(:call)
              variable.call(interpreter, *args)
            else
              interpreter.error("NoMethodError", "#{name} is not a callable")
            end
          else
            interpreter.push_frame old_frame
            if self == interpreter.top_object
              error_message = "undefined method '#{name}' for main:Object"
            else
              error_message = "undefined method '#{name}' for #{self.inspect}:#{self.klass.name}"
            end
            interpreter.error("NoMethodError", error_message)
          end
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
