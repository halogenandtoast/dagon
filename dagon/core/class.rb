module Dagon
  module Core
    class Class
      def initialize name, block, scope
        @name = name
        @block = block
        @scope = Dagon::Core::Scope.new(self, scope)
        @method_table = {}
      end

      def define_dagon_method name, code_block
        @method_table[name] = ->(*args) { code_block.invoke(*args) }
      end

      def binding
        @scope
      end

      def to_s
        @name
      end
    end
  end
end
