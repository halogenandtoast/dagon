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
        @class_methods[:new] = ->(_, _, statements, frame, arguments) { DG_Block.new(statements, frame, arguments, self) }
        add_method "call", ->(vm, instance, *args) do
          frame = instance.frame.dup
          instance.arguments.each_with_index { |variable_name, index| frame[variable_name] = args[index] }
          vm.push_frame(instance.frame)
          result = instance.statements.map { |statement| statement.evaluate(vm) }.last
          vm.pop_frame
          result
        end
      end
    end
  end
end
