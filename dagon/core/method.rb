module Dagon
  module Core
    class Method
      def initialize name, &block
        @name = name
        @block = block
      end

      def invoke *args
        @block.call(*args)
      end

      def compile
        invoke
      end
    end
  end
end
