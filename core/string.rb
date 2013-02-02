module Dagon
  module Core
    class DG_String < DG_Object
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
        %{"#{@value}"}
      end
    end

    class DG_StringClass < DG_Class
      def initialize
        super("String", Dagon::Core::DG_Class.new)
      end

      def boot
        @class_methods[:new] = ->(vm, ref, args) { DG_String.new(args, self) }
        add_method "init", ->(vm, ref, value) {
          ref.instance_variable_set("@value", value)
        }
        add_method "+", ->(vm, ref, other) {
          left = ref.instance_variable_get("@value")
          right = other.instance_variable_get("@value")
          ref.klass.dagon_send(vm, :new, left + right)
        }
        add_method "=", ->(vm, ref, other) {
          left = ref.instance_variable_get("@value")
          right = other.instance_variable_get("@value")
          left == right ? Dtrue : Dfalse
        }
        add_method "!=", ->(vm, ref, other) {
          left = ref.instance_variable_get("@value")
          right = other.instance_variable_get("@value")
          left != right ? Dtrue : Dfalse
        }
      end
    end
  end
end
