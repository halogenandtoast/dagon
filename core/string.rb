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
        add_method "init", ->(vm, ref, value) {
          ref.instance_variable_set("@value", value)
        }
        add_method "+", ->(vm, ref, other) {
          dagon_new(vm, ref.value + other.value)
        }
        add_method "concat", ->(vm, ref, other) {
          dagon_new(vm, ref.value + other.value)
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
        add_method 'inspect', ->(vm, ref) {
          vm.get_class("String").dagon_new(vm, ref.value.inspect)
        }
        add_method 'upcase', ->(vm, ref) {
          dagon_new(vm, ref.value.upcase)
        }
      end

      def dagon_new interpreter, string = ""
        DG_String.new(string, self)
      end
    end
  end
end
