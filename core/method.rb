module Dagon
  module Core
    class DG_Method < DG_Object
      attr_reader :dg_binding, :name
      def initialize dg_binding, name, code, klass
        @dg_binding = dg_binding
        @name = name
        @code = code
        @klass = klass
      end

      def call(vm, *args)
        frame = Dagon::Core::Frame.new(dg_binding, name)
        vm.frame_eval frame do
          @code.call(vm, dg_binding, *args)
        end
      end

      def to_s
        "<method##{name}>"
      end

      def inspect
        "<method##{name}>"
      end
    end

    class DG_MethodClass < DG_Class
      def initialize
        super("Method", Dagon::Core::DG_Class.new)
      end

      def boot
        add_method 'inspect', ->(vm, ref) {
          vm.string(ref.inspect)
        }
        add_method 'call', ->(vm, ref, *args) {
          ref.call(vm, *args)
        }
      end

      def dagon_new interpreter, dg_binding, name, code
        DG_Method.new(dg_binding, name, code, self)
      end
    end
  end
end
