module Dagon
  module Core
    class DG_Array < DG_Object
      attr_reader :list
      def initialize list, klass
        @list = list
        @klass = klass
      end

      def to_s
        "["+@list.map(&:to_instance).join(", ")+"]"
      end

      def to_instance
        "#{to_s}:Array"
      end
    end

    class DG_ArrayClass < DG_Class
      def initialize
        super("Array", Dagon::Core::DG_Class.new)
      end

      def boot
        @class_methods[:new] = ->(vm, ref, value) { DG_Array.new(value, self) }
        add_method "init", ->(vm, ref, value) {
          ref.instance_variable_set("@value", value)
        }
        add_method "[]", ->(vm, ref, index) {
          ref.list[index.value]
        }
        add_method "+", ->(vm, ref, other) {
          DG_Array.new(ref.list + other.list, self)
        }
        add_method "-", ->(vm, ref, other) {
          DG_Array.new(ref.list - other.list, self)
        }
        add_method "=", ->(vm, ref, other) {
          ref.list == other.list ? Dtrue : Dfalse
        }
      end
    end
  end
end
