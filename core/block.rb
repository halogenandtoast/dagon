module Dagon
  module Core
    class DG_Block < DG_Object
      attr_accessor :statements, :frame, :arguments
      def initialize(statements, frame, arguments, klass)
        @statements = statements
        @frame = frame
        @klass = klass
        @arguments = arguments
      end

      def arity
        @arguments.length
      end

      def call(vm, *args)
        a_frame = frame.dup
        arguments.each_with_index { |variable_name, index| a_frame[variable_name] = args[index] }
        vm.frame_eval(a_frame) {
          return_value = nil
          statements.map { |statement|
            unless a_frame.popped?
              return_value = statement.evaluate(vm)
            end
          }
          return_value
        }
      end
    end

    class DG_BlockClass < DG_Class
      def initialize
        super("Block", Dagon::Core::DG_Class.new)
      end

      def boot
        add_method "call", ->(vm, instance, *args) {
          instance.call(vm, *args)
        }
      end

      def dagon_new interpreter, statements, frame, arguments
        DG_Block.new(statements, frame, arguments, self)
      end
    end
  end
end
