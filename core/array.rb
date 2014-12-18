module Dagon
  module Core
    class DG_Array < DG_Object
      attr_reader :list
      def initialize list, klass
        @list = list
        @klass = klass
      end

      def to_s
        '['+@list.map(&:to_s).join(', ')+']'
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
        add_method '[]', ->(vm, ref, index) {
          ref.list[index.value]
        }
        add_method '[]:', ->(vm, ref, index, value) {
          ref.list[index.value] = value
        }
        add_method 'push', ->(vm, ref, value) {
          ref.list << value
        }
        add_method 'last', ->(vm, ref) {
          ref.list.last
        }
        add_method 'pop', ->(vm, ref) {
          ref.list.pop
        }
        add_method '+', ->(vm, ref, other) {
          DG_Array.new(ref.list + other.list, self)
        }
        add_method '-', ->(vm, ref, other) {
          result = ref.list.reject { |item| other.list.include?(item) }
          DG_Array.new(result, self)
        }
        add_method '*', ->(vm, ref, other) {
          DG_Array.new(ref.list * other.value, self)
        }
        add_method '=', ->(vm, ref, other) {
          ref.list == other.list ? Dtrue : Dfalse
        }
        add_method 'compact', ->(vm, ref) {
          result = ref.list.reject{ |item| item == Dvoid }
          DG_Array.new(result, self)
        }
        add_method 'unshift', ->(vm, ref, object) {
          ref.list.unshift(object)
        }
        add_method 'shift', ->(vm, ref) {
          ref.list.shift
        }
        add_method 'empty', ->(vm, ref) {
          ref.list.empty? ? Dtrue : Dfalse
        }
        add_method 'length', ->(vm, ref) {
          vm.int(ref.list.length)
        }
        add_method 'inspect', ->(vm, ref) {
          vm.string(ref.inspect)
        }
        add_method 'each', ->(vm, ref, block) {
          ref.list.each do |item|
            if block.arity == 1
              block.dagon_send(vm, 'call', item)
            else
              block.dagon_send(vm, 'call')
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
