module Dagon
  module Ast
    class ClassDefinition
      def initialize name, block, scope
        @name = name
        @block = block
        @scope = scope
      end

      def define
        dagon_class = Dagon::Core::Class.new(@name, @block, @scope.dup)
        block = @block.compile dagon_class.binding
        block.invoke
        @scope.define @name, dagon_class
      end
    end
  end
end
