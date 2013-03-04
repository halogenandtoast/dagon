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
    end

    class DG_BlockClass < DG_Class
      def initialize
        super("Block", Dagon::Core::DG_Class.new)
      end

      def boot
        add_method "call", ->(vm, instance, *args) {
          frame = instance.frame.dup
          instance.arguments.each_with_index { |variable_name, index| frame[variable_name] = args[index] }
          vm.frame_eval(frame) {
            return_value = nil
            instance.statements.map { |statement|
              unless frame.popped?
                return_value = statement.evaluate(vm)
              end
            }
            return_value
          }
        }
      end

      def dagon_new interpreter, statements, frame, arguments
        DG_Block.new(statements, frame, arguments, self)
      end
    end
  end
end
