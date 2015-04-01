module Dagon
  module Core
    class DG_Decimal < DG_Object
      attr_reader :value
      def initialize value, klass
        @value = value
        @klass = klass
      end

      def == other
        value == other.value
      end

      def to_s
        @value.to_s("F")
      end

      def inspect
        @value.to_s("F")
      end
    end

    class DG_DecimalClass < DG_Class
      undef :dagon_new

      def initialize value = ""
        super("Decimal", Dagon::Core::DG_Class.new)
      end

      def instance value
        DG_Decimal.new(value, self)
      end

      def boot
        add_method "+", ->(vm, ref, other) {
          left = ref.value
          right = other.value
          instance(left + right)
        }
        add_method "-", ->(vm, ref, other) {
          left = ref.value
          right = other.value
          instance(left - right)
        }
        add_method "*", ->(vm, ref, other) {
          left = ref.value
          right = other.value
          instance(left * right)
        }
        add_method "/", ->(vm, ref, other) {
          left = ref.value
          right = other.value
          instance(left / right)
        }
        add_method "**", ->(vm, ref, other) {
          left = ref.value
          right = other.value
          instance(left ** right)
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
        add_method "inspect", ->(vm, ref) {
          ref.inspect
        }
      end
    end
  end
end
