module Dagon
  module Core
    class Scope
      attr_reader :defines
      def initialize defines = {}, parent_scope = NullScope.new
        @parent_scope = parent_scope
        @defines = defines
      end

      def error string
        $stderr.puts string
      end

      def lookup name
        defines.fetch(name) { @parent_scope.lookup(name) }
      end

      def define name, value
        defines[name] = value
      end

      def to_s
        defines.keys.inspect
      end
    end

    class NullScope
      def lookup name
        error("Undefined variable or method #{name}")
      end
      def error string
        $stderr.puts string
        exit
      end
    end
  end
end
