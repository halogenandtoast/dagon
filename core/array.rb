module Dagon
  module Core
    class DG_Array < DG_Object
      attr_reader :list
      def initialize list
        @list = list
        @klass = DG_Array_Class.new
      end

      def to_s
        "["+@list.map(&:to_instance).join(", ")+"]"
      end

      def to_instance
        "#{to_s}:Array"
      end
    end

    class DG_Array_Class < DG_Class
      def initialize
        super("Array", Dagon::Core::DG_Class.new)
        @class_methods[:new] = ->(vm, ref, *args) { DG_Array.new(*args) }
        boot
      end

      def boot
        add_method "init", ->(vm, ref, value) {
          ref.instance_variable_set("@value", value)
        }
        add_method "[]", ->(vm, ref, index) {
          ref.list[index.value]
        }
        add_method "+", ->(vm, ref, other) {
          DG_Array.new(ref.list + other.list)
        }
        add_method "=", ->(vm, ref, other) {
          ref.list == other.list ? Dtrue : Dfalse
        }
      end
    end
  end
end
