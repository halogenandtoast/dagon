module Dagon
  module Core
    class DG_Error < DG_Object
      attr_reader :message
      def initialize message, klass
        @message = message
        @klass = klass
      end

      def to_s
        "#{@klass}: #{@message}"
      end

      def printable_error(vm)
        vm.get_class("String").dagon_new(vm, to_s)
      end
    end

    class DG_ErrorClass < DG_Class
      def initialize name = "Error", klass = Dagon::Core::DG_Class.new
        super(name, klass)
      end

      def boot
        add_method "message", ->(vm, ref) {
          ref.message
        }
        add_method "to-s", ->(vm, ref) {
          ref.message
        }
        add_class_method "raise", ->(vm, ref, message="") {
          error = dagon_new(vm, message)
          vm.dg_raise(error)
        }
      end

      def dagon_new interpreter, value
        DG_Error.new(value, self)
      end
    end

    class DG_NoMethodErrorClass < DG_ErrorClass
      def initialize
        super("NoMethodError")
      end
    end
  end
end
