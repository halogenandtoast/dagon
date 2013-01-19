module Dagon
  module Core
    class UndefinedError < StandardError; end
    class Scope
      attr_reader :defines
      def initialize object, parent_scope = NullScope.new
        @object = object
        @parent_scope = parent_scope
        @defines = {}
        object.public_methods(false).map do |method|
          dagon_method = Dagon::Core::Method.new(method) { |*args| object.send(method, *args) }
          @defines[method] = dagon_method
        end
      end

      def error string
        $stderr.puts string
      end

      def define name, value
        defines[name] = value
      end

      def lookup name
        begin
          defines.fetch(name.to_sym) { @parent_scope.lookup(name) }
        rescue UndefinedError
          error("Undefined variable or method #{name} for #<#{@object.class}:#{@object}>")
          raise
        end
      end

      def to_s
        defines.keys.inspect
      end
    end

    class NullScope
      def lookup name
        raise UndefinedError
      end
    end
  end
end
