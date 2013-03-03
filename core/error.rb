module Dagon
  module Core
    class DG_Error < DG_Object
      attr_reader :message
      def initialize message, klass
        @message = message
        @klass = klass
      end

      def to_s
        @message
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
        add_class_method "raise", ->(vm, ref, message="") {
          error = dagon_new(vm, message)
          vm.dg_raise(error)
        }
      end

      def dagon_new interpreter, value
        DG_Error.new(value, self)
      end
    end
  end
end
