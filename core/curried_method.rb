module Dagon
  module Core
    class DG_CurriedMethod < DG_Object
      attr_reader :dg_binding, :name, :args
      def initialize dg_binding, name, function, args, klass
        @dg_binding = dg_binding
        @name = name
        @function = function = function
        @klass = klass
        @args = args
      end

      def call(vm, *new_args)
        frame = Dagon::Core::Frame.new(dg_binding, name)
        vm.frame_eval frame do
          @function.call(vm, dg_binding, *(args + new_args))
        end
      end

      def to_s
        "<curry##{name}(#{@args.map(&:inspect).join(", ")})>"
      end

      def inspect
        to_s
      end
    end

    class DG_CurriedMethodClass < DG_Class
      def initialize
        super("CurriedMethod", Dagon::Core::DG_Class.new)
      end

      def boot
        add_method 'inspect', ->(vm, ref) {
          vm.string(ref.inspect)
        }
        add_method 'call', ->(vm, ref, *args) {
          ref.call(vm, *args)
        }
      end

      def dagon_new interpreter, dg_binding, name, function, args
        DG_CurriedMethod.new(dg_binding, name, function, args, self)
      end
    end
  end
end
