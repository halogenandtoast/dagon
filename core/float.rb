module Dagon
  module Core
    class DG_Float < DG_Object
      attr_reader :value
      def initialize value
        @value = value
        @klass = DG_Float_Class.new
      end

      def to_s
        @value
      end

      def inspect
        @value
      end
    end

    class DG_Float_Class < DG_Class
      def initialize value = ""
        super("Float", Dagon::Core::DG_Class.new)
        @class_methods.delete(:new)
        boot
      end

      def instance value
        DG_Float.new(value)
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
      end
    end
  end
end
