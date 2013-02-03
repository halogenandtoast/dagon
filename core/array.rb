module Dagon
  module Core
    class DG_Array < DG_Object
      attr_reader :list
      def initialize list, klass
        @list = list
        @klass = klass
      end

      def to_s
        "["+@list.map(&:to_s).join(", ")+"]"
      end
    end

    class DG_ArrayClass < DG_Class
      def initialize
        super("Array", Dagon::Core::DG_Class.new)
      end

      def boot
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
          result = ref.list.reject { |item| other.list.include?(item) }
          DG_Array.new(result, self)
        }
        add_method "=", ->(vm, ref, other) {
          ref.list == other.list ? Dtrue : Dfalse
        }
        add_method "compact", ->(vm, ref) {
          result = ref.list.reject{ |item| item == Dvoid }
          DG_Array.new(result, self)
        }
        add_method "length", ->(vm, ref) {
          vm.get_class("Integer").instance(ref.list.length)
        }
        add_method "each", ->(vm, ref, block) {
          ref.list.each do |item|
            if block.arity == 1
              block.dagon_send(vm, "call", item)
            else
              block.dagon_send(vm, "call")
            end
          end
        }
      end

      def dagon_new interpreter, value = []
        if value.is_a? DG_Array
          DG_Array.new(value.list, self)
        else
          DG_Array.new(value, self)
        end
      end
    end
  end
end
