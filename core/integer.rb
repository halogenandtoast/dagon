module Dagon
  module Core
    class DG_Integer < DG_Object
      attr_reader :value
      def initialize value, klass
        @value = value
        @klass = klass
      end

      def == other
        value == other.value
      end

      def to_s
        @value
      end

      def inspect
        @value
      end
    end

    class DG_IntegerClass < DG_Class
      undef :dagon_new

      def initialize value = ""
        super("Integer", Dagon::Core::DG_Class.new)
      end

      def instance value
        DG_Integer.new(value, self)
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
        add_method "times", ->(vm, ref, block) {
          ref.value.times do
            block.call vm
          end
        }
        add_method "inspect", ->(vm, ref) {
          vm.string(ref.inspect)
        }
        add_method "to-s", ->(vm, ref) {
          vm.string(ref.value.to_s)
        }
        add_method "chr", ->(vm, ref) {
          vm.string(ref.value.chr)
        }
      end
    end
  end
end
