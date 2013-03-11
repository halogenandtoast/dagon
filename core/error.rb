module Dagon
  module Core
    class DG_Error < DG_Object
      attr_reader :message, :filename, :line_number
      def initialize filename, line_number, message, klass
        @filename = filename
        @line_number = line_number
        @message = message
        @klass = klass
      end

      def to_s
        "#{filename}:#{line_number} #{@message} (#{@klass})"
      end

      def printable_error(vm)
        vm.string(to_s)
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
        DG_Error.new(interpreter.filename, interpreter.line_number, value, self)
      end
    end

    class DG_NoMethodErrorClass < DG_ErrorClass
      def initialize
        super("NoMethodError")
      end
    end

    class DG_ArgumentErrorClass < DG_ErrorClass
      def initialize
        super("ArgumentError")
      end
    end

    class DG_SyntaxErrorClass < DG_ErrorClass
      def initialize
        super("SyntaxError")
      end
    end

    class DG_LoadErrorClass < DG_ErrorClass
      def initialize
        super("LoadError")
      end
    end

    class DG_NameErrorClass < DG_ErrorClass
      def initialize
        super("NameError")
      end
    end
  end
end
