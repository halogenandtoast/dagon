require 'singleton'

module Dagon
  module Core
    class DAGONVM < DG_Object
      attr_reader :value
      include Singleton
      def initialize
        @value = true
        @klass = DG_DAGONVMClass.new
      end

      def inspect
        "true"
      end

      def to_s
        "true"
      end
    end

    class DG_DAGONVMClass < DG_Class
      undef :dagon_new
      def initialize
        super("DAGONVM", Dagon::Core::DG_Class.new)
      end

      def boot
        add_method 'set-value', ->(vm, ref, object, native) {
          object.value = native
          object
        }
        add_method 'native-send', ->(vm, ref, method, args, native) {
          value = native.send(method.value.to_sym, args.value)
          vm.cast(value)
        }

        add_method 'primitive-add', ->(vm, ref, left, right) {
          vm.cast(left.value + right.value)
        }
        add_method 'primitive-eq?', ->(vm, ref, left, right) {
          vm.bool(left.value == right.value)
        }
        add_method 'primitive-neq?', ->(vm, ref, left, right) {
          vm.bool(left.value != right.value)
        }
        add_method 'aref', ->(vm, ref, object, index) {
          if object.value[index.value]
            vm.cast(object.value[index.value])
          else
            vm.error("NullReferenceError", "no element exists at #{index.value}")
          end
        }
        add_method 'aref-set', ->(vm, ref, object, index, value) {
          object.value[index.value] = value
        }
        add_method 'aref-del', ->(vm, ref, object, index) {
          object.value.delete_at(index.value)
        }
        add_method 'hash-keys', ->(vm, ref, object) {
          vm.array(object.value.keys.map { |key| vm.string(key) })
        }
      end
    end
  end
end
