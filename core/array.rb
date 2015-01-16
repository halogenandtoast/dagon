module Dagon
  module Core
    class DG_Array < DG_Object
      attr_reader :value
      def initialize value, klass
        @value = value
        @klass = klass
      end

      def to_s
        '['+@value.map(&:inspect).join(', ')+']'
      end

      def inspect
        to_s
      end
    end

    class DG_ArrayClass < DG_Class
      def initialize
        super('Array', Dagon::Core::DG_Class.new)
      end

      def boot
        add_method 'init', ->(vm, ref, value) {
          ref.instance_variable_set('@value', value)
        }
        add_compiled_methods("array.rb", <<-DEF)
          [](index):
            DAGONVM.aref(self, index)
          []:(index, value):
            DAGONVM.aref-set(self, index, value)
          +(other):
            DAGONVM.primitive-add(self, other)
          =(other):
            DAGONVM.primitive-eq?(self, other)
        DEF
        add_method 'push', ->(vm, ref, value) {
          ref.value << value
          ref
        }
        add_method 'last', ->(vm, ref) {
          ref.value.last
        }
        add_method 'join', ->(vm, ref, glue) {
          vm.string(ref.value.map(&:to_s).join(glue.value))
        }
        add_method 'pop', ->(vm, ref) {
          ref.value.pop
        }
        add_method '-', ->(vm, ref, other) {
          result = ref.value.reject { |item| other.value.include?(item) }
          DG_Array.new(result, self)
        }
        add_method '*', ->(vm, ref, other) {
          DG_Array.new(ref.value * other.value, self)
        }
        add_method 'unshift', ->(vm, ref, object) {
          ref.value.unshift(object)
        }
        add_method 'shift', ->(vm, ref) {
          ref.value.shift
        }
        add_method 'empty?', ->(vm, ref) {
          ref.value.empty? ? Dtrue : Dfalse
        }
        add_method 'any?', ->(vm, ref) {
          ref.value.any? ? Dtrue : Dfalse
        }
        add_method 'length', ->(vm, ref) {
          vm.int(ref.value.length)
        }
        add_method 'inspect', ->(vm, ref) {
          vm.string(ref.inspect)
        }
        add_method 'reduce', ->(vm, ref, initial, block) {
          value = initial
          ref.value.each do |item|
            value = block.dagon_send(vm, "call", value, item)
          end
          value
        }
        add_method 'each', ->(vm, ref, block) {
          ref.value.each do |item|
            if block.arity == 1
              block.dagon_send(vm, 'call', item)
            else
              block.dagon_send(vm, 'call')
            end
          end
          ref
        }
      end

      def dagon_new interpreter, value = []
        if value.is_a? DG_Array
          DG_Array.new(value.value, self)
        else
          DG_Array.new(value, self)
        end
      end
    end
  end
end
