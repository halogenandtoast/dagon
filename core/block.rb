module Dagon
  module Core
    class DG_Block < DG_Object
      attr_accessor :statements, :frame
      def initialize(statements, frame)
        @statements = statements
        @frame = frame
        @klass = DG_Block_Class.new
      end
    end

    class DG_Block_Class < DG_Class
      def initialize
        super("Block", Dagon::Core::DG_Class.new)
        @class_methods[:new] = ->(_, _, *args) { DG_Block.new(*args) }
        boot
      end

      def boot
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
