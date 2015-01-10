module Dagon
  module Core
    class DG_Function < DG_Object
      attr_reader :dg_binding, :name
      def initialize dg_binding, name, code, klass
        @dg_binding = dg_binding
        @name = name
        @code = code
        @klass = klass
      end

      def to_s
        "<fun##{name}>"
      end

      def inspect
        "<fun##{name}>"
      end
    end

    class DG_FunctionClass < DG_Class
      def initialize
        super("Function", Dagon::Core::DG_Class.new)
      end

      def boot
        add_method 'inspect', ->(vm, ref) {
          vm.string(ref.inspect)
        }
      end

      def dagon_new interpreter, binding, name, code
        DG_Function.new(binding, name, code, self)
      end
    end
  end
end
