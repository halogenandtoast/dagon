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

      def dagon_const_get constant
        @klass.dagon_const_get(constant)
      end

      def dagon_send name, *args
        method = @klass.get_method(name)
        method.call(self, *args)
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
