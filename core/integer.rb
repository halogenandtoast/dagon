module Dagon
  module Core
    class DG_Integer < DG_Object
      attr_reader :value
      def initialize value
        @value = value
        @klass = DG_Integer_Class.new
      end

      def == other
        value == other.value
      end

      def to_s
        @value
      end

      def to_instance
        @value
      end

      def inspect
        @value
      end
    end

    class DG_Integer_Class < DG_Class
      def initialize value = ""
        super("Integer", Dagon::Core::DG_Class.new)
        @class_methods.delete(:new)
        boot
      end

      def instance value
        DG_Integer.new(value)
      end

      def boot
        add_method "+", ->(vm, ref, other) {
          left = ref.value
          right = other.value
          ref.klass.instance(left + right)
        }
        add_method "-", ->(vm, ref, other) {
          left = ref.value
          right = other.value
          ref.klass.instance(left - right)
        }
        add_method "*", ->(vm, ref, other) {
          left = ref.value
          right = other.value
          ref.klass.instance(left * right)
        }
        add_method "/", ->(vm, ref, other) {
          left = ref.value
          right = other.value
          ref.klass.instance(left / right)
        }
        add_method "**", ->(vm, ref, other) {
          left = ref.value
          right = other.value
          ref.klass.instance(left ** right)
        }
        add_method "=", ->(vm, ref, other) {
          left = ref.value
          right = other.value
          left == right ? Dtrue : Dfalse
        }
        add_method "!=", ->(vm, ref, other) {
          left = ref.value
          right = other.value
          left != right ? Dtrue : Dfalse
        }
        add_method ">", ->(vm, ref, other) {
          left = ref.value
          right = other.value
          left > right ? Dtrue : Dfalse
        }
        add_method ">=", ->(vm, ref, other) {
          left = ref.value
          right = other.value
          left >= right ? Dtrue : Dfalse
        }
        add_method "<", ->(vm, ref, other) {
          left = ref.value
          right = other.value
          left < right ? Dtrue : Dfalse
        }
        add_method "<=", ->(vm, ref, other) {
          left = ref.value
          right = other.value
          left <= right ? Dtrue : Dfalse
        }
        add_method "times", ->(vm, ref, block) {
          ref.value.times do
            block.evaluate vm
          end
        }
      end
    end
  end
end
