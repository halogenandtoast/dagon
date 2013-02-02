module Dagon
  module Core
    class DG_Block < DG_Object
      attr_accessor :statements, :frame
      def initialize(statements, frame, klass)
        @statements = statements
        @frame = frame
        @klass = klass
      end
    end

    class DG_BlockClass < DG_Class
      def initialize
        super("Block", Dagon::Core::DG_Class.new)
      end

      def boot
        @class_methods[:new] = ->(_, _, statements, frame) { DG_Block.new(statements, frame, self) }
        add_method "call", ->(vm, instance) do
          vm.push_frame(instance.frame)
          result = instance.statements.map { |statement| statement.evaluate(vm) }.last
          vm.pop_frame
          result
        end
      end
    end
  end
end
