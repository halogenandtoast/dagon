module Dagon
  module Core
    class DG_String < DG_Object
      attr_reader :value
      def initialize value, klass
        @value = value
        super(klass)
        begin
          set_instance_variable("@length", $vm.int(@value.length))
        rescue
          binding.pry
          raise
        end
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
        add_compiled_methods("string.rb", <<-DEF)
          +(other):
            DAGONVM.primitive-add(self, other)
          =(other):
            DAGONVM.primitive-eq?(self, other)
          !=(other):
            DAGONVM.primitive-neq?(self, other)
          length:
            @length
          [](index):
            DAGONVM.aref(self, index)
        DEF
        add_method 'strip', ->(vm, ref) {
          dagon_new(vm, ref.value.strip)
        }
        add_method 'to-i', ->(vm, ref) {
          vm.int(ref.value.to_i)
        }
        add_method 'to-f', ->(vm, ref) {
          vm.float(ref.value.to_f)
        }
        add_method 'inspect', ->(vm, ref) {
          dagon_new(vm, ref.value.inspect)
        }
        add_method 'upcase', ->(vm, ref) {
          dagon_new(vm, ref.value.upcase)
        }
        add_method 'contains?', ->(vm, ref, search) {
          ref.value.include?(search.value) ? Dtrue : Dfalse
        }
        add_method 'start-with?', ->(vm, ref, search) {
          ref.value.start_with?(search.value) ? Dtrue : Dfalse
        }
        add_method 'end-with?', ->(vm, ref, search) {
          ref.value.end_with?(search.value) ? Dtrue : Dfalse
        }
      end

      def dagon_new interpreter, string = ""
        DG_String.new(string, self)
      end
    end
  end
end
