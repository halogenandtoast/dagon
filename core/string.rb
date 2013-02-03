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
          ref.klass.dagon_send(vm, :new, ref.value + other.value)
        }
        add_method "=", ->(vm, ref, other) {
          ref.value == other.value ? Dtrue : Dfalse
        }
        add_method "!=", ->(vm, ref, other) {
          ref.value != other.value ? Dtrue : Dfalse
        }
        add_method 'length', ->(vm, ref) {
          vm.get_class("Integer").instance(ref.value.length)
        }
        add_method 'to-i', ->(vm, ref) {
          vm.get_class("Integer").instance(ref.value.to_i)
        }
        add_method 'to-f', ->(vm, ref) {
          vm.get_class("Float").instance(ref.value.to_f)
        }
      end
    end
  end
end
